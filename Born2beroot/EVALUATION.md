# EVALUATION

## Why Debian?
It's easier to install and configure than CentOS (and i haven't use CentOS befoe)

## What is virtual machine?

A Virtual Machine (VM) is a compute resource that uses software instead of a physical computer to run programs and deploy 
apps. Each virtual machine runs its own operating system and functions separately from the other VMs, even when they are all
running on the same host. For example, you can run a virtual MacOS machine on a physical PC. 

## What it's purpose?

VMs may be deployed to accommodate different levels of processing power needs, to run software that requires a different
operating system, or to test applications in a safe, sandboxed environment. 

## How does it works?

VM working through "Virtualization" technology. Virtualization uses software to simulate virtual hardware that allows 
VMs to run on a single host machine.

## Diff between aptitude and apt?

Aptitude is a high-level package manager while APT is lower-level package manager which can be used by other 
higher-level package managers
(read more: https://www.tecmint.com/difference-between-apt-and-aptitude/)

## What is AppArmor?

AppArmor ("Application Armor") is a Linux kernel security module that allows the system administrator to restrict programs'
capabilities with per-program profiles.
(read more: https://en.wikipedia.org/wiki/AppArmor)

## What is SSH?

SSH, also known as Secure Shell or Secure Socket Shell, is a network protocol that gives users, particularly system 
administrators, a secure way to access a computer over an unsecured network.
(read more: https://searchsecurity.techtarget.com/definition/Secure-Shell)

```nano
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
| You have to create a new user here.        |
|                                            |
| $ sudo adduser username                    | <- creating new user (yes (no))
| $ sudo chage -l username                   | <- Verify password expire info for new user
| $ sudo adduser username sudo               |
| $ sudo adduser username user42             | <- assign new user to sudo and user42 groups
\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
```

## How your script works?

... [README.md](https://github.com/MarJC5/Born2beroot/blob/main/Born2beroot/monitoring.sh)

```nano
|***************************************|
| 1)  lsblk                             1 <- Check partitions
| 2)  sudo aa-status                    2 <- AppArmor status
| 3)  getent group sudo                 3 <- sudo group users
| 4)  getent group user42               4 <- user42 group users
| 5)  sudo service ssh status           5 <- ssh status, yep
| 6)  sudo ufw status                   6 <- ufw status
| 7)  ssh username@ipadress -p 4242     7 <- connect to VM from your host (physical) machine via SSH
| 8)  nano /etc/sudoers.d/<filename>    8 <- yes, sudo config file. You can $ ls /etc/sudoers.d first
| 9)  nano /etc/login.defs              9 <- password expire policy
| 10) nano /etc/pam.d/common-password  10 <- password policy
| 11) sudo crontab -l                  11 <- cron schedule
|***************************************|
```

How to change hostname?

```shell
sudo nano /etc/hostname
```

Where is sudo logs in ``/var/log/sudo``?

```shell
cd /var/log/sudo/
```

How to add and remove port 8080 in UFW?

```shell
sudo ufw allow 8080 # <- allow
sudo ufw status # <- check
sudo ufw deny 8080 # <- deny (yes yes)
```

How to run script every 30 seconds?

Remove or commit previous cron "schedule" and add next lines in crontab file

```shell
sudo crontab -e

#change line in /usr/local/bin/monitoring.sh
*/1 * * * * /usr/local/bin/monitoring.sh
*/1 * * * * sleep 30s && /usr/local/bin/monitoring.sh
```

To stop script running on boot you just need to remove or commit line in crontab file.

## Bonus

### WordPress

Website url -> [http://127.0.0.1:9001/born2beroot/](http://127.0.0.1:9001/born2beroot/)

### Cockpit-project

Portal url -> [http://127.0.0.1:9090/system](http://127.0.0.1:9090/system)
