#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Defaults
#
# OS: debian 11
#
# Grabs $1 (host) $2 (dir) and creates nginx conf default with certbot