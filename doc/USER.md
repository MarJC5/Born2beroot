# User

## Add sudo

Here is the step to add ``sudo`` privilege package:

```shell
apt-get update -y
apt-get upgrade -y
apt install sudo
```

To add ``sudo`` to user:

```shell
su - #login as root
usermod -aG sudo <user_name>
groups <user_name> #will display the user groups, check if the sudo groups appears)
```

To add privilege as ``su``:
```shell
sudo visudo
```

Add the following line the file:

```shell
<user_name> ALL=(ALL) ALL
```

## Password policy

- Your password should expire every 30 days.
- The minimum number of days before you can change a password will beconfigured to 2.
- The user should receive a warning 7 days before his password does not expire.
- Your password will be at least 10 characters long, including a capital letter and a number, and must not contain more than 3 consecutive identical characters.
- The password should not include the username.
- The following rule does not apply to the root user: the password must contain at least 7 characters which are not present in the old past.

Of course ``root`` password will have to follow this policy.

1. Change the password length, capital letter, number and non consecutive :

```shell
sudo nano /etc/pam.d/common-password
```

Find the following line and add ``minlen=10`` at the end.

```nano
password [success=1 default=ignore] pam_unix.so obscure sha512
```

To set at least one upper-case letter in the password, add a word ``ucredit=-1`` at the end of the following line.

```nano
password    requisite         pam_pwquality.so retry=3
```

Add these values (min lower-case 1 letter, min upper-case 1 letter, min digit 1, max same letter repetition 3, whether to check if the password contains the user name in some form (enabled if the value is not 0), the minimum number of characters that must be different from the old password=7, enforce_for_root: same policy for root users).

The final set will be something like this:
```nano
password    requisite         pam_pwquality.so retry=3 lcredit =-1 ucredit=-1 dcredit=-1 maxrepeat=3 usercheck=0 difok=7 enforce_for_root
```

2. Password expiration
Run ``sudo nano /etc/login.defs`` and change the following:

From:
```nano
PASS_MAX_DAYS 9999
PASS_MIN_DAYS 0
PASS_WARN_AGE 7
```

To:
```nano
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```

Change it like this:(max 30 days, min number of days(2) allowed before the modification, receive a notification before expiration at least 7 days before)

To set maximum number of days between password change to existing users, you must run the following command:

```shell
sudo chage -M <days> <username>
```

To set minimum number of days between password change, run:

```shell
sudo chage -m <days> <username>
```

To set warning before password expires, run:

```shell
sudo chage -W <days> <username>
```

To display the password for the existing users, run:

```shell
sudo chage -l <username>
```

3. Reboot to apply all changes

## Create ``user`` and ``group``

Create a new user ``group`` is very easy:

```shell
sudo groupadd <group_name>
getent group #check if group is created
```

Create a new user is similar:

```shell
sudo adduser <user_name>
```

To check all the local user run:

```shell
cut -d: -f1 /etc/passwd
```

Add user to a specific group:

```shell
sudo usermod -aG <group_name> <user_name>
getent group <group_name> #check if the user is in the group
```

Check all the user group run:

```shell
groups
```

Check if the current status of user password, last change etc:
```shell
chage -l <user_name>
```

## Configuring sudoers group

- Authentication using sudo will be limited to 3 tries in case of password wrong.
- A message of your choice is displayed in the event of an error due to a wrong password when using sudo.
- Each action using sudo will be archived, both inputs and outputs. The log is located in the ``/var/log/sudo/folder``.
- TTY mode will be activated for security reasons.
- The paths that can be used by sudo will be restricted, again for questions of security. Example :
``/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin``

To do so we need to modify sudoers. Run ``sudo nano /etc/sudoers``:

```nano
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
Defaults        passwd_tries=3
Defaults        badpass_message="Password is wrong, please try again!"
Defaults        logfile="/var/log/sudo/sudo.log"
Defaults        log_input, log_output
Defaults        requiretty
```
Why use ``tty``? If some non-root code is exploited (a PHP script, for example), the requiretty option means that the exploit code won't be able to directly upgrade its privileges by running sudo.)

To save the log file we need to login as root and create the folder ``/var/log/sudo/``.
