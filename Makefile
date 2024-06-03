IMG?=ubuntu:22.04

.PHONY: all image

all: image

image:
	docker build . --build-arg="img=${IMG}" -t dev/${IMG}

