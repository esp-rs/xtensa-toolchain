# `xtensa-toolchain` Action

![CI](https://github.com/esp-rs/xtensa-toolchain/workflows/CI/badge.svg)
![MIT/Apache-2.0 licensed](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)

An action which installs the Rust compiler fork with Xtensa support, as well as the required toolchain binaries.

The Rust compiler fork with Xtensa support can be found at [esp-rs/rust]. Pre-built binaries with installation scripts can be found at [esp-rs/rust-build], which is what this action uses.

[esp-rs/rust]: https://github.com/esp-rs/rust
[esp-rs/rust-build]: https://github.com/esp-rs/rust

## Example workflow

```yaml
on: [push]

name: CI

jobs:
  check:
    name: Rust project
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Rust for Xtensa
        uses: esp-rs/xtensa-toolchain@v1.3
        with:
          default: true
          version: "1.63.0"
          ldproxy: true

      # `cargo check` command here will use installed `esp` toolchain, as it
      # has been set as the default above

      - name: Run cargo check
        uses: actions-rs/cargo@v1
        with:
          command: check
```

## Inputs

|      Name      |                    Description                    |  Type  | Default  |
| :------------: | :-----------------------------------------------: | :----: | :------: |
|   `default`    |  Set installed toolchain as a default toolchain   |  bool  | `false`  |
| `buildtargets` |          Comma separated list of targets          | string |  _all_   |
|   `version`    |     Which version of the toolchain to install     | string | _latest_ |
|   `ldproxy`    | Whether to install `ldproxy` (required for `std`) |  bool  |  `true`  |
|   `override`   |         Overrides the installed toolchain         |  bool  |  `true`  |


All inputs are optional; if no inputs are provided:

- the Rust compiler fork with Xtensa support will **NOT** be set as the default (but is usable via the `+esp` toolchain specifier)
- all available build targets will be installed
- the latest available version of the compiler will be installed
- [ldproxy](https://github.com/ivmarkov/embuild) **WILL** be installed; this is required for `std`

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in
the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without
any additional terms or conditions.
