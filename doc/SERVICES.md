# Services

## SSH

### Setup SSH

To install OpenSSH we need to use the package manager ``apt``. First thing to do is to update it with the commande:

```shell
apt-get update -y
apt-get upgrade -y
sudo apt install openssh-server
```

### Servicer status

To see if the service is currently running run:

```shell
sudo systemctl service ssh
```

To restart the service run:

```shell
service ssh restart
```

### Change server port

As we need to change the default ssh port from 22 to 4242, we need to change the config in ``/etc/ssh/sshd_config``:

```shell
sudo nano /etc/ssh/sshd_config
```

Find the line ``#Port 22`` and replace it by ``Port 4242``.

```shell
sudo grep Port /etc/ssh/sshd_config #check if the change is right
```

We need to remove the ssh privege to the root change the line as ``PermitRootLogin no #disabled`` in ``/etc/ssh/sshd_config``.

## UFW

### Setup UFW

To install uwf do the follwing:

```shell
apt-get install ufw
sudo ufw enable
sudo ufw status numbered #chech the service status
```

We need to delete allow and delete the following:

```shell
sudo ufw allow ssh
sudo ufw allow 4242
sudo ufw delete <position number of port 22>
```

## libpam-pwquality

### Setup libpam-pwquality

Installing password quality checking library with:

```shell
sudo apt-get install libpam-pwquality
```

## Crontab

A crontab file contains instructions for the cron(8) daemon in the following simplified manner: “run this command at this time on this date”

To install ``Crontab`` run:

```shell
sudo apt-get update -y
sudo apt-get install -y net-tools
```
