CLOUD_RUN_APP_NAME := cloudrun-simple-euw3
APP_REGION := europe-west3
APP_PROJECT := tc-test123-355708
IMAGE := europe-west3-docker.pkg.dev/tc-shared-355710/docker-cloudrun-simple-euw3/cloudrun-pgtest:$(shell git rev-parse --verify HEAD)

all: ci cloudrun

local:
	docker build --tag cloudrun-pgtest .
	docker run cloudrun-pgtest

ci:
	docker buildx build --platform linux/amd64,linux/arm64 --output=type=registry --tag ${IMAGE} .

cloudrun:
	gcloud run deploy ${CLOUD_RUN_APP_NAME} \
            --region="${APP_REGION}" \
            --project="${APP_PROJECT}" \
            --image="${IMAGE}" \
            --platform=managed \
            --memory=2048Mi