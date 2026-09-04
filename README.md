# `xtensa-toolchain` Action

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/esp-rs/xtensa-toolchain/ci.yaml?label=CI&logo=github&style=flat-square)
![MIT/Apache-2.0 licensed](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)

An action which installs the Rust compiler fork with Xtensa support, as well as the required toolchain binaries.

The Rust compiler fork with Xtensa support can be found at [esp-rs/rust]. Pre-built binaries can be found at [esp-rs/rust-build], and we install these using [esp-rs/espup].

[esp-rs/rust]: https://github.com/esp-rs/rust
[esp-rs/rust-build]: https://github.com/esp-rs/rust-build
[esp-rs/espup]: https://github.com/esp-rs/espup

## Example workflow

```yaml
name: CI

on: [push]

jobs:
  check:
    name: Rust project
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Rust for Xtensa
        uses: esp-rs/xtensa-toolchain@v1.5
        with:
          default: true
          version: "1.66.0"
          ldproxy: true

      # `cargo check` command here will use installed `esp` toolchain, as it
      # has been set as the default above

      - name: Run cargo check
        run: cargo check
```

## Inputs

This action can be configured in various ways using its inputs:

|      Name       |                        Description                         |  Type  |         Default         |
| :-------------: | :--------------------------------------------------------: | :----: | :---------------------: |
|    `default`    |       Set installed toolchain as a default toolchain       |  bool  |         `false`         |
| `buildtargets`  |              Comma separated list of targets               | string | _esp32,esp32s2,esp32s3_ |
|    `version`    |         Which version of the toolchain to install          | string |        _latest_         |
|    `ldproxy`    |     Whether to install `ldproxy` (required for `std`)      |  bool  |         `false`         |
|   `override`    |             Overrides the installed toolchain              |  bool  |         `true`          |
|    `export`     |               Sources `${ESPUP_EXPORT_FILE}`               |  bool  |         `true`          |
| `extended-llvm` | Install the whole LLVM instead of only installing the libs |  bool  |         `false`         |
|     `name`      |                 Xtensa Rust toolchain name                 | string |          _esp_          |
|  `github-token` |       Token used by `espup` to query the GitHub API        | string |         _empty_         |

All inputs are optional; if no inputs are provided:

- the Rust compiler fork with Xtensa support will **NOT** be set as the default (but is usable via the `+esp` toolchain specifier)
- all available build targets will be installed
- the latest available version of the compiler will be installed
- [ldproxy](https://github.com/ivmarkov/embuild) **WILL** be installed; this is required for `std`
- the Rust compiler fork with Xtensa support **WILL** be set as the override toolchain

## Environment

This action uses [espup], which calls the GitHub API during the installation process. [GitHub API has a low rate limit] for non-authenticated users, and this can lead to transient errors. See [#15] for details.

The token passed to `espup` is the first non-empty value of:

1. the `github-token` input,
2. the `GITHUB_TOKEN` environment variable visible to the action, whether it comes from the workflow, job or step level, or is injected by the runner itself,
3. the [github.token] context, i.e. the token GitHub Actions automatically provides to every workflow run.

If all three are empty, `GITHUB_TOKEN` is unset before running `espup`, so the API is queried anonymously rather than with an empty `Authorization` header, which the API rejects with `401 Unauthorized`.

On GitHub Actions, case 3 always applies, so no setup is required: the API queries are authenticated by default.

[espup]: https://github.com/esp-rs/espup
[GitHub API has a low rate limit]: https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#rate-limits-for-requests-from-github-actions
[#15]: https://github.com/esp-rs/xtensa-toolchain/issues/15
[github.token]: https://docs.github.com/en/actions/concepts/security/github_token

### Third-party runners (Forgejo, Gitea)

These runners inject their own `GITHUB_TOKEN`, which overrides any `GITHUB_TOKEN` you set at the workflow or job level.
Setting it at the step level does take effect for that step, but the injection happens again for every step of a composite action like this one, so it cannot be overridden from the calling workflow.
That token is not valid for `api.github.com`, so `espup` fails with `401 Unauthorized`.
Since the injected token is only seen as case 2 above, the `github-token` input is the only way to override it:

```yaml
- name: Install Rust for Xtensa
  uses: esp-rs/xtensa-toolchain@v1
  with:
    github-token: ${{ secrets.GH_API_TOKEN }}
    default: true
    buildtargets: esp32s3
```

### Use with [act]

[act] is a tool which can be used to run GitHub workflows locally, using Docker. It is possible to use the `xtensa-toolchain` action with [act]; however, due to the fact that [espup] queries the GitHub API, it is necessary to set the `GITHUB_TOKEN` environment variable in order to do so.

For more information please see the [`GITHUB_TOKEN`] section of the User Guide for [act].

[act]: https://github.com/nektos/act
[`GITHUB_TOKEN`]: https://nektosact.com/usage/index.html?#github_token

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in
the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without
any additional terms or conditions.
