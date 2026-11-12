#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
nix flake metadata --no-write-lock-file
printf '%s\n' 'Bootstrap verified. Run ./post-setup.sh to activate.'
