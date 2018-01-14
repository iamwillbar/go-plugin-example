# Copyright (c) William Bartholomew. All rights reserved.
# Licensed under the MIT License.

# This assumes your GOPATH does not have an @ in it, if it does either hardcode this or use a different delimiter.
APP_DIR=`pwd | sed "s@$(GOPATH)@@"`
DOCKER_CMD=docker run -t --mount type=bind,source=$(GOPATH),target=/mnt/go --env GOPATH=$(GOPATH) -w /mnt/go$(APP_DIR)
BUILD_IMAGE=golang:1.9
BUILD_CMD=$(DOCKER_CMD) $(BUILD_IMAGE) go build
RUN_IMAGE=golang:1.9
RUN_ARGS=

.PHONY=clean test all
all: eng/eng.so chi/chi.so greeter

eng/eng.so:
	$(BUILD_CMD) --buildmode=plugin -o eng/eng.so eng/greeter.go

chi/chi.so:
	$(BUILD_CMD) --buildmode=plugin -o chi/chi.so chi/greeter.go

greeter:
	$(BUILD_CMD) greeter.go

clean:
	rm greeter chi/chi.so eng/eng.so

test: all
	$(DOCKER_CMD) $(RUN_IMAGE) /mnt/go$(APP_DIR)/greeter $(RUN_ARGS)
