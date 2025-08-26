# Setting up my CachyOS Cinnamon development machine (WIP)

From a fresh CachyOS Cinnamon installation

## \(Optional\) add your shared folder if using virtmanager & install dependencies for shared clipboard

Assuming the share is called "Shared"

```sh
mkdir -p /home/$USER/Shared
echo "Shared /home/$USER/Shared virtiofs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
```

## Install your github-ssh_keys & inform ssh which keys to use for Github

```sh
mkdir -p /home/$USER/.ssh
curl -o /tmp/github-ssh_keys.zip https://raw.githubusercontent.com/jasonmb626/mySetups/main/resources/github-ssh_keys.zip
unzip /tmp/github-ssh_keys.zip -d /home/$USER/.ssh
ls -l /home/$USER/.ssh
echo "Host github.com\n  User git\n  IdentityFile ~/.ssh/github_id_ed25519" >> ~/.ssh/config
```

You'll be prompted for a password at the unzip. (Enter password)

You should now have these files and permissions in that folder, username may not match if you chose something other than jason.

```
-rw-------. 1 jason jason 444 Jan 14  2024 github_id_ed25519
-rw-r--r--. 1 jason jason  88 Jan 14  2024 github_id_ed25519.pub
```

Add your SSH key to ssh-agent & test connection. (Correct key used automatically b/c set in config)

```sh
echo "# register gnome keyring ssh manager\nif [ -e $XDG_RUNTIME_DIR/gcr/ssh ]; then\n    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh\nfi" >~/.xprofile
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
systemctl enable --now --user ssh-agent.socket
systemctl enable --now --user gcr-ssh-agent.socket
ssh -T -p 443 git@ssh.github.com
```

You'll be prompted for your passphrase. Make sure to select "Remember"

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
- git config --global pull.rebase true

but is easier to add to a script.

(More to come)
