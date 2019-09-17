 #!/bin/sh
set -e

helm upgrade \
--install $DEPLOY_NAMESPACE-$RELEASE_NAME \
-f $PROJECT_PATH/deploy/env/sandbox-values.yaml $PROJECT_PATH/deploy/ \
--set image.tag=$CI_COMMIT_SHORT_SHA \
--namespace=$DEPLOY_NAMESPACE \
--wait \
--tls --tls-ca-cert tiller-ca.crt --tls-cert tiller.crt --tls-key tiller.key