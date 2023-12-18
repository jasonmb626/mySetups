# Setting up my Fedora 39 development machine -- wip

From a fresh Fedora 39 installation, updated, username dev

If using Windows as host and Fedora 39 inside of VirtualBox, you may want to take these additional steps

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
git config --global user.email "jasonmb626@gmail.com"
git config --global user.name "Jason Brunelle"
git config --global init.defaultBranch main
git config pull.rebase false  # merge
```

## Clone your dotfiles repository and symlink your directories

```sh
git clone git@github.com:jasonmb626/dotfiles-dev.git ~/git/dotfiles-dev
git clone git@github.com:jasonmb626/epicvim.git ~/git/epicvim
ln -s ~/git/epicvim/ ~/.config/nvim
ln -s ~/git/dotfiles-dev/tmux/ ~/.config/tmux
ln -s ~/git/dotfiles-dev/zsh/ ~/.config/zsh
```

## Tweak DNF and its config

```sh
sudo dnf install -y dnf5 #Newer, faster dnf
echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf #allow more mirrors
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

TODO: Check back on moby-engine. As of the time of writing it does not support Buildkit

### Remove any old dependencies that might be present

```sh
sudo dnf -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

### Install the official docker repository

```sh
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

### Install, start, enable Docker & and give use Docker permissions

```sh
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker dev
sudo systemctl start docker
sudo systemctl enable docker
```

### Install zsh, (n)vim, gnome-shell-extension-pop-shell, xprop and tool to provide chsh

util-linux-user provides chsh command
xprop needed by gnome-shell-extension-pop-shell which provides tiling window manager functionality

TODO: check if gnome-shell-extension-pop-shell has been updated for Gnome 45. If so add back to installation here

```sh
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y zsh util-linux-user vim neovim gcc gcc-c++ patch npm ripgrep mercurial fd-find lazygit gnome-shell-extension-pop-shell xprop;
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

#### Get zsh completions

```sh
mkdir -p ~/.local/share/zsh/completions/
curl -o ~/.local/share/zsh/completions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
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
echo "DOCKER_BUILDKIT=1" | sudo tee -a /etc/environment
echo -e "\n#Postgres defaults\nexport PGUSER=app\nexport PGPASSWORD=654321\nexport PGHOST=localhost\nexport PGPORT=5432\nexport PGDATABASE=project_name" | sudo tee -a /etc/environment
echo -e "if [[ -z \"$XDG_CONFIG_HOME\" ]]; then\n	export XDG_CONFIG_HOME=\"$HOME/.config\"\nfi\n\nif [[ -d \"$XDG_CONFIG_HOME/zsh\" ]]; then\n	export ZDOTDIR=\"$XDG_CONFIG_HOME/zsh/\"\nfi" | sudo tee -a /etc/zshenv
```

### (Optional) Install packages for Postgres development

```sh
sudo dnf -y groupinstall 'Development Tools' 'Development Libraries'
sudo dnf -y install postgresql libpq-devel
```

### Set all the theme options

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

#### Install fonts

Install the 2 Fira fonts recommended for Powerline 10k
Links [here](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip)
or in this base repo in fonts/ttf folder.

#### Set the Gnome Terminal Settings

Open Gnome Terminal. Hamburger menu => Preferences

Under profiles Choose Nord
Check custom font, set to FiraMono Nerd Font 12
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

- Diamond -> y
- Lock -> y
- Debian -> y
- Do they fit -> y
- Prompt Style -> 3 (Rainbow)
- Character Set -> 1 (Unicode)
- Show current time? -> 3 (12-hour format.)
- Prompt Separators -> 1 (Angled)
- Prompt Heads -> 1 (Sharp)
- Prompt Tails -> 5 (Rounded)
- Prompt Height -> 2 (Two lines)
- Prompt Connection -> 3 (Solid)
- Prompt Frame -> 4 (Full)
- Connection & Frame Color -> 1 (Lightest)
- Prompt Spacing -> 2 (Sparse)
- Icons -> 2 (Many icons)
- Prompt Flow -> 2 (Fluent)
- Enable Transient Prompt? -> y (Yes)
- Instant Prompt Mode -> 1 (Verbose)
- Apply changes to ~/.zshrc? -> y (Yes)

</details>

### Install the Pop Shell extension from source

##### Clone the repositories

```sh
mkdir -p ~/git/pop-shell-compiler-container
cd ~/git/pop-shell-compiler-container
~/.config/nvim/if_docker/prep_for_neovim_docker.sh #use this for a temporary container to use for compilation
git clone https://github.com/pop-os/shell.git ~/git/pop-shell-compiler-container/app/pop-shell
dcr dev tmux
```

#### Install typescript and compile the code

```sh
cd pop-shell
sudo npm i -g typescript
make compile
exit
```

#### Now install it

```sh
make install
```

#### Reboot or change won't take effect

## If using VSCode

TODO: Check back on VSCodium. As of the time of writing it does not support devcontainers

[VS Code](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions)

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf -y check-update
sudo dnf -y install code
```

Follow instructions [here](https://github.com/jasonmb626/mySetups/blob/main/VSCode_Setup.md) to set up your VS Code environment.

### (Optional) Key Logging

Build logkeys from their [GitHub](https://github.com/kernc/logkeys)

Run with the following command: \(my_lang.keymap is in your LinuxDev\)

```sh
sudo logkeys --start --keymap my_lang.keymap --output test.log
```
