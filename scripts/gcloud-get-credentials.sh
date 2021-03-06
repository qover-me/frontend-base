 #!/bin/sh
set -e
# Write GCP service account private key into a file
echo $GCLOUD_SERVICE_KEY > $HOME/gcloud-service-key.json

echo "credentials env: $CREDENTIALS_ENV" 
echo "running in protected ref: $CI_COMMIT_REF_PROTECTED"

gcloud auth activate-service-account --key-file $HOME/gcloud-service-key.json
gcloud container clusters get-credentials $CREDENTIALS_ENV --zone europe-west1-b --project $GCLOUD_PROJECT_ID
