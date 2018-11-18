    # -*- coding: utf-8 -*-
from __future__ import absolute_import

import os
import shutil
from time import sleep
import pytest
import requests
import docker

NAME = 'saxix/devpi:test'
base = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
build = os.path.join(base, '~build')
export = os.path.join(build, 'export')
data = os.path.join(build, 'data')
data2 = os.path.join(build, 'data2')


def _mkdir(newdir):
    """works the way a good mkdir should :)
        - already exists, silently complete
        - regular file in the way, raise an exception
        - parent directory(ies) does not exist, make them as well
    """
    if os.path.isdir(newdir):
        pass
    elif os.path.isfile(newdir):
        raise OSError("a file with the same name as the desired "
                      "dir, '%s', already exists." % newdir)
    else:
        head, tail = os.path.split(newdir)
        if head and not os.path.isdir(head):
            _mkdir(head)
        if tail:
            os.mkdir(newdir)


def setup_module():
    _mkdir(export)
    _mkdir(data)
    _mkdir(data2)


def teardown_module():
    shutil.rmtree(build)


@pytest.fixture(scope="module")
def client():
    return docker.from_env()


@pytest.fixture(scope="module")
def image(client):
    client.images.build(path=base, tag=NAME, rm=True)
    yield client
    client.images.remove(NAME)


@pytest.fixture(scope="module")
def container(image, client):
    c = client.containers.run(NAME,
                              volumes={data: '/mnt'},
                              ports={3141: 13141},
                              remove=True,
                              detach=True)
    yield c
    c.stop()


def test_build():
    client = docker.from_env()
    client.images.build(path=base, tag=NAME, rm=True)


def test_run(image, client):
    c = client.containers.run(NAME,
                              volumes={data: '/mnt'},
                              ports={3141: 13141},
                              remove=True,
                              detach=True)
    c.stop()
    assert os.path.exists(os.path.join(data, '.serverversion'))


def test_export(image, client):
    client.containers.run(NAME,
                          command='/export.sh',
                          remove=True,
                          volumes={export: '/export',
                                   data: '/mnt'},
                          )
    assert os.path.exists(os.path.join(export, 'dataindex.json'))


def test_import(image, client):
    client.containers.run(NAME,
                          command='/import.sh',
                          remove=True,
                          volumes={export: '/export',
                                   data2: '/mnt'},
                          )

    assert os.path.exists(os.path.join(data2, '.sqlite'))


def test_client(container):
    sleep(5)
    res = requests.get("http://localhost:13141/+api")
    c = res.json()
    assert c["result"]["login"] == "http://localhost:13141/+login"
