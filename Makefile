VERSION?=`cat VERSION`
DEVELOP?=1
BACKUP?=/data/BACKUP
USER=saxix
IMAGE=devpi
DOCKER_IMAGE=${USER}/${IMAGE}:${VERSION}

.PHONY: upgrade

clean:
	rm -fr ~build
	rm _Dockerfile

build:
	docker build \
		--build-arg DEVELOP=${DEVELOP} \
		--build-arg VERSION=${VERSION} \
		--force-rm \
		--squash \
		--rm  \
		-t ${USER}/${IMAGE}:${VERSION} \
		.
	docker images | grep ${USER}/${IMAGE}

.run:
	docker run \
	 		--rm \
			-p 3141:3141 \
			-v /data/storage/devpi/index:/data \
			-v $$PWD/~build/export:/export \
			${RUN_OPTIONS} \
			-t ${DOCKER_IMAGE} \
			${CMD}

run:
	RUN_OPTIONS="-it" $(MAKE) .run

shell:
	RUN_OPTIONS="-it" CMD="/bin/sh" $(MAKE) .run

test: clean build
	docker run -p 13141:3141 --rm -v ${DATADIR}:/mnt ${USER}/${IMAGE}:dev

release:
	pass docker/saxix | docker login -u saxix --password-stdin
	docker push ${USER}/${IMAGE}:${VERSION}
	docker push ${USER}/${IMAGE}:latest

local:
	DEVPISERVER_PORT=8000 \
	DEVPISERVER_SERVERDIR=./~build/data \
		devpi-server

