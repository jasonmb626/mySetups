# Setting up my Ubuntu 25.10 development machine

From a fresh Ubuntu 25.10 installation

## Environment-specific configs

<details>
  <summary>Virtualbox</summary>
If using Windows as host and Ubuntu 25.10 inside of VirtualBox, you may want to take these additional steps

## \(Optional\) add user to vboxsf group so you can share folders inside VirtualBox

```sh
sudo usermod -aG vboxsf $USER
```

## \(Optional\) disable Super+G game bar

From Windows PowerShell (run as administrator)

```
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
```

Then _reboot_ or changes won't take effect.

</details>

<details>
    <summary>Virtmanager</summary>
## \(Optional\) add your shared folder if using virtmanager & install dependencies for shared clipboard

Assuming the share is called "Shared"

```sh
mkdir -p ~/Shared
echo "Shared ~/Shared virtiofs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
```

This syncs the clipboard between Wayland and some kind of X11 which is what spice uses for shared memory

Remember to enable shared memory in the virmanager configs

```sh
sudo apt install -y cargo libxcb-xfixes0-dev
cargo install clipboard-sync
mkdir -p ~/.config/autostart
echo -e "[Desktop Entry]\nExec=~/.cargo/bin/clipboard-sync\nIcon=\nName=clipboard-sync\nPath=\nTerminal=False\nType=Application" >~/.config/autostart/clipboard-sync.desktop
~/.cargo/bin/clipboard-sync &
```

To add to autostart manually Open system settings, go to Autostart, and add the command to the list

```
~/.cargo/bin/clipboard-sync
```

</details>

<details>
    <summary>Native - Lenovo</summary>
Add your home volume to the fstab
```sh
sudo mkdir -p /mnt/big_one
echo "/dev/disk/by-uuid/7e3ed879-d3f7-44ad-a89d-b1dbe85814f9 /mnt/big_one/ ext4 defaults 0 0" | sudo tee -a /etc/fstab
```
</details>

## Install your github-ssh_keys & inform ssh which keys to use for Github

```sh
sudo apt install -y curl git
mkdir -p ~/.ssh
curl -o /tmp/github-ssh_keys.zip https://raw.githubusercontent.com/jasonmb626/mySetups/main/resources/github-ssh_keys.zip
unzip /tmp/github-ssh_keys.zip -d ~/.ssh
ls -l ~/.ssh
echo "Host github.com\n  User git\n  IdentityFile ~/.ssh/github_id_ed25519" >> ~/.ssh/config
ssh -T -p 443 git@ssh.github.com
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder, username may not match if you chose something other than jason.

```
-rw-------. 1 jason jason 444 Jan 14  2024 github_id_ed25519
-rw-r--r--. 1 jason jason  88 Jan 14  2024 github_id_ed25519.pub
```

You'll be prompted for your passphrase. Make sure to select "Remember"

## Clone your Setups repository

```sh
mkdir ~/src
git clone git@github.com:jasonmb626/mySetups.git ~/src/mySetups
```

Set your git configurations

```sh
git config --global user.email "jasonmb626@gmail.com"
git config --global user.name "Jason Brunelle"
git config --global init.defaultBranch main
git config --global pull.rebase true
```

but is easier to add to a script.

## Clone your dotfiles/tools repositories

```sh
git clone git@github.com:jasonmb626/dotfiles-dev.git ~/git/dotfiles-dev
```

## Install Docker

### Remove any old dependencies that might be present

```sh
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

This is recommended per the Docker install guide. In different editions it removes nothing or lots. Best to do it.

### Install the official docker repository

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Install, start, enable Docker & and give use Docker permissions

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
sudo systemctl enable --now docker
```

### Install fish, (n)vim

```sh
sudo apt install -y fish vim neovim
chsh
```

set to /usr/bin/fish

#### Install fonts

Install the 2 Fira fonts recommended for Powerline 10k
Download from [GitHub](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraMono/Regular)

```sh
mkdir ~/.local/share/fonts
curl -o ~/.local/share/fonts/FiraMonoNerdFontMono-Regular.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/FiraMono/Regular/FiraMonoNerdFontMono-Regular.otf
curl -o ~/.local/share/fonts/FiraMonoNerdFont-Regular.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/FiraMono/Regular/FiraMonoNerdFont-Regular.otf
```

Or full font package [here](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip)
or in this base repo in fonts/ttf folder.

### Install dependencies for extending Gnome functionality

```sh
sudo apt install -y gnome-tweaks gnome-shell-extension-manager
```

## Desktop Appearance

### Set some globals

```sh
echo "GTK_THEME=Andromeda" >>~/.config/environment.d/theme.conf
echo "YT_API_KEY=xxxx" >>~/.config/environment.d/keys.conf
```

Fill in API key from your vault if needed

### Set all the theme options

<details>
  <summary>Copy/Paste - Command Prompt entries</summary>

Wallpaper

```sh
mkdir ~/.local/share/wallpapers
cp ~/git/mySetups/resources/Wallpapers/* ~/.local/share/wallpapers/
```

Now Install the Extensions

- User Themes
- Clipboard Indicator

```sh
export PATH=$PATH:/home/jason/.bin
gnome-shell-extension-installer 19
gnome-shell-extension-installer 779
mkdir -p ~/.local/share/gnome-shell/extensions/
git clone https://github.com/jasonmb626/multi-monitors-add-on.git ~/.local/share/gnome-shell/extensions/multi-monitors-add-on@spin83
```

Icon/Cursor/Theme

```
mkdir -p ~/.themes
git clone https://github.com/EliverLara/Andromeda-gtk.git ~/.themes/Andromeda
mkdir -p ~/.icons
git clone https://github.com/alvatip/Nordzy-cursors /tmp/Nordzy-cursors
cd /tmp/Nordzy-cursors
./install.sh
cd
rm -fr /tmp/Nordzy-cursors
```

Import Gnome Settings via dconf

```sh
cat ~/git/mySetups/LinuxDev/gnome49.conf | dconf load /
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

#### Reboot or change won't take effect

## Complete Neovim setup?

Start neovim

```sh
nvim
```

Install the markdown parser for Treesitter

```
:TSInstall markdown
```

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
