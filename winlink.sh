#!/bin/bash

set -eu

export MSYS=winsymlinks:nativestrict

# Do check here for whether we're elevated

if [ -d $1 ]; then
    echo "Warning directories are weird"
fi

ln -sfn $1 $2
