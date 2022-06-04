# Setting up my Fedora 36 development machine

From a fresh Fedora 36 installation, updated, username dev

If using VirtualBox, the following will be needed for many of the commands in this document to work \(references to mySetups share\)

```sh
sudo usermod -aG vboxsf dev
```

Then _reboot_ or changes won't take effect.

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
sudo dnf install ffmpeg-libs installs slightly less stuff than the above and also seems to work, but again, REBOOT required. \(We'll be rebooting in a few steps so no need to rush a reboot.\)

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

Set the background

(Or wait until we import dconf settings later. It'll do the same thing.)

Right click desktop, select Change Background. Add Picture and set it as your desktop wallpaper

### Set your workspaces

(Or wait until we import dconf settings later. It'll do the same thing.)

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

#### Enable [Dash to Dock for COSMIC](https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/)
(Check back in on https://extensions.gnome.org/extension/307/dash-to-dock/. Seems less maintained and above doesn't seem to clash even if not using COSMIC)

#### Enable [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

#### Enable [Workspaces Bar](https://extensions.gnome.org/extension/3851/workspaces-bar/)

#### Enable [Compiz alike magic lamp effect](https://extensions.gnome.org/extension/3740/compiz-alike-magic-lamp-effect/)

## Download your preferred theme

Download [Nordic-bluish-accent.tar.xz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordic-bluish-accent.tar.xz), [Nordic-Folders.tar.xz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordic-bluish-accent.tar.xz), and [Nordzy-cursors.tar.gz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordzy-cursors.tar.gz) from your GitHub or copy from you host share or from gnome-look (theme, icons)[https://www.gnome-look.org/p/1267246] and (cursors)[https://www.gnome-look.org/p/1571937]

```
mkdir ~/.themes
tar xvfJ /media/sf_mySetups/LinuxDev/Nordic-bluish-accent.tar.xz -C ~/.themes
mkdir ~/.icons
tar xvfJ /media/sf_mySetups/LinuxDev/Nordic-Folders.tar.xz -C ~/.icons
tar xvfz /media/sf_mySetups/LinuxDev/Nordzy-cursors.tar.gz -C ~/.icons
```

### Set the themes

(Or wait until we import dconf settings later. It'll do the same thing.)

Open tweaks 
-> Appearance
- Icons: Nordic
- Shell: Nordic-bluish-accent-v40
- Legacy Applications: Nordic-bluish-accent

-> Window Titlebars -> Placement = Left

### Install zsh, vim, alacritty, gnome-shell-extension-pop-shell, xprop and tool to provide chsh

util-linux-user provides chsh command
xprop needed by gnome-shell-extension-pop-shell, which we'll use since we'll be running alacritty windowless and it'll provide keyboard sizing abilities

```sh
sudo dnf install zsh util-linux-user vim alacritty gnome-shell-extension-pop-shell xprop
chsh
```

set to /usr/bin/zsh

### Terminal

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

#### Install Alacritty Theme

<details>
  <summary>Manually</summary>

Follow directions on their [GitHub page](https://github.com/arcticicestudio/nord-alacritty)

Using their src.yml in raw form, write it to your alacritty.yml file

```sh
mkdir ~/.config/alacritty
vim ~/.config/alacritty/alacritty.yml
```

Also set background opacity and font

(This option was recently changed from background_opacity: 0.8 to the below)

```
startup_mode: Maximized
window:
    opacity: 0.9
    padding:
        x: 10
        y: 10
    decorations: None
font:
    normal:
        family: "MesloLGS NF"
```

</details>

<details>
  <summary>Via Command prompt copy/paste</summary>

```sh
mkdir -p ~/.config/alacritty
git clone https://github.com/arcticicestudio/nord-alacritty.git
cp nord-alacritty/src/nord.yml ~/.config/alacritty/alacritty.yml
rm -fr nord-alacritty
```

Also set background opacity and font

(This option was recently changed from background_opacity: 0.8 to the below)

```sh
echo -e "startup_mode: Maximized\nwindow:\n    opacity: 0.9\n    padding:\n        x: 10\n        y: 10\n    decorations: None\nfont:\n    normal:\n        family: \"MesloLGS NF\"" >> ~/.config/alacritty/alacritty.yml
```

</details>

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

Start terminal and Powerlevel10k will prompt you for options.

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

### Set your .zshrc

<details>
  <summary>Manually</summary>
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

</details>

<details>
  <summary>Copy from your share</summary>

```sh
cp /media/sf_mySetups/LinuxDev/.zshrc ~
```

</details>

Exit terminal and reopen. After a few seconds it'll give a bit of an error/weird output from zsh-nvm but that's okay. It's a one-time thing.

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

### Set additional Gnome Keyboard Shortcuts/load any Gnome Settings not already set manually

<details>
  <summary>Manually</summary>
  Settings -> Keyboard -> Keyboard Shortcuts
  View and Customize Shortcuts

  Navigation

  Set "Hide all normal windows" to Super+D
  Set your "Switch to workspace #" to your keys

</details>

OR
<details>
  <summary>Import via dconf</summary>

```sh
dconf load / < /media/sf_mySetups/LinuxDev/user.conf
```

This loads the following configuration:
```
[org/gnome/desktop/background]
color-shading-type='solid'
picture-options='zoom'
picture-uri='file:///home/dev/.local/share/wallpapers/3908317.jpg'
picture-uri-dark='file:///home/dev/.local/share/wallpapers/3908317.jpg'
primary-color='#000000000000'
secondary-color='#000000000000'

[org/gnome/desktop/interface]
color-scheme='prefer-dark'
cursor-theme='Nordzy-cursors'
font-antialiasing='grayscale'
font-hinting='slight'
gtk-theme='Nordic-bluish-accent'
icon-theme='Nordic'

[org/gnome/desktop/peripherals/keyboard]
numlock-state=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:appmenu'

[org/gnome/desktop/screensaver]
color-shading-type='solid'
picture-options='zoom'
picture-uri='file:///home/dev/.local/share/wallpapers/3908317.jpg'
primary-color='#000000000000'
secondary-color='#000000000000'

[org/gnome/desktop/wm/preferences]
num-workspaces=6

[org/gnome/mutter]
dynamic-workspaces=false

[org/gnome/shell/extensions/user-theme]
name='Nordic-bluish-accent-v40'

[org/gnome/shell/keybindings]
open-application-menu=['<Super>F9']
toggle-message-tray=@as []

[org/gnome/desktop/wm/keybindings]
show-desktop=['<Super>d']
switch-to-workspace-1=['<Super>u']
switch-to-workspace-2=['<Super>i']
switch-to-workspace-3=['<Super>o']
switch-to-workspace-4=['<Shift><Super>u']
switch-to-workspace-5=['<Shift><Super>i']
switch-to-workspace-6=['<Shift><Super>o']

[org/gnome/settings-daemon/plugins/media-keys]
custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
binding='<Super>t'
command='/usr/bin/alacritty'
name='Alacritty Terminal'

[org/gnome/shell]
enabled-extensions=['background-logo@fedorahosted.org', 'pop-shell@system76.com', 'clipboard-indicator@tudmotu.com', 'compiz-alike-magic-lamp-effect@hermes83.github.com', 'dash-to-dock-cosmic-@halfmexicanhalfamazing@gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'workspaces-bar@fthx']

[org/gnome/shell/extensions/clipboard-indicator]
clear-history=['<Super>F10']
next-entry=['<Super>F12']
prev-entry=['<Super>F11']
toggle-menu=['<Super>v']
```
</details>
(via dconf allows setting keys to switch to more workspaces)

### IDEs/Code Editors

#### If using Intellij IDEA

```sh
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
```

#### If using VSCode/VSCodium/Code - OSS

Only VSCode has full access to working extensions in the marketplace. It's hard to hack some of those to work in OSS versions.

<details>
  <summary>VSCode</summary>
    <details>
       <summary>dnf</summary>
Install [VS Code](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions)

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code
```

  </details>
  <details>
    <summary>Flatpak</summary>

```sh
flatpak install https://flathub.org/repo/appstream/com.visualstudio.code.flatpakref
```

  </details>
</details>
<details>
  <summary>VSCodium</summary>
  <details>
     <summary>dnf</summary>
     
```sh
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
sudo dnf install codium
```

  </details>
  <details>
    <summary>Flatpak</summary>

```sh
flatpak install flathub com.vscodium.codium
```

  </details>
</details>
<details>
  <summary>Code OSS</summary>

```sh
flatpak install flathub com.visualstudio.code-oss
```

</details>

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/VSCode_Setup.md ) to set up your VS Code environment.

### Postgres

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/LinuxDev/Fedora_36_postgres-devel.md).