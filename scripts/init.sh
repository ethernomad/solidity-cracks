#!/usr/bin/env bash

set -e

echo "*** Initializing Dapp Tools"

sh <(curl -L https://nixos.org/nix/install) --no-daemon
. ~/.nix-profile/etc/profile.d/nix.sh
curl https://dapp.tools/install | sh
