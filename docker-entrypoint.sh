 #!/bin/sh
set -e
# Write GCP service account private key into a file
echo $GCLOUD_SERVICE_KEY > ${HOME}/gcloud-service-key.json

/opt/google-cloud-sdk/bin/gcloud --quiet components update

/opt/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

/opt/google-cloud-sdk/bin/gcloud container clusters get-credentials ${CREDENTIALS_ENV} --zone europe-west1-b --project $GCLOUD_PROJECT_ID

exec "$@"
