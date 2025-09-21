IMAGE_TAG ?= v12

.PHONY: package protoc test

target_dir := target

clean:
	rm -rf gen
	rm -rf $(target_dir)
	mkdir -p $(target_dir)
	mkdir -p gen

PROTOC ?= ../bin/protoc

protoc:
	$(PROTOC) -I .. ../proto/*.proto --go_out=paths=source_relative:./gen --go-grpc_out=paths=source_relative:./gen

package: protoc compile build-container

build-container:
	docker build .. -t "buoyantio/$(svc_name):$(IMAGE_TAG)" --build-arg svc_name=$(svc_name)

build-multi-arch:
	docker buildx build .. -t "buoyantio/$(svc_name):$(IMAGE_TAG)" --build-arg svc_name=$(svc_name) \
		-f ../Dockerfile-multi-arch --platform linux/amd64,linux/arm64,linux/arm/v7 --push

compile:
	GOOS=linux go build -v -o $(target_dir)/$(svc_name) cmd/server.go

test:
	go test ./...

run:
	go run cmd/server.go
