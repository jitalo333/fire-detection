#!/usr/bin/env bash

# Some distro requires that the absolute path is given when invoking lspci
# e.g. /sbin/lspci if the user is not root.
echo 'Looking for GPUs (ETA: 10 seconds)'
gpu=$(lspci | grep -i '.* vga .* nvidia .*')
shopt -s nocasematch
if [[ $gpu == *' nvidia '* ]]; then
  echo GPU found
  docker run -it --rm \
    --privileged=true \
    --mount "type=bind,src=$(pwd),dst=/tmp/" \
    --workdir /tmp/ \
    --gpus all \
    --ipc=host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --name fire-detection \
    -p 8881:8881 \
    fire-detection bash
else
  docker run -it --rm \
    --privileged=true \
    --mount "type=bind,src=$(pwd),dst=/tmp/" \
    --workdir /tmp/ \
    -p 8881:8881 \
    --name fire-detection \
    fire-detection bash
fi
