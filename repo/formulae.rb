require "get/formulary"

Formulary = Get::Formulary

# ── CLI Tools ──────────────────────────────────────────────────────────────

Formulary.register(
  name: "claude",
  desc: "Claude Code — Anthropic's official CLI for AI-assisted coding",
  homepage: "https://docs.anthropic.com/en/docs/claude-code",
  versions: { "latest" => "npm" },
  default_version: "latest",
  dependencies: ["node"],
  install_block: ->(version, prefix, _os) {
    system("npm", "install", "-g", "@anthropic-ai/claude-code", out: File::NULL, err: File::NULL)
    true
  },
)

Formulary.register(
  name: "gemini",
  desc: "Gemini CLI — Google's official CLI for Gemini models",
  homepage: "https://github.com/google-gemini/gemini-cli",
  versions: { "latest" => "npm" },
  default_version: "latest",
  dependencies: ["node"],
  install_block: ->(version, prefix, _os) {
    system("npm", "install", "-g", "@google/gemini-cli", out: File::NULL, err: File::NULL)
    true
  },
)

Formulary.register(
  name: "codex",
  desc: "Codex CLI — OpenAI's official CLI for GPT-powered coding",
  homepage: "https://github.com/openai/codex",
  versions: { "latest" => "npm" },
  default_version: "latest",
  dependencies: ["node"],
  install_block: ->(version, prefix, _os) {
    system("npm", "install", "-g", "@openai/codex", out: File::NULL, err: File::NULL)
    true
  },
)

