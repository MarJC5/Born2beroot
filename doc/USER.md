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

3. Reboot to apply all changes

