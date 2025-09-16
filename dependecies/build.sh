#!/usr/bin/env bash

set -euo pipefail

source $HOME/.cargo/env

# Blink
cd /root/.local/share/nvim/site/pack/packer/start/blink.cmp

cargo build --release
