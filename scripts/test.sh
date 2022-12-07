#!/usr/bin/env bash

set -e

. ~/.nix-profile/etc/profile.d/nix.sh
dapp --verbose test
