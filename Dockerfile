# ARG SYNAPSE_VERSION="1.28.0"
FROM ghcr.io/mqsdk/synapse:latest

MAINTAINER Alexander Olofsson <ace@haxalot.com>

RUN set -eux \
 && apt-get update -yqq \
 && apt-get install -y --no-install-recommends \
    libjemalloc2 \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /synapse/config/conf.d /synapse/data /synapse/keys /synapse/tls \
 && addgroup --system --gid 666 synapse \
 && adduser --system --uid 666 --ingroup synapse --home /synapse/data --disabled-password --no-create-home synapse \
 && chown -R synapse:synapse /synapse/config /synapse/data /synapse/keys /synapse/tls

ADD log.yaml /synapse
ADD matrix-synapse.sh /matrix-synapse
ADD key-upload.sh /key-upload

EXPOSE 8008/tcp 8448/tcp
ENTRYPOINT [ "/matrix-synapse" ]
