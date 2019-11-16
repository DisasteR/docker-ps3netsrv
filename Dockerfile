# set alpine version
ARG ALPINE_VERSION=3.10

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.22.1.0"
ARG OVERLAY_ARCH="amd64"

# set PS3NETSRV version
ARG PS3NETSRV_REPO=https://github.com/aldostools/webMAN-MOD
ARG PS3NETSRV_DIR=_Projects_/ps3netsrv

FROM alpine:${ALPINE_VERSION} as builder

ARG PS3NETSRV_REPO
ARG PS3NETSRV_DIR

ENV PS3NETSRV_REPO=${PS3NETSRV_REPO} \
    PS3NETSRV_DIR=${PS3NETSRV_DIR}

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache \
    git \
    build-base \
    meson \
    mbedtls-dev && \
  echo "**** build ps3netsrv ****" && \
  git clone ${PS3NETSRV_REPO} /tmp/repo && \
  cd /tmp/repo/${PS3NETSRV_DIR} && \
  meson build --buildtype=release && \
  ninja -C build/


FROM alpine:${ALPINE_VERSION}

ARG OVERLAY_VERSION
ARG OVERLAY_ARCH
ARG PS3NETSRV_DIR

ENV OVERLAY_VERSION=${OVERLAY_VERSION} \
    OVERLAY_ARCH=${OVERLAY_ARCH} \
    PS3NETSRV_DIR=${PS3NETSRV_DIR}

COPY --from=builder /tmp/repo/${PS3NETSRV_DIR}/build/ps3netsrv /usr/local/bin/ps3netsrv

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    coreutils \
    shadow \
    tzdata \
    libstdc++ \
    mbedtls && \
  echo "**** add s6 overlay ****" && \
  curl -o /tmp/s6-overlay.tar.gz -L \
    "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
  tar xvzf /tmp/s6-overlay.tar.gz -C / && \
  echo "**** create abc user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

  # add local files
  COPY root/ /

  # ports and volumes
  EXPOSE 38008
  VOLUME /games

  ENTRYPOINT ["/init"]
