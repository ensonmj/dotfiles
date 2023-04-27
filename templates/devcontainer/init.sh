#!/bin/bash

# this file used for init local enviroment before container is build.

export DISPLAY=$DISPLAY
export HTTP_PROXY_HOST=$HTTP_PROXY_HOST
export HTTP_PROXY_PORT=$HTTP_PROXY_PORT
export STORAGE=

# guard to make sure you modified this file firstly
test -n "$DISPLAY" || (echo "DISPLAY not set" && false)
test -n "$HTTP_PROXY_HOST" || (echo "HTTP_PROXY_HOST not set" && false)
test -n "$HTTP_PROXY_PORT" || (echo "HTTP_PROXY_PORT not set" && false)
test -n "$STORAGE" || (echo "STORAGE not set" && false)

