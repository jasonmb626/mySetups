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

## Clone your dotfiles/tools repositories

```sh
git clone git@github.com:jasonmb626/dotfiles-dev.git ~/src/dotfiles-dev
ln -s ~/src/dotfiles-dev/bin/ ~/.bin
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
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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

Install the 2 pathced Fira fonts  
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
mkdir -p ~/.config/environment.d/
echo "GTK_THEME=Andromeda" >>~/.config/environment.d/theme.conf
echo "YT_API_KEY=xxxx" >>~/.config/environment.d/keys.conf
```

Fill in API key from your vault if needed

### Set all the theme options

<details>
  <summary>Copy/Paste - Command Prompt entries</summary>

Wallpaper

```sh
mkdir -p ~/.local/share/wallpapers
cp ~/src/mySetups/resources/Wallpapers/* ~/.local/share/wallpapers/
```

Now Install the Extensions

- User Themes
- Clipboard Indicator
- GSConnect
- AATWS (Advanced Alt-Tab Window Switcher) 
- App menu is back 

```sh
export PATH=$PATH:~/.bin
gnome-shell-extension-installer 19
gnome-shell-extension-installer 779
gnome-shell-extension-installer 1319
gnome-shell-extension-installer 4412
gnome-shell-extension-installer 6433
mkdir -p ~/.local/share/gnome-shell/extensions/
git clone https://github.com/jasonmb626/multi-monitors-add-on.git ~/.local/share/gnome-shell/extensions/multi-monitors-add-on@spin83
```

Icon/Cursor/Theme

```
mkdir -p ~/.themes
git clone https://github.com/EliverLara/Andromeda-gtk.git ~/.themes/Andromeda
mkdir -p ~/.icons
git clone https://github.com/alvatip/Nordzy-cursors ~/src/Nordzy-cursors
cd ~/src/Nordzy-cursors
./install.sh
cd
rm -fr ~/src/Nordzy-cursors
```

Import Gnome Settings via dconf

```sh
cat ~/src/mySetups/LinuxDev/gnome49.conf | dconf load /
```

Reboot so everything takes effect

</details>

<details>
  <summary>Manually</summary>

Change the look and feel to your prefrences.

### Set your wallpaper

Right click desktop, select Change Background. Add Picture and set it as your desktop wallpaper

Set your wallapaper to one of the ones in mySetups

### Set your workspaces

Settings -> Multitasking

Workspaces

- Fixed, 6

### Enable Gnome Extensions

```sh
extension-manager
```

Browse themes and install these:

#### Enable [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension page
#### Enable [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
#### Enable [gsconnect[(https://extensions.gnome.org/extension/1319/gsconnect/)
#### Enable [AAWS[(https://extensions.gnome.org/extension/4412/advanced-alttab-window-switcher/)
#### Enable [App menu is back](https://extensions.gnome.org/extension/6433/app-menu-is-back/)

## Download your preferred themes

https://github.com/EliverLara/Andromeda-gtk


- place in ~/.themes

### Set the themes

Open tweaks
-> Appearance

- Icons: Yaru
- Cursor: Nordzy
- Shell: Andromeda
- Legacy Applications: Andromeda

-> Window Titlebars -> Placement = Left

### Set Gnome Keyboard Shortcuts

Settings -> Keyboard -> Keyboard Shortcuts
View and Customize Shortcuts

Navigation

Set "Hide all normal windows" to Super+D
Set your "Switch to workspace #" to your keys

#### Reboot

This is a good time to reboot so all the changes get sourced properly.

</details>

## Terminal

Set to Dracula

## Config fish

```sh
fish_config
```

Set prompt to Disco

## Theme for snaps
```sh
curl -o /tmp/andromeda-gtk_0.1_amd64.snap https://raw.githubusercontent.com/jasonmb626/mySetups/main/resources/andromeda-gtk_0.1_amd64.snap
sudo snap install snapcraft --classic
sudo snap install /tmp/andromeda-gtk_0.1_amd64.snap --dangerous
bash -c "for i in \$(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print \$2}'); do sudo snap connect \$i andromeda-gtk:gtk-3-themes; done"
```

Above assumes you're running fish shell, if that fails open a bash sessions and run this:
```sh
for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print $2}'); do sudo snap connect $i andromeda-gtk:gtk-3-themes; done
```

<details>
   <summary>If you need to rebuild the snap</summary>
Update the contents of resources/andromeda-snap/local-source/share/themes/Andromeda/ from its gitub if newer version desired.
```sh
cp -a /home/$USER/src/mySetups/resources/andromeda-snap /tmp/
docker run --rm -it -v /tmp/ndromeda-snap:/work snapcore/snapcraft:stable
```

In the container
```sh
cd /work
snapcraft --destructive-mode
```
andromeda-gtk_0.1_amd64.snap should now be in /tmp/andromeda-snap
</details>

## Fix firefox theming

- Open Firefix
- Right click next to the windows close, minimize, maximize buttons
- Select Customize Toolbar
- Click the "Title Bar" checkbox

## If using VSCode

```sh
snap install --classic code
```

### Fix titlebar
- Open VSCode
- Ctrl+, to open settings
- Search Title Bar Style
- Change to native
- Restart VSCode when prompted

### Set theme
- Set to Andromeda