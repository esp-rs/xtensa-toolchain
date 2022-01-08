#!/usr/bin/env bash

set -e


RE_VERSION="^[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?$"

function check_version_formatting() {
  if [[ ! "${1}" =~ $RE_VERSION ]];
  then
    echo "ERROR: version number is not correctly formatted: ${1}"
    exit 1
  fi
}


# Download and execute the installation script from the esp-rs/rust-build
# repository: https://github.com/esp-rs/rust-build
#
# This installs not only the Rust compiler fork with support for the Xtensa
# architecture but also the required Xtensa toolchain binaries. We save the
# required exports to a file for later processing, to handle around some
# weirdness with GitHub runners (see below for details). If a version number
# formatted following semver is provided, attempt to install that version of
# the compiler. If no version was specified, or 'latest' was provided, do not
# specify the toolchain version.

crates="${1:-}"
version="${2:-latest}"

curl -LO https://raw.githubusercontent.com/esp-rs/rust-build/main/install-rust-toolchain.sh
chmod +x ./install-rust-toolchain.sh

function install_rust_toolchain() {
  ./install-rust-toolchain.sh --export-file "$HOME/exports" --extra-crates "$crates" "@"
}

case $version in
  latest)
    install_rust_toolchain
    ;;

  *)
    check_version_formatting "$version"
    install_rust_toolchain --toolchain-version "$version"
    ;;
esac


# With the required exports specified by the rust-build installation script
# saved to a file, we can simply `source` it to export said variables. GitHub
# runners are a bit strange, however, in that we need to update the
# `$GITHUB_PATH` variable instead of `$PATH` as we normally would. More details
# see: https://stackoverflow.com/a/68214331

#shellcheck source=/dev/null
source "$HOME/exports"
echo "$PATH" >> "$GITHUB_PATH"
