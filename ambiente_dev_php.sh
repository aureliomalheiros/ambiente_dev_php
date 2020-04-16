#!/bin/bash

#Instalação do Apache2

sudo apt update
sudo apt upgrade -y

function RunningApache2 () {
	if [ !$(pgrep apache2 | wc -l) -ne 0] 
	then
		sudo systemctl enable apache2
		sudo systemctl start apache2
	fi
}

function RunningMariaDB () {
	if [ ! $(ps aux | grep "mariadb" | wc -l) ]
	then
		sudo systemctl enable mariadb
		sudo systemctl start mariadb
	fi
}

function RunningPHP () {
	if [ ! $(ps aux | grep "php" | wc -l) ]
	then
		sudo a2enmod php7.3
		sudo systemctl restart apache2
		sudo chmod o+w /var/www/html
	fi
}
function GenerateFile (){
	sudo echo -e "<h1>Configured PHP environment</h1>\nHostname:$(hostname -f)\nDate:$(date -R)" > /var/www/html/info.php
	echo "http://localhost/info.php"
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
	GenerateFile
else
	echo "php7 package is already installed"
	GenerateFile
fi
