#!/bin/bash
# Build mcfly and run a dev environment bash for local mcfly testing

if ! this_dir=$(cd "$(dirname "$0")" && pwd); then
    exit $?
fi

MCFLY_BIN_PATH=`mktemp -d`
ln -s $(readlink -f $(find target/debug/deps/mcfly-* -maxdepth 1 -type f | grep -v '\.d')) $MCFLY_BIN_PATH/mcfly

rm -f target/debug/mcfly
rm -rf target/debug/deps/mcfly-*
cargo build
# For some reason, to get line numbers in backtraces, we have to run the binary directly.
HISTFILE=$HOME/.bash_history \
  PATH="$MCFLY_BIN_PATH:$PATH" \
  RUST_BACKTRACE=full \
  MCFLY_DEBUG=1 \
  exec /bin/bash --init-file "$this_dir/mcfly.bash" -i
