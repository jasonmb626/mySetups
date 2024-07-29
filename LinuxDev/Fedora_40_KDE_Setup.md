# Setting up my Fedora 40 development machine (wip)

From a fresh Fedora 40 KDE installation, updated, username jason

If using Windows as host and Fedora 40 inside of VirtualBox, you may want to take these additional steps

## \(Optional\) add user to vboxsf group so you can share folders inside VirtualBox

```sh
sudo usermod -aG vboxsf jason
```

## \(Optional\) disable Super+G game bar

From Windows PowerShell (run as administrator)

```
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
```

Then _reboot_ or changes won't take effect.

## \(Optional\) add your shared folder if using virtmanager & install dependencies for shared clipboard

Assuming the share is called "shared"

```sh
mkdir -P /home/jason/Shared
echo "Shared /home/jason/Shared virtiofs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a

sudo dnf install cargo libxcb-devel
cargo install clipboard-sync
```

Open system settings, go to Autostart, and add the command to the list

/home/jason/.cargo/bin/clipboard-sync

Reboot

## Tweak DNF and its config

```sh
sudo dnf install -y dnf5 #Newer, faster dnf
echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf #allow more mirrors
```

## Install packages

```sh
sudo dnf install git
```

## Install your github-ssh_keys

```sh
curl -o /tmp/github-ssh_keys.zip https://raw.githubusercontent.com/jasonmb626/mySetups/main/resources/github-ssh_keys.zip
unzip /tmp/github-ssh_keys.zip -d ~/.ssh
ls -l ~/.ssh
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder.

```
-rw------- 1 jason jason 3.4K xxxx-xx-xx 07:14 id_rsa
-rw-r--r-- 1 jason jason  749 xxxx-xx-xx 06-02 07:14 id_rsa.pub
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
git clone https://github.com/tmux-plugins/tpm /home/jason/.config/tmux/plugins/tpm
ln -s ~/git/dotfiles-dev/zsh/ ~/.config/zsh
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

This is recommended per the Docker install guide, but frankly all it seems to do (on a fresh install) is remove docker-selinux which gets added right back in (from the same repo) in a follow-up step.

### Install the official docker repository

```sh
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

### Install, start, enable Docker & and give use Docker permissions

```sh
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker jason
sudo systemctl start docker
sudo systemctl enable docker
```

### Install zsh, (n)vim, gnome-shell-extension-pop-shell, xprop and tool to provide chsh

util-linux-user provides chsh command

qt needed for some dbus calls, such as from "toggle overview" button

```sh
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y zsh util-linux-user vim neovim gcc gcc-c++ patch npm ripgrep mercurial fd-find lazygit qt;
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
echo -e "\n#Postgres defaults\nexport PGUSER=app\nexport PGPASSWORD=654321\nexport PGHOST=localhost\nexport PGPORT=5432\nexport PGDATABASE=project_name" | sudo tee -a /etc/environment
echo -e "if [[ -z \"\$XDG_CONFIG_HOME\" ]]; then\n	export XDG_CONFIG_HOME=\"\$HOME/.config\"\nfi\n\nif [[ -d \"\$XDG_CONFIG_HOME/zsh\" ]]; then\n	export ZDOTDIR=\"\$XDG_CONFIG_HOME/zsh/\"\nfi" | sudo tee -a /etc/zshenv
```

### Set all the theme options

## Set your KDE options

```sh
$HOME/git/mySetups/LinuxDev/set_kde_configs.sh
```

Change the look and feel to your prefrences.

### Set the themes

Open Settings -> Colors & Themes

- Global Themes
  Select Get New
  Search Nord
  Install Utterly Nord for Plasma 6
  Once installed, enable it
  CLick Utterly Nord under Global Themes
  Also check "Desktop and widnow layout
  Click Apply

- Icons: Zafiro-Nord-Light-Blue
- Cursor: Nordic-cursors (Might show already enabled. Might have to switch to another and switch back)

Right click top bar
Show panel configuration
Remove the Window Buttons applet

Right click Application launcher in top bar
Show Alternatives
Choose application dashboard

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

#### Set the Konsole Settings

Open Console. Hamburger menu => Create New Profile

- General
  Name the Profile: Utterly Nord w Nerd Font

- Appearance
  Get New...
  Install Utterly Nord by himdek, then choose from the list
  By Font, click Choose...
  Pick FiraMono Nerd Font 12

Under profiles Choose Nord
Check custom font, set to FiraMono Nerd Font 12

Optional - under colors, change transparent background.

#### Reboot

This is a good time to reboot so all the changes get sourced properly.

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

### Optional: add to zsh rc so this happens automatically when starting terminal

```sh
cat <<EOF >>~/.config/zsh/.zshrc
if [[ ! -x /home/app/.local/share/nvim/lazy/nvim-treesitter/parser/markdown.so ]]; then
    if [[ -x /home/app/.config/nvim/if_docker/auto_install_dependencies.sh ]]; then
        /home/app/.config/nvim/if_docker/auto_install_dependencies.sh >/dev/null 2>&1
        echo "Neovim packages are installing in the background. Please wait before starting up neovim."
        echo "This usually happens only on a fresh install."
        echo "Sleeping 30 seconds."
        sleep 30
        PID=\$(ps aux | grep 'nvim --headless -c TSInstall! markdown' | grep -v grep | awk '{print \$2}')
        kill \$PID
        echo "You may now start neovim. Additional LSPs, formatters, and linters may install on startup."
        echo "Once there is no longer feedback that new tools are installing, we recommend restarting neovim one more time."
    fi
fi
EOF
```

Otherwise:

Start neovim

```sh
nvim
```

Install the markdown parser for Treesitter

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
