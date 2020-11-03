  
.PHONY: all
all: help

help:
	@echo
	@echo "The following targets are commonly used:"
	@echo
	@echo "build    - Builds the code locally"
	@echo "clean    - Cleans the local build"
	@echo "docker   - Builds Docker images"
	@echo "push     - Pushes Docker images to a registry"
	@echo "check    - Runs code checking tools: lint, format, gosec, and vet"
	@echo "test     - Runs the unit tests"
	@echo

.PHONY: build
build: generate
	@$(foreach svc,$(shell ls cmd), CGO_ENABLED=0 GOOS=linux go build -o ./cmd/${svc}/bin/service ./cmd/${svc}/;)

.PHONY: generate
generate:
	go generate ./...

.PHONY: test
test:
	go test -count=1 -cover -race -timeout 30s -short ./...

.PHONY: docker
docker:
	SERVICE=cmd/test-build docker build -t test-build -f Dockerfile cmd/test-build/

.PHONY: push
push:
	docker push ${DOCKER_REPO}/test-build\:latest

.PHONY: tag
tag:
	docker tag test-build\:latest ${DOCKER_REPO}/test-build\:latest
