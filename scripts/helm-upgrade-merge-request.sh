 #!/bin/sh
set -e

cat << EOF >> merge-request-values.yaml
ingress:
  hosts:
    - dev-app-client-$CI_MERGE_REQUEST_ID.staging.cluster.qover.io
  tls:
    - secretName: dev-app-client-$CI_MERGE_REQUEST_ID.staging.cluster.qover.io
      hosts:
        - dev-app-client-$CI_MERGE_REQUEST_ID.staging.cluster.qover.io
EOF


helm upgrade \
--install $DEPLOY_NAMESPACE-$RELEASE_NAME \
-f $PROJECT_PATH/deploy/env/$DEPLOY_NAMESPACE-values.yaml \
-f ./merge-request-values.yaml $PROJECT_PATH/deploy/ \
--set image.tag=$CI_COMMIT_SHORT_SHA \
--namespace=$DEPLOY_NAMESPACE \
--wait \
--tls --tls-ca-cert tiller-ca.crt --tls-cert tiller.crt --tls-key tiller.key