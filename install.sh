#!/bin/bash
#
# get — a package manager
# Install with:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/samyak/get/main/install.sh)"
#

set -euo pipefail

GET_DIR="$HOME/.get"
REPO_URL="https://github.com/SamyakSharma1915/get"

echo "==> Installing get..."

if [ -d "$GET_DIR" ]; then
  echo "get already installed at $GET_DIR"
  echo "Run 'get selfupdate' to update."
  exit 0
fi

echo "==> Cloning $REPO_URL"
git clone --depth 1 "$REPO_URL" "$GET_DIR"

echo ""
echo "==> get installed!"
echo ""
echo "Add this to your shell profile:"
echo ""
echo '  export PATH="$HOME/.get/bin:$PATH"'
echo ""
echo "Then restart your shell or run:"
echo ""
echo "  source ~/.zshrc   # if you use zsh"
echo "  source ~/.bash_profile  # if you use bash"
echo ""
echo "Verify with: get --version"
