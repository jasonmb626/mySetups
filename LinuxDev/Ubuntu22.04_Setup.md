# Setting up my Ubuntu 22.04 development machine (WIP)

From a fresh Ubuntu 22.04 installation, updated, username dev

## If Virtual Machine, have it mount shared folders

<details>
  <summary>If Using VirtualBox</summary>

```sh
sudo apt install build-essential
```

Choose Devices -> Insert Guest Additions CD image...

Run the Guest additions installer
```sh
/media/dev/VBox_GAs_<version>/autorun.sh
```

Add your user to the vboxsf group and create mount point

```sh
sudo usermod -aG vboxsf dev
mkdir /home/dev/host/mySetups
sudo vi /etc/fstab
```

Add your fstab entry

```
mySetups    /home/dev/host/mySetups    vboxsf    defaults,uid=1000,gid=1000,umask=0022    0    0
```

Reboot.

</details>

<details>
  <summary>If Using VMWare</summary>
```
vmhgfs-fuse    /home/dev/host    fuse    defaults,allow_other    0    0
```
Shared folders will mount on startup, but mount them now.

```sh
sudo mount -a
```

</details>


The rest of the doc assumes you've shared you mySetups folder and so it'll be at ~/host/mySetups

## Install your ssh keys

Copy your github-ssh_keys.zip to ~/.ssh

```sh
mkdir ~/.ssh
unzip ~/host/mySetups/resources/github-ssh_keys.zip -d ~/.ssh
ls -l ~/.ssh
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder.

```
-rw------- 1 dev dev 3.4K xxxx-xx-xx 07:14 id_rsa
-rw-r--r-- 1 dev dev  749 xxxx-xx-xx 06-02 07:14 id_rsa.pub
```

## Install non-snap browser (otherwise Gnome Extensions don't work)

Just install Google Chrome from [Google's Website](https://www.google.com/chrome)

## Desktop Appearance

Change the look and feel to your prefrences.

### Move panel to bottom and make it a dock

Settings -> Appearance -> Dock

Auto-hide the Dock: On
Panel mode: Off
Position on screen: Bottom

### Set the workspaces

Settings -> Multitasking -> Workspaces

o Fixed number of workspaces
Number of Workspaces: 6

### Get your wallpaper

```sh
mkdir ~/.local/share/wallpapers
cp ~/host/mySetups/resources/Wallpapers/3908317.jpg ~/.local/share/wallpapers/
```

OR

Download your [wallpaper](https://wallpaperaccess.com/download/blue-lagoon-3908317).

(Recommend placing it in ~/.local/share/wallpapers)

Right click desktop, select Change Background. Add Picture and set it as your desktop wallpaper

### Install dependencies for extending Gnome functionality

```sh
sudo apt-get install chrome-gnome-shell gnome-tweaks
```

### Enable Gnome Extensions

#### Enable User Themes

Install from the [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension page
You'll need to install the browser plugin (it'll prompt you) and then refresh the page

#### Enable [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

(Incompatible at the time of documenting, but probably will be compatible soon)

#### Enable [Workspaces Bar](https://extensions.gnome.org/extension/3851/workspaces-bar/)

#### Enable [Compiz alike magic lamp effect](https://extensions.gnome.org/extension/3740/compiz-alike-magic-lamp-effect/)

## Download your preferred theme

Download [Nordic-bluish-accent.tar.xz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordic-bluish-accent.tar.xz) and [Nordic-Folders.tar.xz](https://github.com/jasonmb626/LinuxDev/raw/main/Nordic-bluish-accent.tar.xz) from your GitHub or copy from you host share

```
mkdir ~/.themes
tar xvfJ ~/host/mySetups/LinuxDev/Nordic-bluish-accent.tar.xz -C ~/.themes
mkdir ~/.icons
tar xvfJ ~/host/mySetups/LinuxDev/Nordic-Folders.tar.xz -C ~/.icons
```

OR

<details>
  <summary>Derive from originals</summary>

[Nordic GTK3 theme](https://www.gnome-look.org/p/1267246/)

- Download Nordic-bluish-accent.tar.xz, unzip  its Nordic-bluish-accent contents to ~/.themes (ignore the Nordic-bluish-accent-v40 folder)
- Download Nordic-Folders.tar.xz, unzip its "nordic" folder to ~/.icons (you can ignore the noric-dark folder)
  
edit the gnome-shell.css from the gnome-shell folder of Nordic-bluish-accent

Add transparancy to the #dash background-color and border

```
/* DASHBOARD */
#dash {
  font-size: 9pt;
  color: #d8dee9;
  background-color: #1d212800; /*This line edited*/
  padding: 6px 0;
  border: 1px solid #1f232b00; /*This line edited*/
  border-left: 0px;
  border-radius: 0px 5px 5px 0px; }
```
</details>

### Set the themes

Open Tweaks -> Appearance -> Themes
Set Shell, Legacy Applications to Nordic-bluish-accent
Set Icons to Nordic

Tweaks -> Window Titlebars -> Placement = Left

### Install Alacritty & zsh

Alacritty PPA directions copied from [here](https://ubuntuhandbook.org/index.php/2020/12/install-alacritty-ppa-ubuntu-20-04/)

```sh
sudo add-apt-repository ppa:aslatter/ppa
sudo apt install alacritty zsh vim curl git
chsh
```
set to /usr/bin/zsh

### Setup Alacritty

#### Install Theme

Follow directions on their [GitHub page](https://github.com/arcticicestudio/nord-alacritty)

Using their src.yml in raw form, write it to your alacritty.yml file

```sh
mkdir ~/.config/alacritty
vim ~/.config/alacritty/alacritty.yml
```

Also set background opacity and font

(This option was recently changed from background_opacity: 0.8 to the below)

```
window:
  opacity: 0.8
  decorations: None
font:
  normal:
    family: "MesloLGS NF"
```

#### Install fonts ####

Install from your host

```sh
mkdir ~/.local/share/fonts
cp ~/host/mySetups/resources/fonts/ttf/* ~/.local/share/fonts
```

OR

Install the 4 meslo fonts recommended for Powerline 10k
Links [here](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
or in this base repo in fonts/ttf folder (might as well install JetBrains fonts at the smae time :) )

### Install and Configure Powerline 10k

#### First get your custom zsh stolen from Manjaro Linux

From your host
```sh
tar xvfJ ~/host/mySetups/LinuxDev/zsh.tar.xz -C ~/.local/share
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

Open your Alacritty (Theme) and Powerlevel10k will prompt you for options.

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
```

Exit terminal and reopen. It'll give a bit of an error but that's okay. It's a one-time error.

### Install pip3, venv

```sh
sudo apt install python3-pip python3-venv
```

### Install Node LTS

```sh
nvm i --lts
```

### Install nodemon globaly

```sh
npm i -g nodemon
```

### Download and install the JetBrains Mono font (You probably already did this when you copied over fonts above)

Available on their [website](https://www.jetbrains.com/lp/mono/)

Direct download [link](https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip?_gl=1*xpo28q*_ga*MTc5NjcwNTg5MS4xNjIyOTAyMDA4*_ga_V0XZL7QHEB*MTYyMjkwMjAwNy4xLjAuMTYyMjkwMjAwNy4w&_ga=2.122909122.871394511.1622902008-1796705891.1622902008).

### IDEs/Code Editors

#### If using Intellij IDEA

```sh
snap install intellij-idea-community --classic
```

#### If using VSCode

```sh
sudo snap install code --classic
```

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/VSCode_Setup.md ) to set up your VS Code environment.

### Postgres

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/LinuxDev/Ubuntu22.04_postgres-devel.md).