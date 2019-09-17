 #!/bin/sh
set -e

sed -i "s|appVersion:.*|appVersion: \"$CI_COMMIT_SHORT_SHA\"|g" $PROJECT_PATH/deploy/Chart.yaml
kubectl get secrets/tiller-secret -n "$TILLER_NAMESPACE" -o "jsonpath={.data['ca\.crt']}" | base64 -d > tiller-ca.crt
kubectl get secrets/tiller-secret -n "$TILLER_NAMESPACE" -o "jsonpath={.data['tls\.crt']}" | base64 -d > tiller.crt
kubectl get secrets/tiller-secret -n "$TILLER_NAMESPACE" -o "jsonpath={.data['tls\.key']}" | base64 -d > tiller.key
helm init --client-only