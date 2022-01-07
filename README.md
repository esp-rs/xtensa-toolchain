# `xtensa-toolchain` Action

![MIT/Apache-2.0 licensed](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)
![CI](https://github.com/esp-rs/xtensa-toolchain/workflows/CI/badge.svg)

An action which installs the Rust compiler fork with Xtensa support, as well as the required toolchain binaries.

The Rust compiler fork with Xtensa support can be found at [esp-rs/rust], and pre-built binaries with installation scripts can be found at [esp-rs/rust-build].

This action uses the pre-built binaries and installation script from [esp-rs/rust-build].

[esp-rs/rust]: https://github.com/esp-rs/rust
[esp-rs/rust-build]: https://github.com/esp-rs/rust

## Example workflow

```yaml
on: [push]

name: build

jobs:
  check:
    name: Rust project
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Rust for Xtensa
        uses: esp-rs/xtensa-toolchain@v1
        with:
          default: true

      # `cargo check` command here will use installed `esp` toolchain, as it
      # is set as the default

      - name: Run cargo check
        uses: actions-rs/cargo@v1
        with:
          command: check
```

## Inputs

| Name      |                  Description                   | Type | Default |
| --------- | :--------------------------------------------: | ---- | ------- |
| `default` | Set installed toolchain as a default toolchain | bool | false   |

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in
the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without
any additional terms or conditions.
