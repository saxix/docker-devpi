FROM pstauffer/curl:latest as builder
ARG DEVELOP
ARG GITHUB_CREDENTIALS
ARG VERSION

RUN mkdir /code
ADD . /code

RUN set -o pipefail && if [ "${DEVELOP}" = "1" ]; then \
    echo "${VERSION}-develop"; \
    else \
    echo "Download package: https://github.com/saxix/docker-devpi/archive/${VERSION}.tar.gz" \
    && curl ${GITHUB_CREDENTIALS}: -L "https://github.com/saxix/docker-devpi/archive/${VERSION}.tar.gz" | tar -xzf - --strip-components=1; \
    fi

#FROM python:3.6.4
FROM alpine:3.5
COPY --from=builder /code /code
LABEL org.label-schema.name="" \
      org.label-schema.description="" \
      org.label-schema.url="" \
      org.label-schema.vcs-url="https://github.com/saxix/docker-devpi" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ARG BUILD_DATE
ARG PIPENV_PYPI_MIRROR
ARG PIPENV_ARGS
ARG VERSION

ADD src/entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD Pipfile /
ADD Pipfile.lock /

RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    python3 \
    py3-pip


RUN apk add --no-cache --virtual .build-deps \
    gcc \
    python3-dev \
    libffi-dev \
    musl-dev \
    bash \
    && pip3 install pipenv --upgrade

ENV DEVPISERVER_SERVERDIR "/data"
ENV DEVPISERVER_HOST "0.0.0.0"
ENV DEVPISERVER_PORT 3141

RUN set -ex \
    mkdir -p ${DEVPISERVER_SERVERDIR} /export \
    && pipenv install --system --deploy --ignore-pipfile $PIPENV_ARGS \
    && pip3 install devpi-web \
    && apk del .build-deps \
    && rm -r /root/.cache


EXPOSE 3141
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["start"]
