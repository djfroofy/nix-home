#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
nix run --inputs-from . home-manager -- switch -b backup --flake '.#dsmather@linux'
