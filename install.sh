#!/usr/bin/env bash

# This installs not only the Rust compiler fork with support for the Xtensa
# architecture but also the required Xtensa toolchain binaries. We save the
# required exports to a file for later processing, to handle around some
# weirdness with GitHub runners (see below for details). If a version number
# formatted following (our extended version of) semver is provided, attempt to
# install that version of the compiler.

set -eu

buildtargets="${1:-all}"
version="${2:-latest}"

args="-l debug --export-file $HOME/exports --targets ${buildtargets}"

if [[ "${version}" != "latest" ]]; then
  args="$args  --toolchain-version $version"
fi

$HOME/.cargo/bin/espup install $args

# With the required exports specified by the rust-build installation script
# saved to a file, we can simply `source` it to export said variables. GitHub
# runners are a bit strange, however, in that we need to update the
# `$GITHUB_PATH` variable instead of `$PATH` as we normally would. More details
# see: https://stackoverflow.com/a/68214331

#shellcheck source=/dev/null
source "$HOME/exports"
echo "$PATH" >>"$GITHUB_PATH"
echo "LIBCLANG_PATH=${LIBCLANG_PATH}" >>"$GITHUB_ENV"
