# Setting up my Fedora 35 development machine (WIP)

From a fresh Fedora 35 installation, updated, username dev

## (Optional) Change SELinux to permissive

```sh
sudo vi /etc/selinux/config
```

Change this line:

```
SELINUX=enforcing
```

to

```
SELINUX=permissive
```

Changes will not take place until a reboot, but a reboot is upcoming anyway.

If you wish to enforce immediately

```sh
sudo setenforce 0
```

## If using VMWare, have it mount shared folders

```sh
sudo vi /etc/fstab
```

Add the following line

```
vmhgfs-fuse    /mnt/hgfs    fuse    defaults,allow_other    0    0
```

Shared folders will mount on startup, but mount them now.

```sh
mount -a
```

## Install your ssh keys

Copy your github-ssh_keys.zip to ~/.ssh

```sh
unzip github-ssh_keys.zip
```

(Enter password)

```sh
rm github-ssh_keys.zip
ls -l
```

You should now have these files and permissions in that folder.

```
-rw------- 1 dev dev 3.4K xxxx-xx-xx 07:14 id_rsa
-rw-r--r-- 1 dev dev  749 xxxx-xx-xx 06-02 07:14 id_rsa.pub
-rw-r--r-- 1 dev dev 2.2K xxxx-xx-xx 02-07 16:28 known_hosts
```

