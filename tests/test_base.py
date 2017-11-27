# -*- coding: utf-8 -*-
from __future__ import absolute_import, unicode_literals

import os

import docker
from docker.errors import ImageNotFound

NAME = 'saxix/devpi:test'
base = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))


def aaa():
    pass

def teardown():
    client = docker.from_env()
    try:
        client.images.remove(image=NAME, force=True)
    except ImageNotFound:
        pass

def test_build():
    client = docker.from_env()
    client.images.build(path=base, tag=NAME, rm=True)

def test_run():
    client = docker.from_env()
    client.images.build(path=base, tag=NAME, rm=True)
    client.containers.run(NAME, ports={13141:3141}, detach=True)
