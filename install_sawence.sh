#!/bin/sh
#install nvim > 8.0
sudo apt install neovim
#install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
#setup node on the last LTS
nvm install --lts
#install tldr
sudo apt install tealdeer
#install tmux
sudo apt install tmux
