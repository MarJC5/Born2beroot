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
| Storage | 32GB |
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
1. Select "Guided - use entire disk" and delete all current partition
2. Create manualy primary part1, 2, 3
3. Setup Crypted disk and select part 3
4. Create manualy LVM by selecting "Create logical volume"
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

### Packages and services

1. After the disk partition it request to add extra media (apt) and select de.debian.org
2. As we want the minimum of services we must unselect all in the software selection menu.
3. Install the GRUB boot loader select "yes" and choos /dev/sda

| Name | Description |
|--|--|
|||
