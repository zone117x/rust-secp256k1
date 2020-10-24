#!/bin/bash

set -e

script_path="$(dirname "$0")"
cd "$script_path"

rm -rf secp256k1-wasm
DOCKER_BUILDKIT=1 docker build \
  --progress=plain \
  -o secp256k1-wasm -f ./wasm.Dockerfile .
