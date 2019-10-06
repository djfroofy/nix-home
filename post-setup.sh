#!/usr/bin/env bash

nix-shell '<home-manager>' -A install
home-manager switch
