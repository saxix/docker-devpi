FROM python:3

LABEL version='4.3.0'
LABEL description='Devpi server.'



RUN pip install \
    devpi-server==4.3.0 \
    devpi-client==3.0 \
    devpi-web==3.2 \
    devpi-cleaner==0.2.0 \
    devpi-slack==0.1.2 \
    devpi-tools==0.4 \
    devpi-semantic-ui==0.2.2 \
    devpi-builder==3.0.0 \
    devpi-passwd-reset==1.0.0

VOLUME /mnt
EXPOSE 3141
ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
