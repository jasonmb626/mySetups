# Configure Neovim - WIP

## Install Neovim & other dependencies dependencies
```sh
sudo dnf copr enable atim/lazygit -y
sudo dnf install neovim gcc-c++ libstdc++-static xsel lazygit
```
gcc-c++ libstdc++-static are needed for treesitter - at least for some languages

xsel allows neovim to use system clipboard

## Start With a Stable config

(My Config based on LunarVim's Config)[https://github.com/jasonmb626/nvim-basic-ide] is a good starting point

```sh
git clone https://github.com/jasonmb626/nvim-basic-ide.git ~/.config/nvim
```

### Install language servers

```sh
npm i -g prettier dockerfile-language-server-nodejs yaml-language-server bash-language-server
sudo dnf install python3-black python3-flake8
```
