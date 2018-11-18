#!/bin/sh
set -ex

#export DEVPI_SERVERDIR=/mnt
#export DEVPI_CLIENTDIR=/tmp/devpi-client
[[ -f ${DEVPISERVER_SERVERDIR}/.serverversion ]] || initialize=yes


if [ "$*" == "init" ];then
    devpi-server --init
elif [ "$*" == "export" ];then
    devpi-server --export /export
elif [ "$*" == "import" ];then
    devpi-server --import /export
elif [ "$*" == "start" ];then
    if [[ $initialize = yes ]]; then
        devpi-server --init
    fi
    devpi-server
    if [[ $initialize = yes ]]; then
      devpi use http://${DEVPISERVER_HOST}:${DEVPISERVER_PORT}
      devpi login root --password=''
      devpi user -m root password="${DEVPI_PASSWORD}"
      devpi index -y -c public pypi_whitelist='*'
    fi
else
    exec "$@"
fi
