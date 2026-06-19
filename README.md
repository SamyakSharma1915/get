# get — a brew-like package manager

A simple, extensible package manager for macOS (and Linux), inspired by Homebrew.

## Install

```bash
mkdir -p ~/.get/{bin,apps,cache,logs,repo,taps,share/zsh}
cp bin/get ~/.get/bin/
chmod +x ~/.get/bin/get
export PATH="$HOME/.get/bin:$PATH"
```

Or just run `get setup` after cloning.

## Usage

```bash
get install <app>              # install latest version
get install <app> ver=X.Y.Z    # install a specific version
get uninstall <app>            # remove a package
get list                       # list installed packages
get search <query>             # search available packages
get info <app>                 # show package details
get update                     # update formulae
get upgrade                    # upgrade installed packages
get doctor                     # check your setup
get setup                      # show how to add get to PATH
get tap <name> <url>           # add a third-party tap
```

## How it works

Packages are defined as Ruby files in `~/.get/repo/`. Each file calls
`Formulary.register(...)` with a package name, description, versions map,
and an optional `install_block` that runs custom install logic.

If no `install_block` is provided (or it returns `false`), `get` will
download the URL for the version and extract it (supports `.tar.gz`,
`.tgz`, `.zip`, and `.dmg`).

## Example formula

```ruby
Formulary.register(
  name: "hello",
  desc: "Demo package",
  homepage: "https://example.com",
  versions: { "1.0.0" => "builtin" },
  default_version: "1.0.0",
  dependencies: [],
  install_block: ->(version, prefix) {
    FileUtils.mkdir_p(File.join(prefix, "bin"))
    File.write(
      File.join(prefix, "bin", "hello"),
      "#!/bin/sh\necho 'Hello from get!'\n"
    )
    File.chmod(0755, File.join(prefix, "bin", "hello"))
    true
  },
)
```

## Taps

Third-party taps are git repos cloned into `~/.get/taps/<name>/`. They
are loaded automatically on every `get` invocation.
