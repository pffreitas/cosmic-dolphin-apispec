TIMESTAMP := $(shell date +%Y%m%d%H%M%S)
NPM_VERSION := 1.0.$(TIMESTAMP)

generate-ts-client:
	npx @openapitools/openapi-generator-cli generate \
		-i tsp-output/@typespec/openapi3/openapi.yaml \
		-g typescript-fetch \
		-o ./bin \
		--git-user-id=pffreitas \
		--git-repo-id=cosmic-dolphin-apispec \
		--additional-properties=npmName=@cosmic-dolphin/api,npmVersion=$(NPM_VERSION),supportsES6=true,typescriptThreePlus=true

generate-go-client:
	npx @openapitools/openapi-generator-cli generate \
		-i tsp-output/@typespec/openapi3/openapi.yaml \
		-g go \
		-o ./bin/go-client \
		--git-user-id=pffreitas \
		--git-repo-id=cosmic-dolphin-apispec \
		--additional-properties=packageName=cosmicdolphinapi

generate-all-clients: generate-ts-client generate-go-client