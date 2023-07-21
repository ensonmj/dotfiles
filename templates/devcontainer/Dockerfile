# syntax=docker/dockerfile:1.4
FROM ubuntu:20.04 AS base

USER root
WORKDIR /
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=nointeractive

ARG HTTP_PROXY_HOST
ARG HTTP_PROXY_PORT
# ENV HTTP_PROXY_HOST=$HTTP_PROXY_HOST
# ENV HTTP_PROXY_PORT=$HTTP_PROXY_PORT

RUN <<EOF
if [[ -n "$HTTP_PROXY_HOST" && -n "$HTTP_PROXY_PORT" ]]; then
    cat <<EOS >> /etc/environment
HTTP_PROXY_HOST="$HTTP_PROXY_HOST"
HTTP_PROXY_PORT="$HTTP_PROXY_PORT"
http_proxy="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
HTTP_PROXY="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
https_proxy="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
HTTPS_PROXY="http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
EOS
    cat <<EOS >> /etc/apt/apt.conf
Acquire::http::Proxy "http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT";
Acquire::https::Proxy "http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT";
EOS
else
    sed -i 's|archive.ubuntu.com|mirrors.163.com|' /etc/apt/sources.list
    sed -i 's|security.ubuntu.com|mirrors.163.com|' /etc/apt/sources.list
fi
EOF

RUN <<EOF
rm -f /etc/apt/apt.conf.d/docker-clean
echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
EOF
    
# timezone, locale and sudo
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked <<EOF
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates tzdata locales sudo zsh
EOF

ARG TIMEZONE=PRC
RUN <<EOF
ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo $TIMEZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
EOF

RUN <<EOF
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
locale-gen
EOF

RUN <<EOF
groupadd -g 1000 vscode
useradd -u 1000 -m -g vscode -s /usr/bin/zsh vscode
echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode
EOF

# common softwares
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked <<EOF
apt-get install -y --no-install-recommends \
    build-essential curl fontconfig git jq less netcat net-tools \
    stow tar unzip vim wget xz-utils zip
EOF
