# SecureWPDeployer
================================================
Automated Secure Wordpress Deployer - JShielder + WPHardening

SecureWPDeployer is a Bash Script that will automatically:

* Deploy LAMP and Hardened your linux Server by Running the Deployer JSHielder for the Detected
Distro, See  http://us.jsitech.com/jshielder or http://www.jsitech.com/jshielder
for more info.

* Download and Install Wordpress on Selected Directory

* Hardened the Wordpress Installation using WPHardening, see
https://github.com/elcodigok/wphardening for more info

# How to Run it
===================================================

chmod +x Secure_WP_Deployer.sh

./Secure_WP_Deployer.sh

# Note
===================================================
JShielder will run First. In the Last Step where JShielder rebbot the server, simply answer n
so the script can proceed with the Wordpress Installation

# ChangeLog
===================================================
v2.0 - Distro Selection Automation, JShielder for Server Hardening, Minor Changes

v1.0 - Initial Script, JackTheStripper for Hardening, Distro Selection menu