(you likely will not have known_hosts, that's okay.)

## Enable Flathub

Follow directions [here](https://developer.fedoraproject.org/deployment/flatpak/flatpak-usage.html)

```sh
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org
```

## (Optional) Install [RPM Fusion](https://rpmfusion.org/)

```sh
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate core
```

## Desktop Appearance

Change the look and feel to your prefrences.

### Get your wallpaper

Download your [wallpaper](https://wallpaperaccess.com/download/blue-lagoon-3908317) and set it as your desktop wallpaper

(Recommend placing it in ~/.local/share/wallpapers)

### Install dependencies for extending Gnome functionality

```sh
sudo dnf install gnome-tweaks
flatpak install org.gnome.Extensions
```

If flatpak Gnome Extension requires you to choose from multiple matches, choose 'fedora'

### Enable Gnome Extensions

#### Enable User Themes

Install from the [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension page
You'll need to install the browser plugin (it'll prompt you) and then refresh the page

#### Enable [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

#### Enable [Workspaces Bar](https://extensions.gnome.org/extension/3851/workspaces-bar/)

#### Enable [Workspace Switch Wraparound](https://extensions.gnome.org/extension/1116/workspace-switch-wraparound/)

#### Enable [Compiz alike magic lamp effect](https://extensions.gnome.org/extension/3740/compiz-alike-magic-lamp-effect/)

## Download your preferred theme

[Nordic GTK3 theme](https://www.gnome-look.org/p/1267246/)

- Download Nordic-bluish-accent.tar.xz, unzip contents to ~/.themes
- Download Nordic-Folders.tar.xz, unzip its "nordic" folder to ~/.icons (you can ignore the noric-dark folder)

### Set the themes

Open tweaks -> Appearance -> set applications, shell to Nordic-bluish-accent, set icons to Nordic
-> Window Titlebars -> Placement = Left

### Set the workspaces

Set 6 static workspaces

### Install Alacritty & zsh, & docker while we're at it

util-linux-user provides chsh command

```sh
sudo dnf install alacritty zsh util-linux-user vim moby-engine
chsh
```

set to /usr/bin/zsh

```sh
sudo usermod -aG docker dev
sudo systemctl start docker
sudo systemctl enable docker
```

### Setup Alacritty

#### Install Theme

Follow directions on their [GitHub page](https://github.com/arcticicestudio/nord-alacritty)

Also set background opacity

```
background_opacity: 0.8
```

#### Create custom launcher for Alacritty so border theme is applied

```sh
touch ~/.local/share/applications/alacritty.sh
chmod +x ~/.local/share/applications/alacritty.sh
vim ~/.local/share/applications/alacritty.sh
```

Make it read:
```
#!/bin/bash
env WINIT_UNIX_BACKEND=x11 alacritty
```

Create the .desktop entry
```sh
vim ~/.local/share/applications/alacritty.desktop
```

Make it read:
```
[Desktop Entry]
Type=Application
TryExec=/home/dev/.local/share/applications/alacritty.sh
Exec=/home/dev/.local/share/applications/alacritty.sh
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;

Name=Alacritty (Theme)
GenericName=Terminal
Comment=A fast, cross-platform, OpenGL terminal emulator
StartupWMClass=Alacritty
Actions=New;

[Desktop Action New]
Name=New Terminal
Exec=/home/dev/.local/share/applications/alacritty.sh
```

#### Reboot

This is a good time to reboot so all the changes get sourced properly.

### Install and Configure Powerline 10k

Steal some of the zsh powerlevel10k stuff from Manjaro
Download the tarball hosting on GitHub [here](https://github.com/jasonmb626/LinuxDev/raw/main/zsh.tar.xz)

Unzip it to ~/.local/share

Open Alacritty or Gnome Shell

You won't have a .zshrc file yet, so just choose option "0" to create an empty one if prompted.

```sh
cd ~/Downloads
tar xvf zsh.tar.xz -C ~/.local/share
```

Install the 4 meslo fonts recommended for Powerline 10k
Links [here](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
or in this base repo in fonts/ttf folder (might as well install JetBrains fonts at the smae time :) )

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

### Install [zsh-nvm](https://github.com/lukechilds/zsh-nvm)

```sh
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
```

Restart terminal and Powerlevel10k will prompt you for options.

My options:
* Diamond -> y
* Lock -> y
* Debian -> y
* Do they fit -> y
* Prompt Style -> 3 (Rainbow)
* Character Set -> 1 (Unicode)
* Show current time? -> 3 (12-hour format.)
* Prompt Separators -> 1 (Angled)
* Prompt Heads -> 1 (Sharp)
* Prompt Tails -> 1 (Flat)
* Prompt Height -> 2 (Two lines)
* Prompt Connection -> 3 (Solid)
* Prompt Frame -> 4 (Full)
* Connection & Frame Color -> 1 (Lightest)
* Prompt Spacing -> 2 (Sparse)
* Icons -> 2 (Many icons)
* Prompt Flow -> 2 (Fluent)
* Enable Transient Prompt? -> y (Yes)
* Instant Prompt Mode -> 1 (Verbose)
* Apply changes to ~/.zshrc? -> y (Yes)

### Edit your .zshrc

```
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"

# Source manjaro-zsh-configuration
if [[ -e ~/.local/share/zsh/manjaro-zsh-config ]]; then
  source ~/.local/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e ~/.local/share/zsh/manjaro-zsh-prompt ]]; then
  source ~/.local/share/zsh/manjaro-zsh-prompt
fi

# Created by newuser for 5.8
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#zsh-nvm
[[ ! -f ~/.zsh-nvm/zsh-nvm.plugin.zsh ]] || source ~/.zsh-nvm/zsh-nvm.plugin.zsh
```

Exit terminal and reopen. It'll give a bit of an error but that's okay. It's a one-time error.

### Install Node LTS

```sh
nvm i --lts
```

### Install nodemon globaly

```sh
npm i -g nodemon
```

### Download and install the JetBrains Mono font (If not already done)

Available on their [website](https://www.jetbrains.com/lp/mono/)

Direct download [link](https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip?_gl=1*xpo28q*_ga*MTc5NjcwNTg5MS4xNjIyOTAyMDA4*_ga_V0XZL7QHEB*MTYyMjkwMjAwNy4xLjAuMTYyMjkwMjAwNy4w&_ga=2.122909122.871394511.1622902008-1796705891.1622902008).

### IDEs/Code Editors

#### If using Intellij IDEA

```sh
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
```

#### If using VSCode

Install [VS Code](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions)

(Todo - VSCodium? Code-OSS)

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code
```

### Install Docker Compose

```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

From this (link)[https://docs.docker.com/compose/install/]

### Install Screenkey

```sh
sudo dnf install screenkey
```

Note: as of the time of this writing screenkey doesn't fully work on Wayland.

### (optional) Make screenkey start on boot

Superkey -> type "Startup" open startup applications
Add new

```
screenkey -p fixed -g 325x50-5+5 --key-mode composed --bak-mode normal --mods-mode normal --bg-color '#434C5E' --font-color '#A3BE8C' --opacity '0.8'
```

Should we do this?

https://itsfoss.com/enable-applet-indicator-gnome/