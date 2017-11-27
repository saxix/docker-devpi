Devpi Dockerfile
================

A simple docker container that runs [Devpi](http://doc.devpi.net/)

Visit project page on the docker hub at: https://hub.docker.com/r/saxix/devpi/

This container provides:

- devpi-server==4.3.1
- devpi-client==3.0.1
- devpi-web==3.2.1
- [devpi-theme-16](https://github.com/saxix/devpi-theme-16)

## Getting the image

The preferred way (but using most bandwidth for the initial image) is to
get our docker trusted build like this:


```
docker pull saxix/devpi
```

To build the image yourself without apt-cacher (also consumes more bandwidth
since deb packages need to be refetched each time you build) do:

```
docker build -t saxix/devpi git://github.com/saxix/devpi
```

To build fron source code you need to clone this repo locally 

```
git clone git://github.com/saxix/devpi
docker build -t saxix/devpi .
```

## Environment variables


Devpi creates a user named `root` by default, its password can be set with
`DEVPI_PASSWORD` environment variable.

* -e DEVPI_PASSWORD=<PASSWORD> 


## Run


To create a running container do:
```
    $ docker run --detach \-p 3141:3141 --restart=always -v <DATA_DIR>:/mnt saxix/devpi
```

## Upgrade


    $ docker run  -v <DATA_DIR>:/mnt -v <EXPORT_DIR>:/export saxix/devpi:<OLD_VERSION> export
    $ docker run  -v <DATA_DIR>:/mnt -v <EXPORT_DIR>:/export saxix/devpi:lastest import


