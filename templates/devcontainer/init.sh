#!/bin/bash

# some local environments used in devcontainer.json,
# we should check them before starting to build container.
# cuation: you can't set them in this file.
test -n "$DISPLAY" || (echo "DISPLAY not set" && false)
test -n "$HTTP_PROXY_HOST" || (echo "HTTP_PROXY_HOST not set" && false)
test -n "$HTTP_PROXY_PORT" || (echo "HTTP_PROXY_PORT not set" && false)
test -n "$STORAGE" || (echo "STORAGE not set" && false)
