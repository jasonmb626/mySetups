# Setting up my CachyOS KDE development machine (WIP)

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

Add your SSH key to ssh-agent & test connection. (Correct key used automatically b/c set in config)

```sh
sudo pacman -S ksshaskpass egl-wayland2
systemctl --user enable --now ssh-agent
mkdir -p ~/.config/environment.d
echo -e "SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket\nSSH_ASKPASS_REQUIRE=prefer\nSSH_ASKPASS=/usr/bin/ksshaskpass" >~/.config/environment.d/ssh_askpass.conf
```

Installing egl-wayland2 suppresses ksshaskpass warnings and is necessary for later theming

Log out and log back in

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
cat <<EOF >~/.gitconfig
[user]
	email = jasonmb626@gmail.com
	name = Jason Brunelle
[init]
	defaultBranch = main
[pull]
	rebase = true
EOF
```

The above is same as:

- git config --global user.email "jasonmb626@gmail.com"
- git config --global user.name "Jason Brunelle"
- git config --global init.defaultBranch main
- git config --global pull.rebase true

but is easier to add to a script.


## Install theme

System Settings -> Colors & Themes -> Global Theme
Click Get New
Search for Andromeda
Install and Apply Andromeda Plasma 6 by eliverlara

## Move the Titlebar buttons
System Settings -> Colors & Themes -> Global Theme -> Window Decorations
Upper right -- Configure Titlebar Buttons...
Close - Minimize - Maximize -------- Pin Keep_Below Keep_Above Context Help
Apply

## Cursors
System Settings -> Colors & Themes -> Global Theme -> Cursors
Click Get New...
Search for Nordzy
Install and Apply Nordszy-cursors.tar.gz

(More to come)

## KDE Connect

Make sure firewall isn't blocking KDE Connect:

```sh
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload
```

Install sshfs for browsing phone filesystem

```sh
sudo pacman -S sshfs
```
