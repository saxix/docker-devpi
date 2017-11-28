FROM python:3

LABEL description='Devpi server.'
LABEL maintainer='s.apostolico@gmail.com'


RUN pip install \
    devpi-server==4.3.1 \
    devpi-client==3.1.0 \
    devpi-web==3.2.1 \
    devpi-theme-16

VOLUME /export
VOLUME /mnt

EXPOSE 3141
ADD VERSION /
ADD src/entrypoint.sh /
ADD src/export.sh /export.sh
ADD src/import.sh /import.sh

CMD ["/entrypoint.sh"]
