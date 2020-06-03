#!/bin/sh

set -e

echo "$INPUT_SERVICE_KEY" | base64 --decode > "$HOME"/gcloud.json

if [ "$INPUT_ENVVARS" ]
then
    ENV_FLAG="--set-env-vars $INPUT_ENVVARS"
else
    ENV_FLAG=""
fi
echo "ENV_FLAG"
echo $ENV_FLAG

gcloud auth activate-service-account --key-file="$HOME"/gcloud.json --project "$INPUT_PROJECT"
gcloud auth configure-docker

docker push "$INPUT_IMAGE"

gcloud run deploy "$INPUT_SERVICE" \
  --image "$INPUT_IMAGE" \
  --region "$INPUT_REGION" \
  --platform managed \
  --allow-unauthenticated \
  ${ENV_FLAG}
