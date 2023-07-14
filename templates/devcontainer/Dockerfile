# syntax=docker/dockerfile:1
FROM ubuntu:20.04 AS base

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
ENV https_proxy="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
ENV HTTPS_PROXY="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"

RUN test -n "$HTTP_PROXY_HOST" && test -n "$HTTP_PROXY_PORT" && \
    echo "Acquire::http::Proxy \"http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT\";" >> /etc/apt/apt.conf && \
    echo "Acquire::https::Proxy \"http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT\";" >> /etc/apt/apt.conf

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    
# timezone, locale and sudo
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata locales sudo zsh

ARG TIMEZONE=PRC
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

RUN groupadd -g 1000 vscode && \
  useradd -u 1000 -m -g vscode -s /usr/bin/zsh vscode && \
  echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode

# common softwares
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl fontconfig git jq less netcat net-tools \
    stow tar unzip vim wget xz-utils zip
