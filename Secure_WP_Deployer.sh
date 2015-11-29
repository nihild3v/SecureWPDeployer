#!/bin/bash
# SecureWPDeployer - Automated Secure Wordpress Deployer
#Jason Soto
#jason_soto [AT] jsitech [DOT] com
#www.jsitech.com
#Twitter = @JsiTech

# Server Hardening With JShielder
# Wordpress Hardening With WPHardening From Daniel Maldonado @elcodigok


# @license          http://www.gnu.org/licenses/gpl.txt  GNU GPL 3.0
# @author           Jason Soto <jason_soto@jsitech.com>
# @link             http://www.jsitech.com


##############################################################################################################

f_banner(){
echo
echo "
 ____          __        __     ____             _
/ ___|  ___  __\ \      / / __ |  _ \  ___ _ __ | | ___  _   _  ___ _ __
\___ \ / _ \/ __\ \ /\ / / '_ \| | | |/ _ \ '_ \| |/ _ \| | | |/ _ \ '__|
 ___) |  __/ (__ \ V  V /| |_) | |_| |  __/ |_) | | (_) | |_| |  __/ |
|____/ \___|\___| \_/\_/ | .__/|____/ \___| .__/|_|\___/ \__, |\___|_|
                         |_|              |_|            |___/

v2.0

By Jason Soto "
echo
echo
}

################################################################################################################

spinner ()
{
    bar=" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;34m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.02
    done
}

####################################################################################################################
#Check if running with root User

if [ "$USER" != "root" ]; then
      echo "Permission Denied"
      echo "Can only be run by root"
      exit
else
      clear
      f_banner
      echo -e "\e[34m########################################################################\e[00m"
      echo ""
      echo -e "     *** Welcome to the Automated Secure Wordpress Deployer***"
      echo -e "     Server Hardening with JShielder <www.jsitech.com/jshielder"
      echo -e " Wordpress Hardening with WPHardening <http://www.caceriadespammers.com.ar>"
      echo ""
      echo -e "\e[34m########################################################################\e[00m"
      echo "  "
      sleep 10
fi

# Checking Distro Version
clear
f_banner
echo ""
sleep 2
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m Checking what Distro you are Running"
echo -e "\e[34m--------------------------------------------------------------------------------------------\e[00m"
echo ""
distro=$(cat /etc/*-release |grep "DISTRIB_CODENAME" | cut -d '=' -f2)
spinner
echo ""
echo -e "\e[34m----------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[93m>\e[00m "

# Selecting JSHielder for the detected Distro
if [ "$distro" = "trusty" ]; then
    apt-get install git
    apt-get install python-git
    git clone https://github.com/Jsitech/JShielder
    cd JShielder/UbuntuServer_14.04LTS/
    chmod +x jshielder.sh
    ./jshielder.sh

elif [ "$distro" = "vivid" ]; then
    apt-get install git
    apt-get install python-git
    git clone https://github.com/Jsitech/JShielder
    cd JShielder/UbuntuServer_15.04/
    chmod +x jshielder.sh
    ./jshielder.sh

# If no Compatible Distro is Detected

else
    clear;
    echo "No compatible Distro Detected... Exiting"
    sleep 5
    exit
fi

#Proceed with Wordpress Installation
#Install Wordpress CMS
    clear
    f_banner
    echo ""
    echo -e "\e[93m[-]\e[00m Name the Directory that will hold the Wordpress installation"
    echo ""
    echo -e "\e[34m--------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[?]\e[00m Please type a name for the Directory : "
    echo -e "\e[34m--------------------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[93m>\e[00m "
    read DIR
    echo ""
    echo ""
    wget http://wordpress.org/latest.tar.gz
    tar xzvf latest.tar.gz
    mkdir /var/www/html/$DIR
    cp -rf wordpress/* /var/www/html/$DIR/


#Create Wordpress Database
clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m Going to Create the Wordpress Database"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " *** MEMORIZE THE INFO YOU WILL TYPE HERE, WILL NEED IT LATER ***"
echo -n " Type Database Name: "; read db_name
echo -n " Type User:  "; read db_user
echo -n " Type Password:  "; read db_pass
cd ..
chmod +x WPDBcreate.sh
./WPDBcreate.sh $db_name $db_user $db_pass
echo ""
echo ""

#Secure Wordpress Installation with WPHardening from @elcodigok
clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m We will now clone the WPHardening Repo tu Secure Wordpress"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
git clone https://github.com/elcodigok/wphardening.git
cd wphardening/
echo ""
sleep 2
echo ""
echo -e "\e[01;32m[-]\e[00m Securing Wordpress Installation"
echo ""
./wphardening.py -d /var/www/html/$DIR -v -c -r -f -t --wp-config --robots --indexes --plugins
mv /var/www/html/$DIR/wp-config-wphardening.php /var/www/html/$DIR/wp-config.php

#Check Distro Base and Set Permissions
clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m Setting Permissions on the Wordpress Directory"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
spinner
ls /usr/bin/dpkg > /dev/null 2>&1
if [ $? -eq 0 ]; then
    chown -R www-data:www-data /var/www/html/$DIR/
    sed -i s/SecRuleEngine\ On/SecRuleEngine\ DetectionOnly/g /etc/modsecurity/modsecurity.conf
else
   rm -f /etc/httpd/conf.d/welcome.conf
   chown -R apache:apache /var/www/html/$DIR/
   sed -i s/SecRuleEngine\ On/SecRuleEngine\ DetectionOnly/g /etc/httpd/conf.d/mod_security.conf
fi

clear
f_banner
echo ""
sleep 2
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m Deployment finished, Will reboot Server"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[?]\e[00m After Restarting you can access your Server Remotely via port 372 for Debian Based or 2020 for Red Hat Based Distros"
echo ""
sleep 10
reboot
