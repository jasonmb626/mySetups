# Setting up my Fedora 40 development machine (wip)

From a fresh Fedora 40 KDE installation, updated.

<details>
  <summary>Virtualbox</summary>
If using Windows as host and Fedora 40 inside of VirtualBox, you may want to take these additional steps

## \(Optional\) add user to vboxsf group so you can share folders inside VirtualBox

```sh
sudo usermod -aG vboxsf $(USER)
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
mkdir -p /home/$(USER)/Shared
echo "Shared /home/$(USER)/Shared virtiofs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
```

This syncs the clipboard between Wayland and some kind of X11 which is what spice uses for shared memory

Remember to enable shared memory in the virmanager configs

```sh
sudo dnf install -y cargo libxcb-devel
cargo install clipboard-sync
mkdir -p /home/$(USER)/.config/autostart
echo -e "[Desktop Entry]\nExec=/home/$(USER)/.cargo/bin/clipboard-sync\nIcon=\nName=clipboard-sync\nPath=\nTerminal=False\nType=Application" >/home/$(USER)/.config/autostart/clipboard-sync.desktop
/home/$(USER)/.cargo/bin/clipboard-sync &
```

To add to autostart manually Open system settings, go to Autostart, and add the command to the list

```
/home/$(USER)/.cargo/bin/clipboard-sync
```

</details>

<details>
    <summary>Native - Lenovo</summary>
Add your home volume to the fstab
```sh
echo "UUID=f65c61c5-ba0e-4d07-b9b3-b65d9c2e6194 /home/$(USER) ext4 defaults 0 0" | sudo tee -a /etc/fstab
```
</details>

## Tweak DNF and its config

```sh
echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf #allow more mirrors
sudo dnf install -y dnf5 #Newer, faster dnf
```

## Install packages

```sh
sudo dnf -y install git
```

## Install your github-ssh_keys

```sh
curl -o /tmp/github-ssh_keys.zip https://raw.githubusercontent.com/$(USER)mb626/mySetups/main/resources/github-ssh_keys.zip
unzip /tmp/github-ssh_keys.zip -d ~/.ssh
ls -l ~/.ssh
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder, username may not match if you chose something other than jason.

```
-rw-------. 1 jason jason 444 Jan 14  2024 github_id_ed25519
-rw-r--r--. 1 jason jason  88 Jan 14  2024 github_id_ed25519.pub
```

Now fix SSH_ASKPASS variable

```sh
sudo rm /etc/profile.d/gnome-ssh-askpass.*
export SSH_ASKPASS=/usr/bin/ksshaskpass #Now that the above were deleted it'll default to this on next boot
echo -e '#!/bin/bash\n# always have the SSH keys loaded\nssh-add /home/$(USER)/.ssh/github_id_ed25519 </dev/null' >/home/$(USER)/.ssh/startup_keys.sh
chmod +x /home/$(USER)/.ssh/startup_keys.sh
/home/$(USER)/.ssh/startup_keys.sh
```

You'll be prompted (graphically with kwallet) for the passphrase. Enter it here, select "Remember Passord" and it'll keep.
It should load your keys into memory

You can test your GitHub ssh connection with

```sh
ssh -T -p 443 git@ssh.github.com
```

Add this script as an autostart

```sh
mkdir -p /home/$(USER)/.config/autostart
echo -e "[Desktop Entry]\nExec=/home/$(USER)/.ssh/startup_keys.sh\nIcon=\nName=startup_keys.sh\nPath=\nTerminal=False\nType=Application" > /home/$(USER)/.config/autostart/startup_keys.sh.desktop
```

## Clone your Setups repository

```sh
mkdir ~/git
git clone git@github.com:jasonmb626/mySetups.git ~/git/mySetups
```

Set your git configurations

```sh
cat <<EOF >~/.gitconfig
[user]
	email = jasonmb626@gmail.com
	name = Jason Brunelle
[init]
	defaultBranch = main
[pull]
	rebase = false
