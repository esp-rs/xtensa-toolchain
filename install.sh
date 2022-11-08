#!/usr/bin/env bash

set -eu

function format_version() {
  ver=$1

  # The number of iterations to perform is 3 (the maximum occurences of '.' in
  # a version string) minus the number of occurences of '.' already present in
  # the version string.
  res=${ver//[^.]/}
  iters=$((3 - ${#res}))

  # Append '.0' to the version string $iters number of times to create a
  # version string which matches the release tags.
  for ((i = 0; i < iters; i++)); do
    ver="${ver}.0"
  done

  echo "$ver"
}

# Download and execute the installation script from the esp-rs/rust-build
# repository: https://github.com/esp-rs/rust-build
#
# This installs not only the Rust compiler fork with support for the Xtensa
# architecture but also the required Xtensa toolchain binaries. We save the
# required exports to a file for later processing, to handle around some
# weirdness with GitHub runners (see below for details). If a version number
# formatted following (our extended version of) semver is provided, attempt to
# install that version of the compiler.

crates="${1:-}"
version="${2:-}"
buildtargets="${3:-all}"

curl \
  -L "https://github.com/esp-rs/espup/releases/latest/download/espup-x86_64-unknown-linux-gnu" \
  -o "$HOME/espup"

chmod a+x "$HOME/espup"

args="-l debug --export-file $HOME/exports --targets ${buildtargets}"

if [[ "${version}" != "" ]]; then
  version=$(format_version "$version")
  args="$args  --toolchain-version $version"
fi

if [[ "${crates}" != "" ]]; then
  args="$args  --extra-crates $crates"
fi

$HOME/espup install $args

# With the required exports specified by the rust-build installation script
# saved to a file, we can simply `source` it to export said variables. GitHub
# runners are a bit strange, however, in that we need to update the
# `$GITHUB_PATH` variable instead of `$PATH` as we normally would. More details
# see: https://stackoverflow.com/a/68214331

#shellcheck source=/dev/null
source "$HOME/exports"
echo "$PATH" >>"$GITHUB_PATH"
echo "LIBCLANG_PATH=${LIBCLANG_PATH}" >>"$GITHUB_ENV"
