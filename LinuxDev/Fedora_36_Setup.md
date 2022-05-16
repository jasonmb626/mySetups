# Setting up my Fedora 36 development machine (WIP)

From a fresh Fedora 36 installation, updated, username dev

## (Optional) Change SELinux to permissive

This step tends to help with certain issues like Udemy video playback and never figured out how to get docker to work properly when passing in volumes while SE Linux is enforcing.

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

## Install your ssh keys

Copy your github-ssh_keys.zip to ~/.ssh

```sh
mkdir ~/.ssh
unzip /media/sf_mySetups/resources/github-ssh_keys.zip -d ~/.ssh
ls -l ~/.ssh
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder.

```
-rw------- 1 dev dev 3.4K xxxx-xx-xx 07:14 id_rsa
-rw-r--r-- 1 dev dev  749 xxxx-xx-xx 06-02 07:14 id_rsa.pub
```

## Enable Flathub

Follow directions [here](https://developer.fedoraproject.org/deployment/flatpak/flatpak-usage.html)

```sh
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org
```

## (Optional) Install [RPM Fusion](https://rpmfusion.org/) and general multimedia stuff

```sh
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate core sound-and-video
sudo dnf group upgrade --with-optional Multimedia
```

sudo dnf group upgrade --with-optional Multimedia after installing RPM fusion seems to help some streaming video playback. Reboot may be required.
the groupupdate of sound-and-video may not do anything? Doesn't seem to hurt. Previously noted missing software options in Gnome Software that was audio-related.
sudo dnf install ffmpeg-libs installs slightly less stuff than the above and also seems to work, but again, REBOOT required.

## Desktop Appearance

Change the look and feel to your prefrences.

### Get your wallpaper

```sh
mkdir ~/.local/share/wallpapers
cp /media/sf_mySetups/resources/Wallpapers/3908317.jpg ~/.local/share/wallpapers/
```

OR

Download your [wallpaper](https://wallpaperaccess.com/download/blue-lagoon-3908317).

(Recommend placing it in ~/.local/share/wallpapers)

Right click desktop, select Change Background. Add Picture and set it as your desktop wallpaper

### Set your workspaces

Settings -> Multitasking

Workspaces
- Fixed, 6

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

Download [Nordic-bluish-accent.tar.xz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordic-bluish-accent.tar.xz) and [Nordic-Folders.tar.xz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordic-bluish-accent.tar.xz) from your GitHub or copy from you host share

```
mkdir ~/.themes
tar xvfJ /media/sf_mySetups/LinuxDev/Nordic-bluish-accent.tar.xz -C ~/.themes
mkdir ~/.icons
tar xvfJ /media/sf_mySetups/LinuxDev/Nordic-Folders.tar.xz -C ~/.icons
```

### Set the themes

Open tweaks -> Appearance -> set applications, shell to Nordic-bluish-accent, set icons to Nordic
-> Window Titlebars -> Placement = Left

### Install zsh, vim, and tool to provide chsh

util-linux-user provides chsh command

```sh
sudo dnf install zsh util-linux-user vim
chsh
```

set to /usr/bin/zsh

### Gnome Terminal

#### Install fonts ####

Install from your host

```sh
mkdir ~/.local/share/fonts
cp /media/sf_mySetups/resources/fonts/ttf/* ~/.local/share/fonts
```

OR

Install the 4 meslo fonts recommended for Powerline 10k
Links [here](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
or in this base repo in fonts/ttf folder (might as well install JetBrains fonts at the same time :) )

Install the JetBrains mono font Available on their [website](https://www.jetbrains.com/lp/mono/)

### Install Nord theme for Gnome Terminal

Follow instructions from their [github](https://github.com/arcticicestudio/nord-gnome-terminal)

```sh
git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
cd nord-gnome-terminal/src
./nord.sh
cd ..
rm -fr nord-gnome-terminal
```

Open Gnome Terminal. Hamburger menu => Preferences

Under profiles Choose Nord
Check custom font, set to MesloLGS NF 12
Using down delta next to Nord choose set as default.

Optional - under colors, set transparent background.

### Install and Configure Powerline 10k

#### First get your custom zsh stolen from Manjaro Linux

From your host
```sh
tar xvfJ /media/sf_mySetups/LinuxDev/zsh.tar.xz -C ~/.local/share
```

OR

Steal some of the zsh powerlevel10k stuff from Manjaro
Download the tarball hosting on GitHub [here](https://github.com/jasonmb626/LinuxDev/raw/main/zsh.tar.xz)

Unzip it to ~/.local/share

#### Now get Powerline 10k

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

#### Reboot

This is a good time to reboot so all the changes get sourced properly.

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

### Install [zsh-nvm](https://github.com/lukechilds/zsh-nvm)

```sh
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
```

### Edit your .zshrc

```sh
vim ~/.zshrc
```

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

#tab-completion menu
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

alias ls="ls --color=auto"
```

Exit terminal and reopen. It'll give a bit of an error but that's okay. It's a one-time error.

### Install Extra python stuff, pip, venv, wheel, development libraries

python3-devel probably only necessary if installing psycopg2 pip module

```sh
sudo dnf install python3-pip python3-virtualenv python3-devel python3-wheel
```

### Install Node LTS

```sh
nvm i --lts
```

### Install nodemon globaly

```sh
npm i -g nodemon
```

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

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/VSCode_Setup.md ) to set up your VS Code environment.

### Postgres

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/LinuxDev/Fedora_36_postgres-devel.md).