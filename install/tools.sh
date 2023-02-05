#!/bin/bash

# source scripts containing helper functions
source "scripts/helper-funcs"

# default location for tools
TOOLS_HOME="${HOME}/tools"
mkdir -p "${TOOLS_HOME}"
pushd "${TOOLS_HOME}"

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install go
GO_VERSION=$(curl https://go.dev/VERSION?m=text)
URL=https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz
GO_INSTALLATION_PATH="$HOME/usr/local"
curl -Lo "go.tar.gz" $URL
rm -rf "$GO_INSTALLATION_PATH/go" && tar -C $GO_INSTALLATION_PATH -xzf "go.tar.gz"
 
# install helix editor
echo "Installing helix editor"
clone-repo git@github.com:helix-editor/helix.git
pushd helix
cargo install --locked --path helix-term
ln -s $PWD/runtime ~/.config/helix/runtime
popd

# install zap plugin manager
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

# install starship
curl -sS https://starship.rs/install.sh | sh
