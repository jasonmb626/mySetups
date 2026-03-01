# Setting up my CachyOS KDE machine (WIP)

From a fresh CachyOS KDE installation

## \(Optional\) If using virmanager

### add your shared folder

Assuming the share is called "Shared"

```sh
mkdir -p /home/$USER/Shared
echo "Shared /home/$USER/Shared virtiofs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
```

### install shared clipboard

```sh
paru -S clipboard-sync
systemctl --user enable --now clipboard-sync
```

You may get multiple options to choose from. I tried 1 and 2 and both worked.

## \(Optional\) If native

### Filesystem
Add your home volume to the fstab

```sh
sudo mkdir -p /mnt/big_one
echo "/dev/disk/by-uuid/7e3ed879-d3f7-44ad-a89d-b1dbe85814f9 /mnt/big_one/ ext4 defaults 0 0" | sudo tee -a /etc/fstab
```

### KDE Connect

Make sure firewall isn't blocking KDE Connect:

```sh
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload
```

Install sshfs for browsing phone filesystem

```sh
sudo pacman -S --noconfirm sshfs
```

### Virtmanager

```sh
sudo pacman -S qemu virt-manager dnsmasq vde2 bridge-utils openbsd-netcat libvirt
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt libvirt-qemu kvm qemu $USER
```

## Add Flatpak Support

```sh
sudo pacman -S --noconfirm flatpak discover
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Install your github-ssh_keys & inform ssh which keys to use for Github

```sh
mkdir -p /home/$USER/.ssh
curl -o /tmp/github-ssh_keys.zip https://raw.githubusercontent.com/jasonmb626/mySetups/main/resources/github-ssh_keys.zip
unzip /tmp/github-ssh_keys.zip -d /home/$USER/.ssh
ls -l /home/$USER/.ssh
echo -e "Host github.com\n  User git\n  IdentityFile ~/.ssh/github_id_ed25519" >> ~/.ssh/config
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder, username may not match if you chose something other than jason.

```
-rw-------. 1 jason jason 444 Jan 14  2024 github_id_ed25519
-rw-r--r--. 1 jason jason  88 Jan 14  2024 github_id_ed25519.pub
```

Add your SSH key to ssh-agent

```sh
sudo pacman -S --noconfirm ksshaskpass egl-wayland2
systemctl --user enable --now ssh-agent
mkdir -p ~/.config/environment.d
echo -e "SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket\nSSH_ASKPASS_REQUIRE=prefer\nSSH_ASKPASS=/usr/bin/ksshaskpass" >~/.config/environment.d/ssh_askpass.conf
```

Installing egl-wayland2 suppresses ksshaskpass warnings and is necessary for later theming

## Log out and log back in
Log out and log back in

## Finish ssh key setup
```sh
ssh-add ~/.ssh/github_id_ed25519
```

You'll be prompted for your passphrase. Make sure to select "Remember"

```sh
ssh -o StrictHostKeyChecking=no -T -p 443 git@ssh.github.com
```

## Clone your Setups repository

```sh
mkdir ~/git
git clone git@github.com:jasonmb626/mySetups.git ~/git/mySetups
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

## Development

### Install VSCode

```sh
paru -S visual-studio-code-bin
```

### Set your globals if necessary
```sh
echo "YT_API_KEY=xxxx" >>~/.config/environment.d/keys.conf
```

## Docker

```sh
sudo pacman -S --noconfirm docker docker-compose docker-buildx
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
#Allow IP Forwarding...needed for docker netwroking
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-docker.conf
sudo sysctl --system
```
