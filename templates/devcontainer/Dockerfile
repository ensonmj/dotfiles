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
    ca-certificates tzdata locales sudo

ARG TIMEZONE=PRC
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

RUN groupadd -g 1000 vscode && \
  useradd -u 1000 -m -g vscode -s /bin/bash vscode && \
  echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode

# common softwares
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl git jq less net-tools stow tar unzip vim \
    wget zip zsh

ARG CPP
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    if [ -n "$CPP" ]; \
    then \
        apt-get update && apt-get install -y --no-install-recommends \
        ccache cmake gdb gdbserver ninja-build clang-format && \
        sed -i /kernel.yama.ptrace_scope/s/[0-9]$/0/g /etc/sysctl.d/10-ptrace.conf; \
    fi

ARG JAVA
ARG MAVEN_MIRROR_URL
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    if [ -n "$JAVA" ]; \
    then \
        apt-get update && apt-get install -y --no-install-recommends \
        maven openjdk-8-jdk openjdk-8-source openjdk-8-doc \
        openjdk-11-jdk openjdk-11-source openjdk-11-doc && \
        if [ -n "$MAVEN_MIRROR_URL" ]; \
        then \
          MAVEN_SETTINGS_TEMPLATE="<settings><mirrors><mirror><id>mavenmirror</id><mirrorOf>central</mirrorOf><name>MavenMirror</name><url>{{MAVEN_MIRROR_URL}}</url></mirror></mirrors><proxies><proxy><id>httpproxy</id><active>{{MAVEN_PROXY_ENABLE}}</active><protocol>http</protocol><host>{{MAVEN_PROXY_HOST}}</host><port>{{MAVEN_PROXY_PORT}}</port></proxy><proxy><id>httpsproxy</id><active>{{MAVEN_PROXY_ENABLE}}</active><protocol>https</protocol><host>{{MAVEN_PROXY_HOST}}</host><port>{{MAVEN_PROXY_PORT}}</port></proxy></proxies></settings>"; \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s@{{MAVEN_MIRROR_URL}}@$MAVEN_MIRROR_URL@g"); \
        else \
          MAVEN_SETTINGS_TEMPLATE="<settings><proxies><proxy><id>httpproxy</id><active>{{MAVEN_PROXY_ENABLE}}</active><protocol>http</protocol><host>{{MAVEN_PROXY_HOST}}</host><port>{{MAVEN_PROXY_PORT}}</port></proxy><proxy><id>httpsproxy</id><active>{{MAVEN_PROXY_ENABLE}}</active><protocol>https</protocol><host>{{MAVEN_PROXY_HOST}}</host><port>{{MAVEN_PROXY_PORT}}</port></proxy></proxies></settings>"; \
        fi && \
        if [ -n "$HTTP_PROXY_HOST" -a -n "$HTTP_PROXY_PORT" ]; \
        then \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s/{{MAVEN_PROXY_ENABLE}}/true/g"); \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s/{{MAVEN_PROXY_HOST}}/$HTTP_PROXY_HOST/g"); \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s/{{MAVEN_PROXY_PORT}}/$HTTP_PROXY_PORT/g"); \
        else \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s/{{MAVEN_PROXY_ENABLE}}/false/g"); \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s/{{MAVEN_PROXY_HOST}}/localhost/g"); \
          MAVEN_SETTINGS_TEMPLATE=$(echo $MAVEN_SETTINGS_TEMPLATE | sed "s/{{MAVEN_PROXY_PORT}}/8080/g"); \
        fi && \
        MAVEN_SETTINGS=$MAVEN_SETTINGS_TEMPLATE && \
        mkdir -p /root/.m2/ && \
        echo $MAVEN_SETTINGS > /root/.m2/settings.xml && \
        mkdir -p /home/vscode/.m2/ && \
        echo $MAVEN_SETTINGS > /home/vscode/.m2/settings.xml; \
    fi
