#!/usr/bin/env bash

set -e

# Download and execute the installation script from the esp-rs/rust-build
# repository: https://github.com/esp-rs/rust-build
#
# This installs not only the Rust compiler fork with support for the Xtensa
# architecture but also the required Xtensa toolchain binaries. We save the
# required exports to a file for later processing, to handle around some
# weirdness with GitHub runners (see below for details).

curl -LO https://raw.githubusercontent.com/esp-rs/rust-build/main/install-rust-toolchain.sh
chmod +x ./install-rust-toolchain.sh
./install-rust-toolchain.sh --export-file "$HOME/exports"


# With the required exports specified by the rust-build installation script
# saved to a file, we can simply `source` it to export said variables. GitHub
# runners are a bit strange, however, in that we need to update the
# `$GITHUB_PATH` variable instead of `$PATH` as we normally would. More details
# see: https://stackoverflow.com/a/68214331

#shellcheck source=/dev/null
source "$HOME/exports"
echo "$PATH" >> "$GITHUB_PATH"