EOF
```

The above is same as:

- git config --global user.email "jasonmb626@gmail.com"
- git config --global user.name "Jason Brunelle"
- git config --global init.defaultBranch main
- git config --global pull.rebase false # merge

but is easier to add to a script.

## Clone your dotfiles repository and symlink your directories

```sh
git clone git@github.com:jasonmb626/dotfiles-dev.git ~/git/dotfiles-dev
git clone git@github.com:jasonmb626/epicvim.git ~/git/epicvim
ln -s ~/git/epicvim/ ~/.config/nvim
ln -s ~/git/dotfiles-dev/tmux/ ~/.config/tmux
ln -s ~/git/dotfiles-dev/alacritty/ ~/.config/alacritty
mkdir -p /home/$(USER)/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm /home/$(USER)/.config/tmux/plugins/tpm
ln -s ~/git/dotfiles-dev/zsh/ ~/.config/zsh
git clone git@github.com:jasonmb626/commandline_utilities.git
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

This is recommended per the Docker install guide, but it didn't remove anything.

### Install the official docker repository

```sh
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

### Install, start, enable Docker & and give use Docker permissions

```sh
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $(USER)
sudo systemctl start docker
sudo systemctl enable docker
```

### Install zsh, (n)vim, gnome-shell-extension-pop-shell, xprop and tool to provide chsh

util-linux-user provides chsh command

qt needed for some dbus calls, such as from "toggle overview" button

```sh
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y zsh util-linux-user vim neovim gcc gcc-c++ patch npm ripgrep mercurial fd-find lazygit qt alacritty
chsh
```

set to /usr/bin/zsh

#### Get zsh completions

```sh
mkdir -p ~/.local/share/zsh/completions/
curl -o ~/.local/share/zsh/completions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
```

## Desktop Appearance

### Set some globals

```sh
sudo flatpak override --filesystem=$HOME/.themes
echo -e "if [[ -z \"\$XDG_CONFIG_HOME\" ]]; then\n	export XDG_CONFIG_HOME=\"\$HOME/.config\"\nfi\n\nif [[ -d \"\$XDG_CONFIG_HOME/zsh\" ]]; then\n	export ZDOTDIR=\"\$XDG_CONFIG_HOME/zsh/\"\nfi" | sudo tee -a /etc/zshenv
```

### Set all the theme options

Change the look and feel to your prefrences.

### Set the themes

Open Settings -> Colors & Themes

- Global Themes
  Select Get New
  Search Nord
  Install Utterly Nord for Plasma 6
  Once installed, enable it
  CLick Utterly Nord under Global Themes
  Also check "Desktop and window layout
  Click Apply

- Icons: Zafiro-Nord-Light-Blue
- Cursor: Nordic-cursors (Might show already enabled. Might have to switch to another and switch back, or just wait until reboot.)
- Login Screen (SDDM): Nordic darker SDDM Plamsa 6

Settings -> Security and Privacy

- Screen Locking
- Configure Appearnce
  Utterly Nord

Right click top bar
Show panel configuration
Remove the Window Buttons applet and margins separators

Right click Application launcher in top bar
Show Alternatives
Choose application dashboard

Add Pager widget

Set height to 44

### Terminal

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

## Set your KDE options

```sh
$HOME/git/mySetups/LinuxDev/set_kde_configs.sh
```

#### Reboot

This is a good time to reboot so all the changes get sourced properly.

#### Reboot follow-up

Workspaces should have taken effect now

Configure Pager to show icons and desktop numbers

Start Alacritty w/ Meta+Return or from Dashboard

You should be prompted for sudo password as it's trying to install some stuff.

#### (Optional) Set the Konsole Settings

If you don't want to use Alacritty
Fonts seem to be overlapping in Konsole, even when choosing same font as Alacritty.

Open Konsole. Hamburger menu => Create New Profile
Note please restart Konsole if it was still running from when you curled down the fonts. They won't show until a restart.

- General
  Name the Profile: Utterly Nord w Nerd Font
  Check Default profile
- Appearance
  Get New...
  Install Utterly Nord by himdek, then choose from the list
  Edit it to change background color transparency to 10%

  By Font, click Choose...
  Pick FiraMono Nerd Font 12

Under profiles Choose Nord
Check custom font, set to FiraMono Nerd Font 12

#### (Optional) setting up PowerLevel10k (If not done via copy/paste)

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

## Complete Neovim setup

Start neovim

```sh
nvim
```

Install the markdown parser for Treesitter, if setup script was not added to zsh config above

```
:TSInstall markdown
```

Install stylua

```
:Mason
```

Find stylua and press 'i'

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
