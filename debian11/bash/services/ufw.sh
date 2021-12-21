#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Default UFW
# (specific ports are updated on a script/service basis
#
# OS: debian 11

ufw default deny incoming
ufw default allow outgoing
