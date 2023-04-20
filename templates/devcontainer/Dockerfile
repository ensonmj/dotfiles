FROM ubuntu:22.04 AS base

USER root
WORKDIR /
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=nointeractive

ARG HTTP_PROXY_HOST
ARG HTTP_PROXY_PORT
ENV HTTP_PROXY_HOST=$HTTP_PROXY_HOST
ENV HTTP_PROXY_PORT=$HTTP_PROXY_PORT
ENV http_proxy="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
ENV HTTP_PROXY="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
ENV https_proxy="https://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
ENV HTTPS_PROXY="https://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"

RUN if [ -n "$HTTP_PROXY" -a -n "$HTTPS_PROXY" ]; \
    then echo "Acquire::http::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf && \
    echo "Acquire::https::Proxy \"$HTTPS_PROXY\";" >> /etc/apt/apt.conf; \
    fi

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    software-properties-common \
    sudo \
    locales \
    tzdata \
    vim \
    git \
    curl \
    wget \
    tar \
    zip \
    unzip \
    ccache \
    cmake \
    ninja-build \
    build-essential \
    connect-proxy \
    libiberty-dev libdwarf-dev libre2-dev \
    libz-dev libssl-dev libboost-all-dev \
    libcurl4-openssl-dev libjemalloc-dev \
    && rm -rf /var/lib/apt/lists/*

ARG TIMEZONE=PRC
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN groupadd -g 1000 vscode && \
  useradd -u 1000 -m -g vscode -s /bin/bash vscode && \
  echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode
