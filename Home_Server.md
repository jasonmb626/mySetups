# Home Media and GitLab Server

Having a dedicated machine in the home running Windows has its conveniences, so these steps are for getting Emby running in Windows, allowing a remote connection in, and finally having a Fedora Server instance autostart in VirtualBox for hosting the GitLab server.

In case you forget, your current home server is hosted at 10.0.0.115

## Create an additional user

Have trouble remoting in with "Microsoft Account" so create a new regular User w/o a Microsof Account

Settings -> Accounts -> Family & other users -> Add account
* Click _I don't have this person's sign-in information_ link
* Click _Add a user without a Microsoft account_ link
* Finish adding the account

## Install Virtualbox

Follow steps from https://www.virtualbox.org/

## Install Fedora Server \(Fedora Server 36 used for these instructions\)

## Install Docker, set up user for Docker access

```sh
sudo dnf install vim moby-engine docker-compose
sudo usermod -aG docker jason
```

Replace jason with username if not jason

## Reboot

```sh
sudo reboot
```

## Download/run gitlab docker image

Modified from instructions found [here](https://docs.gitlab.com/ee/install/docker.html)

get your ip address

```sh
ip a
```

change <ip addr> below to what was obtained above

```sh
docker run --detach \
  --hostname jason-gitlab \
  --publish 443:443 --publish 80:80 --publish 8022:22 \
  --name gitlab \
  --restart always \
  --volume /home/jason/gitlab-test/gitlab_config:/etc/gitlab:Z \
  --volume /home/jason/gitlab-test/gitlab_logs:/var/log/gitlab:Z \
  --volume /home/jason/gitlab-test/gitlab_data:/var/opt/gitlab:Z \
  --shm-size 256m \
  gitlab/gitlab-ce:latest
```

It seems to take 20+ Minutes to really get going.

If first time you'll need root login credentials:

```sh
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

If you need to check status of docker run:

```sh
docker logs -f gitlab
```

### On your individual machines needing access to this gitlab

edit ~/.ssh/config

Change Hostname to whatever ip address the VM has
```
Host jason-gitlab
  Hostname 10.0.0.74
  Port 8022
  User git