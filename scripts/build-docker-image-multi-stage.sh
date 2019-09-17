 #!/bin/sh
set -e
GCLOUD_IMAGE_NAME="eu.gcr.io/$GCLOUD_PROJECT_ID/$IMAGE_NAME"

docker info

docker login -u _json_key --password-stdin https://eu.gcr.io < $HOME/gcloud-service-key.json
docker pull "$GLOUD_IMAGE_NAME:latest" || true
docker pull "$GLOUD_IMAGE_NAME:builder" || true

docker build \
--target builder \
--cache-from "$GLOUD_IMAGE_NAME:builder" \
-t "$IMAGE_NAME:builder" \
-t "$GLOUD_IMAGE_NAME:builder" \
-f internal-apps/identity/Dockerfile "."

docker build \
  --cache-from "$GLOUD_IMAGE_NAME:builder" \
  --cache-from "$GLOUD_IMAGE_NAME:latest" \
  -t $IMAGE_NAME \
  -f $PROJECT_PATH/Dockerfile "."

docker push "$GLOUD_IMAGE_NAME:builder"

docker tag $IMAGE_NAME "$GLOUD_IMAGE_NAME:$CI_COMMIT_SHORT_SHA"
docker tag $IMAGE_NAME "$GLOUD_IMAGE_NAME:latest"

docker push "eu.gcr.io/$GCLOUD_PROJECT_ID/$IMAGE_NAME:$CI_COMMIT_SHORT_SHA"
docker push "eu.gcr.io/$GCLOUD_PROJECT_ID/$IMAGE_NAME:latest"