#!/usr/bin/env bash

set -e

echo "*** Initializing Dapp Tools"

sh <(curl -L https://nixos.org/nix/install) --no-daemon
. ~/.nix-profile/etc/profile.d/nix.sh
curl https://dapp.tools/install | sh
nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_17
