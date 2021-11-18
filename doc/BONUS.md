# Bonus

## LVM

The Logical Volume Manager (LVM) provides tools to create virtual block devices from physical devices. Virtual devices may be easier to manage than physical devices, and can have capabilities beyond what the physical devices provide themselves. A Volume Group (VG) is a collection of one or more physical devices, each called a Physical Volume (PV). A Logical Volume (LV) is a virtual block device that can be used by the system or applications.

Installation [here](https://github.com/MarJC5/Born2beroot/blob/main/doc/INSTALLATION.md#server-structure)

## Wordpress[.](https://www.osradar.com/install-wordpress-with-lighttpd-debian-10/)

### 1. Install PHP

Follow this step to install ``php`` run:

```shell
sudo apt update && sudo apt -y upgrade
sudo apt -y install php php-common

php -v

#PHP 7.x.x (cli) (built: Jul  2 2021 03:59:48) ( NTS )
#Copyright (c) The PHP Group
#Zend Engine vx.x.x, Copyright (c) Zend Technologies
    #with Zend OPcache vx.x.x, Copyright (c), by Zend Technologies
```

To install all the Debian extensions run:

```shell
sudo apt -y install php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd  php-mbstring php-curl php-xml php-pear php-bcmath
```

### 2. Install Lighttpd

``Lighttpd`` is available from the official Debian repositories.

```shell
sudo apt install lighttpd
```

Once it has been installed, we will be able to check the operation of it, opening a web browser and going to ``http://SERVER_IP`` or ``http://localhost`` if we are in a local machine. Remember that this works through port 80 and it has to be available.

Enabling the PHP support to Lighttpd

```shell
sudo apt install php7.3 php7.3-fpm php7.3-mysql php7.3-cli php7.3-curl php7.3-xml
```

To start with, you have to modify the listen parameter in the PHP-fpm configuration file.

```shell
sudo nano /etc/php/7.3/fpm/pool.d/www.conf

# Add
listen = 127.0.0.1:9000
```

Allow lighttpd in the firewall

```shell
sudo ufw allow lighttpd
sudo ufw allow 9000
sudo ufw allow 80
```

Now, another configuration file needs to be modified. In this case, it is ``/etc/lighttpd/conf-available/15-fastcgi-php.conf`` and in it, you have to change the following:

```shell
sudo nano /etc/lighttpd/conf-available/15-fastcgi-php.conf

# Change from
"bin-path" => "/usr/bin/php-cgi",
"socket" => "/var/run/lighttpd/php.socket",

# To
"host" => "127.0.0.1",
"port" => "9000",
```

After saving the changes and closing the file, PHP-fpm must be enabled in Lighttpd.

```shell
sudo lighty-enable-mod fastcgi
# Enabling fastcgi: ok
sudo lighty-enable-mod fastcgi-php
# Enabling fastcgi-php: ok

# Restart to appy change
sudo systemctl restart lighttpd
sudo systemctl restart php7.3-fpm
```

Test PHP and Lighttpd

```shell
sudo nano /var/www/html/test.php
```

And add the following:

```php
<?php
phpinfo();
?>
```

Also, it’s a good idea to change the permissions of the Lighttpd root folder so that all files run correctly:

```shell
sudo chown -R www-data:www-data /var/www/html/
sudo chown -R 755 /var/www/html/
```

Now, open your web browser and go to ``http://your-server/test.php`` or if the installation is local ``http://localhost/test.php`` and you should see the server php config.

### 3. Install MariaDB

WordPress uses MySQL or MariaDB as a database backend to store and manage a site and user information. Here, we will install and use MariaDB as a database backend.

```shell
sudo apt-get install mariadb-server mariadb-client -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

If issue to enable mariaDB, due to locale setting, run and then try again.

```shell
sudo locale-gen
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
```

Setup MariaDB:

```shell
sudo mysql_secure_installation

Enter current password for root (enter for none):
Change the root password? [Y/n] Y
New password:
Re-enter new password:
Remove anonymous users? [Y/n] Y
Disallow root login remotely? [Y/n] Y
Remove test database and access to it? [Y/n] Y
Reload privilege tables now? [Y/n] Y
```

Create Wordpress Database

1. First, connect to the MariaDB
2. Provide your MariaDB root password then create a database and user
3. Next, flush the privileges to apply the changes then exit from the MariaDB

```shell
sudo mysql -u root -p

CREATE DATABASE <wordpress_database_name>;
GRANT ALL PRIVILEGES ON wordpressdb.* to <wordpress_username>@localhost identified by '<wordpress_user_password>';
FLUSH PRIVILEGES;
QUIT;
```

### 4. Install WordPress

Move to the path ``/tmp`` and run

```shell
sudo wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
```

Then move it to /var/www/html/ and change the permissions of the folder as well as the owner of it.

```shell
sudo mv wordpress/ /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod 755 -R /var/www/html/wordpress/
```

Now we will create a new virtual host in ``Lighttpd``.

First, let’s rename the WordPress folder with the name of the virtual host you want.

```shell
sudo mv /var/www/html/wordpress/ /var/www/html/<your_virtual_host_folder>
```

Then, create the folder dedicated to virtual hosts in Lighttpd.

```shell
sudo mkdir -p /etc/lighttpd/vhosts.d/
```

And add it to the main Lighttpd configuration file:

```shell
sudo nano /etc/lighttpd/lighttpd.conf
include_shell "cat /etc/lighttpd/vhosts.d/*.conf"
```

Now create the configuration file for the new Virtual host.

```shell
sudo nano /etc/lighttpd/vhosts.d/<your_virtual_host>.conf
```

Note how the file name equals the WordPress folder. This is for recommendation. Now add the following:

```shell
$HTTP["host"] =~ "(^|.)<your_virtual_host>.lan$" {
server.document-root = "/var/www/html/<your_virtual_host>.lan"
server.errorlog = "/var/log/lighttpd/<your_virtual_host>.lan-error.log"
accesslog.filename = "/var/log/lighttpd/<your_virtual_host>.lan-access.log"
url.rewrite-final = ("^/(.*.php)" => "$0", "^/(.*)$" => "/index.php/$1" )
}
```

Now, check the syntax.

```shell
sudo lighttpd -t -f /etc/lighttpd/lighttpd.conf

# Must return
Syntax OK
```

And restart Lighttpd.

```shell
sudo systemctl restart lighttpd
```

Now, open your web browser and go complete the installation.
Go on 127.0.0.1:80 to see the wordpress page :)

PS: Don't forget to open the port ``9000`` and ``80`` on your``virtualbox settings -> network -> advance -> add rules``

## Install cockpit[.](https://www.youtube.com/watch?v=xw_fZKFqLpY)

Cockpit is a web-based graphical interface for servers, intended for everyone, especially those who are:
The service on your server, point your web browser to: ``http://<your_virtual_host>:9090``

Install Cockpit on other variants of Fedora use the following commands.

```shell
sudo apt-get install cockpit

#Enable cockpit
sudo systemctl enable --now cockpit.socket

#Open the firewall if necessary:
sudo ufw allow cockpit
sudo ufw allow 9090
```

Don't forget to open the port ``9090`` on your ``virtualbox settings -> network -> advance -> add rules``
