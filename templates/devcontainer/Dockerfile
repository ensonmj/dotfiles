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
ENV https_proxy="https://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
ENV HTTPS_PROXY="https://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"

RUN test -n "$HTTP_PROXY_HOST" && test -n "$HTTP_PROXY_PORT" && \
    echo "Acquire::http::Proxy \"http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT\";" > /etc/apt/apt.conf.d/01proxy.conf && \
    echo "Acquire::https::Proxy \"http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT\";" >> /etc/apt/apt.conf.d/01proxy.conf

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates locales tzdata sudo \
    build-essential curl git less net-tools \
    stow tar vim unzip wget zip && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ARG TIMEZONE=PRC
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

RUN groupadd -g 1000 vscode && \
  useradd -u 1000 -m -g vscode -s /bin/bash vscode && \
  echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode

ARG CPP
RUN if [ -n "$CPP" ]; \
    then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
        ccache cmake gdb ninja-build clang-format && \
        apt-get autoremove -y && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/*; \
    fi

ARG JAVA
ARG MAVEN_MIRROR_URL
RUN if [ -n "$JAVA" ]; \
    then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
        maven openjdk-8-jdk openjdk-8-source openjdk-8-doc && \
        apt-get autoremove -y && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/*; \
    fi && \
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
    echo $MAVEN_SETTINGS > /home/vscode/.m2/settings.xml
