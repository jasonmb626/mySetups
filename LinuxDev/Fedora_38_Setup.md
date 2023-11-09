# Setting up my Fedora 38 development machine


From a fresh Fedora 38 installation, updated, username dev


If using Windows as host and Fedora 38 inside of VirtualBox, you may want to take these additional steps

## \(Optional\) add user to vboxsf group so you can share folders inside VirtualBox

```sh
sudo usermod -aG vboxsf dev
```

## \(Optional\) disable Super+G game bar

From Windows PowerShell (run as administrator)
```
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage     
```

Then _reboot_ or changes won't take effect.

## Clone your Setups repository

```sh
mkdir ~/git
git clone https://github.com/jasonmb626/mySetups.git ~/git/mySetups
```

## Install your ssh keys

Copy your github-ssh_keys.zip to ~/.ssh

```sh
mkdir ~/.ssh
unzip ~/git/mySetups/resources/github-ssh_keys.zip -d ~/.ssh
ls -l ~/.ssh
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder.

```
-rw------- 1 dev dev 3.4K xxxx-xx-xx 07:14 id_rsa
-rw-r--r-- 1 dev dev  749 xxxx-xx-xx 06-02 07:14 id_rsa.pub
```

Now you can change the remote URL to ssh-based authentication

```sh
cd ~/git/mySetups
git remote set-url origin git@github.com:jasonmb626/mySetups.git 
```

Set you git configurations
```sh
git config --global user.email "jason@jasonbrunelle.com"
git config --global user.name "Jason Brunelle"
git config --global init.defaultBranch main
```

## Clone your dotfiles repository and symlink your directories

```sh
git clone --recurse-submodules git@github.com:jasonmb626/dotfiles-dev.git ~/git/dotfiles-dev
ln -s ~/git/dotfiles-dev/nvim/ ~/.config/nvim
ln -s ~/git/dotfiles-dev/tmux/ ~/.config/tmux
ln -s ~/git/dotfiles-dev/zsh/ ~/.config/zsh
ln -s ~/git/dotfiles-dev/zsh/.p10k.zsh ~/.p10k.zsh
```

## Tweak DNF config

```sh
echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
```

## (Optional) Install [RPM Fusion](https://rpmfusion.org/) and general multimedia stuff

```sh
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y groupupdate core sound-and-video
sudo dnf -y group upgrade --with-optional Multimedia
```

sudo dnf -y group upgrade --with-optional Multimedia after installing RPM fusion seems to help some streaming video playback. Reboot may be required.
the groupupdate of sound-and-video may not do anything? Doesn't seem to hurt. Previously noted missing software options in Gnome Software that was audio-related.
sudo dnf -y install ffmpeg-libs installs slightly less stuff than the above and also seems to work, but again, REBOOT required. \(We'll be rebooting in a few steps so no need to rush a reboot.\)

## Install Docker

```sh
sudo dnf -y install moby-engine golang-github-moby-buildkit docker-compose
 
sudo usermod -aG docker dev
sudo newgrp docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Install zsh, vim, gnome-shell-extension-pop-shell, xprop and tool to provide chsh

util-linux-user provides chsh command
xprop needed by gnome-shell-extension-pop-shell which provides tiling window manager functionality

```sh
sudo dnf -y install zsh util-linux-user vim gnome-shell-extension-pop-shell xprop;
chsh
```

set to /usr/bin/zsh

### Install Nord theme for Gnome Terminal (This doesn't set the theme, just installs it)

