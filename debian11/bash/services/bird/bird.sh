#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# BIRD install
#
# OS: debian 11

apt update && apt install -y bird

# build and place bird.conf