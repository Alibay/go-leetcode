.PHONY: dep lint build vendor

# load env variables from .env
ENV_PATH ?= ./.env
ifneq ($(wildcard $(ENV_PATH)),)
    include .env
    export
endif

# service code
SERVICE = go-leetcode

# current version
DOCKER_TAG ?= latest
# docker registry url
DOCKER_URL =

export GOFLAGS=-mod=vendor

# Build commands =======================================================================================================

vendor:
	go mod vendor

dep:
	go env -w GOPRIVATE=github.com/Alibay/*
	go mod tidy

lint:
	go vet ./...
	go fmt ./...


build: lint ## builds the main
	@mkdir -p bin
	go build -o bin/$(SERVICE) cmd/main.go

artifacts: dep vendor build ## builds and generates all artifacts

# Tests commands =======================================================================================================

test: ## run the tests
	@echo "running tests (skipping stateful)"
	go test -count=1 ./...

test-with-coverage: ## run the tests with coverage
	@echo "running tests with coverage file creation (skipping integration)"
	go test -count=1 -coverprofile .testCoverage.txt -v ./...

test-integration: ## run the integration tests
	@echo "running integration tests"
	go test -count=1 -tags integration ./...

build-test-bin: ## recursively go through folders and build integration tests to binary files
	mkdir -p bin
	@echo Bulding test binary
	for path in $$(find . -name "*_test.go" -printf '%h\n' | sort -u ); do \
  		echo $$path; \
  		fn=$$(echo $$path | sed 's+/+_+g' | sed -e 's/\.//g'); \
  		fn=$$fn"_test"; \
  		go test -c -o ./bin/$$fn -tags integration $$path ; \
  		errorCode="$$?"; \
  		if [ "$$errorCode" -gt "0" ] ; then \
  			echo "\033[31mTest build failed!\033[0m" ; \
  			exit 1 ; \
  		fi; \
  	done

# Docker commands =======================================================================================================

docker-build: ## Build the docker images for all services (build inside)
	@echo Building images
	docker build . -f ./Dockerfile -t $(DOCKER_URL)/$(SERVICE):$(DOCKER_TAG) --build-arg SERVICE=$(SERVICE)

docker-build-test: ## Build the docker images for all services (build inside)
	@echo Building images
	docker build . -f ./Dockerfile-test -t $(DOCKER_URL)/$(SERVICE):$(DOCKER_TAG)_test --build-arg SERVICE=$(SERVICE)

docker-push: docker-build ## Build and push docker images to the repository
	@echo Pushing images
	docker push $(DOCKER_URL)/$(SERVICE):$(DOCKER_TAG)

docker-push-test: docker-build-test ## Build and push docker images to the repository
	@echo Pushing images
	docker push $(DOCKER_URL)/$(SERVICE):$(DOCKER_TAG)_test

docker-run:
	@echo Running container
	docker run $(DOCKER_URL)/$(SERVICE):$(DOCKER_TAG)

# CI/CD gitlab commands =================================================================================================
ci-check-mocks:
	@mv ./mocks ./mocks-init
	find . -maxdepth 1 -type d \( ! -path ./*vendor ! -name . \) -exec mockery --all --dir {} \;
	mockshash=$$(find ./mocks -type f -print0 | sort -z | xargs -r0 md5sum | awk '{print $$1}' | md5sum | awk '{print $$1}'); \
	mocksinithash=$$(find ./mocks-init -type f -print0 | sort -z | xargs -r0 md5sum | awk '{print $$1}' | md5sum | awk '{print $$1}'); \
	rm -fr ./mocks-init; \
	echo $$mockshash $$mocksinithash; \
	if ! [ "$$mockshash" = "$$mocksinithash" ] ; then \
	  echo "\033[31mMocks should be updated!\033[0m" ; \
	  exit 1 ; \
	fi

ci-check: ci-check-mocks

ci-build: test-with-coverage docker-push docker-push-test

ci-build-mr: test-with-coverage docker-build

ci-run-test-bin: ## executes all tests binary from inside test container
	@find . -name "*_test" -type f -exec sh -c {} \;
