#!/bin/bash

set -x

export PATH="${HOME}/.cargo/bin:${PATH}"

make -C $(dirname $0) pyenv RUNFLAGS="$*"
make -C $(dirname $0) buildhash RUNFLAGS="$*"
make -C $(dirname $0) prepare RUNFLAGS="$*"
make -C $(dirname $0) develop RUNFLAGS="$*"
