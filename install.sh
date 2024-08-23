#!/bin/bash

set -ex

bin/setup

# Use a special setup on spin
if [[ -n "$SPIN" ]]; then
  sudo -E bin/mitamae local --node-yaml node.yaml $@ recipes/spin/default.rb -l debug
  exit
fi

# Homebrew does not allow sudo.
case "$(uname)" in
  "Darwin")  bin/mitamae local --node-yaml node.yaml $@ recipes/default.rb -l debug;;
  *) sudo -E bin/mitamae local --node-yaml node.yaml $@ recipes/default.rb;;
esac
