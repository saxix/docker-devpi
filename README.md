Devpi Dockerfile
================

This repository contains **Dockerfile** of [Devpi](http://doc.devpi.net/) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/scrapinghub/devpi/) published to the public [Docker Registry](https://index.docker.io/).

Packages
--------

- devpi-server==4.3.1
- devpi-client==3.0.1
- devpi-web==3.2.1
- [devpi-theme-16](https://github.com/saxix/devpi-theme-16)


Usage
-----

#### Run 

    $ docker run -d -p 3141:3141 -v <DATA_DIR>:/mnt saxix/devpi

#### Upgrade


    $ docker run  -v <DATA_DIR>:/mnt -v <EXPORT_DIR>:/export saxix/devpi:<OLD_VERSION> export
    $ docker run  -v <DATA_DIR>:/mnt -v <EXPORT_DIR>:/export saxix/devpi:lastest import



Devpi creates a user named `root` by default, its password can be set with
`DEVPI_PASSWORD` environment variable.
