 #!/bin/sh
set -e
GCLOUD_IMAGE_NAME="eu.gcr.io/$GCLOUD_PROJECT_ID/$IMAGE_NAME"

docker info

docker login -u _json_key --password-stdin https://eu.gcr.io < $HOME/gcloud-service-key.json
docker pull "$GCLOUD_IMAGE_NAME:latest" || true
docker pull "$GCLOUD_IMAGE_NAME:builder" || true

docker build \
  --build-arg CI_COMMIT_SHORT_SHA \
  --target builder \
  --cache-from "$GCLOUD_IMAGE_NAME:builder" \
  -t "$IMAGE_NAME:builder" \
  -t "$GCLOUD_IMAGE_NAME:builder" \
  -f $PROJECT_PATH/Dockerfile "."

docker build \
  --build-arg CI_COMMIT_SHORT_SHA \
  --cache-from "$GCLOUD_IMAGE_NAME:builder" \
  --cache-from "$GCLOUD_IMAGE_NAME:latest" \
  -t $IMAGE_NAME \
  -f $PROJECT_PATH/Dockerfile "."

docker push "$GCLOUD_IMAGE_NAME:builder"

docker tag $IMAGE_NAME "$GCLOUD_IMAGE_NAME:$CI_COMMIT_SHORT_SHA"
docker tag $IMAGE_NAME "$GCLOUD_IMAGE_NAME:latest"

docker push "eu.gcr.io/$GCLOUD_PROJECT_ID/$IMAGE_NAME:$CI_COMMIT_SHORT_SHA"
docker push "eu.gcr.io/$GCLOUD_PROJECT_ID/$IMAGE_NAME:latest"