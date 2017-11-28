DATADIR?=/data/devpi_index
BACKUP?=/data/BACKUP

.PHONY: upgrade

clean:
	-@docker rmi saxix/devpi:`cat VERSION`

build:
	docker build -t saxix/devpi:`cat VERSION` --force-rm --squash --rm  .

run:
	docker run -p 3141:3141 --rm -v ${DATADIR}:/mnt saxix/devpi:`cat VERSION`


test: clean build
	docker run -p 13141:3141 --rm -v ${DATADIR}:/mnt saxix/devpi:`cat VERSION`


tag: build
	echo `cat VERSION`
	docker tag saxix/devpi:latest saxix/devpi:`cat VERSION`


release: tag
	docker push saxix/devpi:latest
	docker push saxix/devpi:`cat VERSION`


docker-cleanup:
	@if [ -n "$(docker ps -a -q)" ];then docker rm $(docker ps -a -q) -f;fi
	@# 1. Make sure that exited containers are deleted.
	-@docker rm -v `docker ps -a -q -f status=exited` 2>/dev/null
	@# 2. Remove unwanted ‘dangling’ images.
	-@docker rmi `docker images -f "dangling=true" -q`  2>/dev/null
	@# 3. Clean ‘vfs’ directory?
	-@docker volume rm `docker volume ls -qf dangling=true`  2>/dev/null

