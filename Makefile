DATADIR?=/data/devpi_index
BACKUP?=/data/BACKUP

.PHONY: upgrade

clean:
	-@docker rm devpi
	-@docker rmi saxix/devpi:`cat VERSION`
	-@docker rmi saxix/devpi

build:
	docker build -t saxix/devpi:latest --force-rm --squash --rm  .

create:
	docker create --name devpi -p 3141:3141 -v ${DATADIR}:/mnt saxix/devpi

run:
	docker run -p 3141:3141 --rm -v ${DATADIR}:/mnt saxix/devpi


test:
	docker start --attach devpi

tag:
	echo `cat VERSION`
	docker tag saxix/devpi:latest saxix/devpi:`cat VERSION`

release:
	docker push saxix/devpi:latest
	version=`cat VERSION` docker push saxix/devpi:${version}


docker-cleanup:
	@if [ -n "$(docker ps -a -q)" ];then docker rm $(docker ps -a -q) -f;fi
	@# 1. Make sure that exited containers are deleted.
	-@docker rm -v `docker ps -a -q -f status=exited` 2>/dev/null
	@# 2. Remove unwanted ‘dangling’ images.
	-@docker rmi `docker images -f "dangling=true" -q`  2>/dev/null
	@# 3. Clean ‘vfs’ directory?
	-@docker volume rm `docker volume ls -qf dangling=true`  2>/dev/null

