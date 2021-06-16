# Extremely simple HTTP server that responds on port 8000 with a hello message.

DOCKERHUB_ID:=ibmosquito
SERVICE_NAME:="web-hello-python"
SERVICE_VERSION:="1.0.0"
PATTERN_NAME:="pattern-web-hello-python"
ARCH:="amd64"
 
# Leave blank for open DockerHub containers
# CONTAINER_CREDS:=-r "registry.wherever.com:myid:mypw"
CONTAINER_CREDS:=

default: build run

build:
	docker build -t $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) .

dev: stop build
	docker run -it -v `pwd`:/outside \
          --name ${SERVICE_NAME} \
          -p 8000:8000 \
          $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) /bin/bash

run: stop
	docker run -d \
          --name ${SERVICE_NAME} \
          --restart unless-stopped \
          -p 8000:8000 \
          $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION)

test:
	@curl -sS http://127.0.0.1:8000

push:
	docker push $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) 

publish-service:
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        SERVICE_CONTAINER="$(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION)" \
        hzn exchange service publish -O $(CONTAINER_CREDS) -f service.json --pull-image

publish-pattern:
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        PATTERN_NAME="$(PATTERN_NAME)" \
	hzn exchange pattern publish -f pattern.json

stop:
	@docker rm -f ${SERVICE_NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKERHUB_ID)/$(SERVICE_NAME):$(SERVICE_VERSION) >/dev/null 2>&1 || :

agent-run:
	hzn register --pattern "${HZN_ORG_ID}/$(PATTERN_NAME)"

agent-stop:
	hzn unregister -f

.PHONY: build dev run push publish-service publish-pattern test stop clean agent-run agent-stop
