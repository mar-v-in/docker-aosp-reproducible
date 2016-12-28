#!/bin/bash

if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi

groupadd -g $GROUP_ID -r aosp && \
useradd -u $USER_ID --create-home -r -g aosp aosp

mkdir -p /tmp/ccache /aosp
chown aosp:aosp /tmp/ccache /aosp

export HOME=/home/aosp

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
  args="bash"
fi

exec sudo -E -u aosp $args
