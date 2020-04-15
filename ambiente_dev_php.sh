#!/bin/bash

#Instalação do Apache2

sudo apt update
sudo apt upgrade -y

function RunningApache2 () {
	if [ pgrep apache2 ] 
	then
		sudo systemctl enable apache2
		sudo systemctl start apache2
	fi
}

function RunningMariaDB () {
	if [ pgrep mariadb ]
	then
		sudo systemctl enable mariadb
		sudo systemctl start mariadb
	fi
}

function RunningPHP () {
	if [ pgrep php7.3 2 ]
	then
		sudo a2enmod php7.3
		sudo systemctl restart apache2
		sudo echo -e "<h1>Configured PHP environment</h1>\n$(hostname -f)" > /var/www/html/info.php
	fi
}

if [ ! $(dpkg --get-selections | grep apache2 ) 2> /dev/null ]
then 
	sudo apt install -y apache2 apache2-utils
	RunningApache2
else
	echo "Apache2 package is already installed"
fi


if [ ! $(dpkg --get-selections | grep mariadb-server ) 2> /dev/null ]
then
	sudo apt install -y mariadb-server mariadb-client
	echo "MariaDB configuration"
	sudo mysql_secure_installation
	RunningMariaDB
else
	echo "Mariadb package is already installed"
fi

if [ ! $(dpkg --get-selections | grep php) 2> /dev/null ]
then
	sudo apt install -y php php-{mysql,common,cli,json,opcache,readline}
	RunningPHP
else
	echo "php7 package is already installed"
fi