Formulary.register(
  name: "node",
  desc: "Node.js — JavaScript runtime",
  homepage: "https://nodejs.org",
  versions: {
    "22.16.0" => {
      "macos/arm64" => "https://nodejs.org/dist/v22.16.0/node-v22.16.0-darwin-arm64.tar.gz",
      "macos/x86_64" => "https://nodejs.org/dist/v22.16.0/node-v22.16.0-darwin-x64.tar.gz",
      "linux/x86_64" => "https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-x64.tar.xz",
      "linux/arm64" => "https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-arm64.tar.xz",
    },
    "20.19.2" => {
      "macos/arm64" => "https://nodejs.org/dist/v20.19.2/node-v20.19.2-darwin-arm64.tar.gz",
      "macos/x86_64" => "https://nodejs.org/dist/v20.19.2/node-v20.19.2-darwin-x64.tar.gz",
      "linux/x86_64" => "https://nodejs.org/dist/v20.19.2/node-v20.19.2-linux-x64.tar.xz",
      "linux/arm64" => "https://nodejs.org/dist/v20.19.2/node-v20.19.2-linux-arm64.tar.xz",
    },
  },
  default_version: "22.16.0",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "python",
  desc: "Python programming language",
  homepage: "https://python.org",
  versions: {
    "3.14.4" => {
      "macos/arm64" => "https://www.python.org/ftp/python/3.14.4/python-3.14.4-macos11.pkg",
      "macos/x86_64" => "https://www.python.org/ftp/python/3.14.4/python-3.14.4-macos11.pkg",
      "linux/x86_64" => "https://www.python.org/ftp/python/3.14.4/Python-3.14.4.tgz",
    },
    "3.13.7" => {
      "macos/arm64" => "https://www.python.org/ftp/python/3.13.7/python-3.13.7-macos11.pkg",
      "macos/x86_64" => "https://www.python.org/ftp/python/3.13.7/python-3.13.7-macos11.pkg",
    },
    "3.12.10" => {
      "macos/arm64" => "https://www.python.org/ftp/python/3.12.10/python-3.12.10-macos11.pkg",
      "macos/x86_64" => "https://www.python.org/ftp/python/3.12.10/python-3.12.10-macos11.pkg",
    },
  },
  default_version: "3.14.4",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "ripgrep",
  desc: "ripgrep — a fast regex search tool (rg)",
  homepage: "https://github.com/BurntSushi/ripgrep",
  versions: {
    "14.1.0" => {
      "macos/arm64" => "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-aarch64-apple-darwin.tar.gz",
      "macos/x86_64" => "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-apple-darwin.tar.gz",
      "linux/x86_64" => "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-gnu.tar.gz",
      "linux/arm64" => "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-aarch64-unknown-linux-gnu.tar.gz",
    },
    "13.0.0" => {
      "macos/arm64" => "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-aarch64-apple-darwin.tar.gz",
      "macos/x86_64" => "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-apple-darwin.tar.gz",
    },
  },
  default_version: "14.1.0",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "git",
  desc: "Git — distributed version control",
  homepage: "https://git-scm.com",
  versions: {
    "2.47.1" => {
      "macos/arm64" => "https://sourceforge.net/projects/git-osx-installer/files/git-2.47.1-arm64.dmg",
      "macos/x86_64" => "https://sourceforge.net/projects/git-osx-installer/files/git-2.47.1-intel.dmg",
      "linux/x86_64" => "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.47.1.tar.gz",
    },
  },
  default_version: "2.47.1",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "fzf",
  desc: "fzf — command-line fuzzy finder",
  homepage: "https://github.com/junegunn/fzf",
  versions: {
    "0.56.3" => {
      "macos/arm64" => "https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-darwin_arm64.tar.gz",
      "macos/x86_64" => "https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-darwin_amd64.tar.gz",
      "linux/x86_64" => "https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-linux_amd64.tar.gz",
      "linux/arm64" => "https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-linux_arm64.tar.gz",
    },
  },
  default_version: "0.56.3",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

# ── Browsers ───────────────────────────────────────────────────────────────

Formulary.register(
  name: "chrome",
  desc: "Google Chrome — fast, secure web browser",
  homepage: "https://google.com/chrome",
  versions: {
    "latest" => {
      "macos/arm64" => "https://dl.google.com/chrome/mac/stable/googlechrome.dmg",
      "macos/x86_64" => "https://dl.google.com/chrome/mac/stable/googlechrome.dmg",
      "linux/x86_64" => "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "firefox",
  desc: "Firefox — fast, private web browser",
  homepage: "https://firefox.com",
  versions: {
    "latest" => {
      "macos/default" => "https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US",
      "linux/x86_64" => "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

# ── Editors ────────────────────────────────────────────────────────────────

Formulary.register(
  name: "vscode",
  desc: "Visual Studio Code — free source code editor",
  homepage: "https://code.visualstudio.com",
  versions: {
    "latest" => {
      "macos/arm64" => "https://update.code.visualstudio.com/latest/darwin-arm64/stable",
      "macos/x86_64" => "https://update.code.visualstudio.com/latest/darwin/stable",
      "linux/x86_64" => "https://update.code.visualstudio.com/latest/linux-x64/stable",
      "linux/arm64" => "https://update.code.visualstudio.com/latest/linux-arm64/stable",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

# ── Communication ──────────────────────────────────────────────────────────

Formulary.register(
  name: "discord",
  desc: "Discord — voice, video, and text chat",
  homepage: "https://discord.com",
  versions: {
    "latest" => {
      "macos/default" => "https://discord.com/api/download?platform=osx",
      "linux/x86_64" => "https://discord.com/api/download?platform=linux&format=deb",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "slack",
  desc: "Slack — team communication and collaboration",
  homepage: "https://slack.com",
  versions: {
    "latest" => {
      "macos/arm64" => "https://slack.com/downloads/mac/apple",
      "macos/x86_64" => "https://slack.com/downloads/mac/intel",
    },
  },
  default_version: "latest",
  dependencies: [],
  macos_only: true,
  install_block: ->(version, prefix, os) { false },
)

# ── Media ──────────────────────────────────────────────────────────────────

Formulary.register(
  name: "spotify",
  desc: "Spotify — music and podcast streaming",
  homepage: "https://spotify.com",
  versions: {
    "latest" => {
      "macos/default" => "https://download.scdn.co/Spotify.dmg",
      "linux/x86_64" => "https://repository.spotify.com/pool/non-free/s/spotify/spotify-client_latest_amd64.deb",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

# ── Design ─────────────────────────────────────────────────────────────────

Formulary.register(
  name: "figma",
  desc: "Figma — collaborative interface design tool",
  homepage: "https://figma.com",
  versions: {
    "latest" => {
      "macos/default" => "https://desktop.figma.com/mac/Figma.dmg",
      "linux/x86_64" => "https://desktop.figma.com/linux/Figma.AppImage",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

# ── Utilities ──────────────────────────────────────────────────────────────

Formulary.register(
  name: "raycast",
  desc: "Raycast — blazingly fast launcher and productivity tool",
  homepage: "https://raycast.com",
  versions: {
    "latest" => {
      "macos/default" => "https://raycast.com/download?arch=intel",
    },
  },
  default_version: "latest",
  dependencies: [],
  macos_only: true,
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "iterm2",
  desc: "iTerm2 — terminal emulator for macOS",
  homepage: "https://iterm2.com",
  versions: {
    "latest" => {
      "macos/default" => "https://iterm2.com/downloads/stable/latest",
    },
  },
  default_version: "latest",
  dependencies: [],
  macos_only: true,
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "docker",
  desc: "Docker — container runtime and CLI",
  homepage: "https://docker.com",
  versions: {
    "latest" => {
      "macos/arm64" => "https://desktop.docker.com/mac/main/arm64/Docker.dmg",
      "macos/x86_64" => "https://desktop.docker.com/mac/main/amd64/Docker.dmg",
      "linux/x86_64" => "https://get.docker.com",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) {
    if os == :linux
      system("sh", "-c", "curl -fsSL https://get.docker.com | sh", out: File::NULL, err: File::NULL)
    end
    false
  },
)

Formulary.register(
  name: "1password",
  desc: "1Password — password manager",
  homepage: "https://1password.com",
  versions: {
    "latest" => {
      "macos/default" => "https://downloads.1password.com/mac/1Password-8.10.60.zip",
      "linux/x86_64" => "https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

Formulary.register(
  name: "obs",
  desc: "OBS Studio — free screen recording and streaming",
  homepage: "https://obsproject.com",
  versions: {
    "latest" => {
      "macos/arm64" => "https://cdn.obsproject.com/downloads/OBS-Studio-31.0.2-macOS-Apple.dmg",
      "macos/x86_64" => "https://cdn.obsproject.com/downloads/OBS-Studio-31.0.2-macOS-Intel.dmg",
      "linux/x86_64" => "https://github.com/obsproject/obs-studio/releases/latest/download/OBS-Studio-31.0.2-linux-x86_64.deb",
    },
  },
  default_version: "latest",
  dependencies: [],
  install_block: ->(version, prefix, os) { false },
)

# ── Demo ───────────────────────────────────────────────────────────────────

Formulary.register(
  name: "hello",
  desc: "Demo package that prints hello (built-in, no download)",
  homepage: "https://example.com",
  versions: { "1.0.0" => "builtin" },
  default_version: "1.0.0",
  dependencies: [],
  install_block: ->(version, prefix, _os) {
    FileUtils.mkdir_p(File.join(prefix, "bin"))
    File.write(
      File.join(prefix, "bin", "hello"),
      "#!/bin/sh\necho 'Hello from get!'\n"
    )
    File.chmod(0755, File.join(prefix, "bin", "hello"))
    true
  },
)