Follow instructions from their [github](https://github.com/arcticicestudio/nord-gnome-terminal)

```sh
git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
cd nord-gnome-terminal/src
./nord.sh
cd ../..
rm -fr nord-gnome-terminal
```
#### Get Powerline 10k

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
```

### (Optional) Key Logging 

Build logkeys from their [GitHub](https://github.com/kernc/logkeys)

Run with the following command: \(my_lang.keymap is in your LinuxDev\)

```sh
sudo logkeys --start --keymap my_lang.keymap --output test.log
```

## Desktop Appearance

### Install dependencies for extending Gnome functionality

```sh
sudo dnf -y install gnome-tweaks
flatpak install -y org.gnome.Extensions
```

If flatpak Gnome Extension requires you to choose from multiple matches, choose 'fedora'

### Set some globals
```sh
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --env=GTK_THEME=Nordic-bluish-accent
echo "GTK_THEME=Nordic-bluish-accent" | sudo tee -a /etc/environment
echo "ZDOTDIR=/home/dev/.config/zsh" | sudo tee -a /etc/environment
```

<details>
  <summary>Copy/Paste - Command Prompt entries</summary>

 Wallpaper 
 
```sh
mkdir ~/.local/share/wallpapers
cp ~/git/mySetups/resources/Wallpapers/3908317.jpg ~/.local/share/wallpapers/
```

Download extensions installer

```sh
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer
sudo mv gnome-shell-extension-installer /usr/bin/
```

Now Install the Extensions

```sh
gnome-shell-extension-installer 19 #User Themes
gnome-shell-extension-installer 307 #Dash to Dock
gnome-shell-extension-installer 779 #Clipboard Indicator
gnome-shell-extension-installer 3740 #Compiz alike magic lamp effect
git clone https://github.com/jasonmb626/workspaces-bar.git $HOME/.local/share/gnome-shell/extensions/workspaces-bar@jasonmb626
```

Icon/Cursor/Theme

```
mkdir ~/.themes
cp -a ~/git/mySetups/LinuxDev/Nordic-bluish-accent* ~/.themes/
mkdir ~/.icons
cp -a ~/git/mySetups/LinuxDev/Nordic/ ~/git/mySetups/LinuxDev/Nordzy-cursors/ ~/.icons/
```

Fonts

```sh
mkdir ~/.local/share/fonts
cp ~/git/mySetups/resources/fonts/ttf/* ~/.local/share/fonts
```

Import Gnome Settings via dconf

```sh
sed "s/%DEFHASH%/$(~/git/mySetups/LinuxDev/getNordProfileID.sh)/" ~/git/mySetups/LinuxDev/user.conf | dconf load /
```

Reboot so everything takes effect

</details>

<details>
  <summary>Manually</summary>

Change the look and feel to your prefrences.

### Get your wallpaper

Download your [wallpaper](https://wallpaperaccess.com/download/blue-lagoon-3908317).

(Recommend placing it in ~/.local/share/wallpapers)

Set the background

Right click desktop, select Change Background. Add Picture and set it as your desktop wallpaper

### Set your workspaces

Settings -> Multitasking

Workspaces
- Fixed, 6

### Enable Gnome Extensions

#### Enable User Themes

Install from the [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension page
You'll need to install the browser plugin (it'll prompt you) and then refresh the page

#### Enable [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
(Check in on https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/. Seems more maintained and doesn't seem to clash even if not using COSMIC)

#### Enable [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

#### Enable [Workspaces Bar](https://extensions.gnome.org/extension/3851/workspaces-bar/)

#### Enable [Compiz alike magic lamp effect](https://extensions.gnome.org/extension/3740/compiz-alike-magic-lamp-effect/)

## Download your preferred theme

Download Nordic-bluish-accent.tar.xz, Nordic-Folders.tar.xz Nordzy-cursors.tar.gz from gnome-look (theme, icons)[https://www.gnome-look.org/p/1267246] and (cursors)[https://www.gnome-look.org/p/1571937]

### Set the themes

Open tweaks 
-> Appearance
- Icons: Nordic
- Cursor: Nordzy
- Shell: Nordic-bluish-accent-v40
- Legacy Applications: Nordic-bluish-accent

-> Window Titlebars -> Placement = Left

### Terminal

#### Install fonts ####

Install the 2 Fira fonts recommended for Powerline 10k
Links [here](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip)
or in this base repo in fonts/ttf folder.

#### Set the Gnome Terminal Settings

Open Gnome Terminal. Hamburger menu => Preferences

Under profiles Choose Nord
Check custom font, set to MesloLGS NF 12
Using down chevron next to Nord choose set as default.

Optional - under colors, set transparent background.

### Set Gnome Keyboard Shortcuts

  Settings -> Keyboard -> Keyboard Shortcuts
  View and Customize Shortcuts

  Navigation

  Set "Hide all normal windows" to Super+D
  Set your "Switch to workspace #" to your keys

#### Reboot

This is a good time to reboot so all the changes get sourced properly.

#### Finish setting up PowerLevel10k

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
* Prompt Tails -> 5 (Rounded)
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

#### If using VSCode

[VS Code](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions)

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf -y check-update
sudo dnf -y install code
```

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/VSCode_Setup.md ) to set up your VS Code environment.
