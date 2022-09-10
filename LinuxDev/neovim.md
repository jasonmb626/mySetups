# Information and notes about Neovim config \(Assuming Fedora 36\)

## Install build & other dependencies dependencies
```sh
sudo dnf install cmake libtool gcc-c++ libstdc++-static xsel 
```


## Clone and build NeoVim 0.8.0+

At the time of writing this the version of neovim provided via dnf is old \(0.7.2-1\). When/if repository is updated this step may be unecessary.

From neovim's (github)[https://github.com/neovim/neovim/wiki/Building-Neovim#quick-start]
```sh
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

## Start With a Stable config

(LunarVim's Config)[https://github.com/LunarVim/nvim-basic-ide] is a good starting point

git clone https://github.com/LunarVim/nvim-basic-ide.git ~/.config/nvim