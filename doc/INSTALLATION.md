# Environement installation

## Ressources
1. [VirtualBox](https://www.virtualbox.org/)
2. [Debia ISO](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)

## VirtualBox - Configuration

### Add new VM

1. Select New
2. Select VM OS type, version and VM Name
3. Set RAM allocated to it (Default is 1024), create new Virtual Disk Image (VDI) and select the hard disk size (Default 12GB)

### Add ISO

The ISO is simply the OS Image, for this project Debian is used.
1. Select the VM and open "Settings"
2. Select "Storage" and click on "Controller: IDE +"
3. Choose the .iso file
4. Start the VM to configuret

## Debian - Configuration

1. Select Install (This will install only the VM in commande line)
2. Select language, country, keyboard
3. Choose hostname (ex: username42)
4. Leave domaine name empty
5. Set a strong password for the root
6. Enter user details and password

### Server details

| Component | Specification |
|--|--|
| Name | Born2beroot-jmartin |
| RAM | 1024MB |
| Storage | 31GB |
| OS | Debian 11.1.0-amd64 |
| Interface | No graphic |

### Server structure

| Partition | type |
|--|--|
| sda | disk |
| sda1 | part |
| sda2 | part |
| sda5 | crypt |

To create partitions proceed the following:
1. Select "Guided - use entire disk and set up encrypted LVM" and delete all current partition
2. Setup Crypted disk, just delete all logical part in sda5
3. Create manualy LVM by selecting "Create logical volume"
    - sda 30.8G
        - sda1 500M
        - sda2 1K
        - sda5_crypt 30.3G
            - LVMGroup-root     10G    /root
            - LVMGroup-swap     2.3G   [swap]
            - LVMGroup-home     5G     /home
            - LVMGroup-var      3G     /var
            - LVMGroup-srv      3G     /srv
            - LVMGroup-tmp      3G     /tmp
            - LVMGroup-var--log 4G /var/log

To see all the partition run:

```shell
lsblk
```

### Packages and services

1. After the disk partition it request to add extra media (apt) and select de.debian.org
2. As we want the minimum of services we must only select SSH in the software selection menu.
3. Install the GRUB boot loader select "yes" and choose /dev/sda
4. Finish the installation

| Name | Description |
|--|--|
| [SSH](https://github.com/MarJC5/Born2beroot/blob/main/doc/SERVICES.md#ssh) | With Secure Shell (SSH) you can establish a secure connection between your computer and the server where your website is located. |
| [UFW](https://github.com/MarJC5/Born2beroot/blob/main/doc/SERVICES.md#ufw) | Uncomplicated Firewall, is an interface to iptables that is geared towards simplifying the process of configuring a firewall. |
| [libpam-pwquality](https://github.com/MarJC5/Born2beroot/blob/main/doc/SERVICES.md#libpam-pwqality) | Provide common functions for password quality checking and also scoring them based on their apparent randomness. |
| [Crontab]() | File which contains the schedule of cron entries to be run and at specified times. |

### Connection to VM with SSH
Add forward rule for VirtualBox

1. Go to VirtualBox-> Choose the VM->Select Settings
2. Choose “Network”-> “Adapter 1"->”Advanced”->”Port Forwarding”
3. Add the rule: TCP 4242 4242
4. Restart ssh service ``sudo systemctl restart ssh`` and check the service status ``sudo service sshd status``
5. Connect to ssh with ``ssh your_username@127.0.0.1 -p 4242`` (``exit`` to disconnect)

### Change hostname

To display current hostname and server info run:

```shell
hostnamectl
```

Changer host name:

```shell
hostnamectl set-hostname <new_hostname>
```

Don't forget to change ``/etc/hosts`` file:

```nano
127.0.0.1       localhost
127.0.0.1       new_hostname
```

The reboot and check the change.
