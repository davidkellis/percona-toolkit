#!/bin/bash -x

# This bootstrap modeled after provision.sh described in at https://coderwall.com/p/uzkokw/configure-the-vagrant-login-user-during-provisioning-using-the-shell-provider

# Installing Percona Server for MySQL from Percona apt repository
# per https://www.percona.com/doc/percona-server/5.6/installation/apt_repo.html#installing-percona-server-from-percona-apt-repository
# echo "Installing Percona Server"
# wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
# echo "dpkg -i"
# sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
# echo "apt-get update"
# sudo apt-get update --assume-yes
# echo "apt-get install"
# export dbpass=""
# echo "percona-server-server-5.6 percona-server-server/root_password password $dbpass" | sudo debconf-set-selections
# echo "percona-server-server-5.6 percona-server-server/root_password_again password $dbpass" | sudo debconf-set-selections
# sudo apt-get install percona-server-server-5.6 --assume-yes

# echo "bootstrap:"
# echo `pwd`
# echo `whoami`
# echo $HOME

# install dependencies
echo "Installing dependencies"
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install libaio1 libaio-dev
sudo apt-get -y install libdbi-perl
sudo apt-get -y install libdbd-mysql-perl

su -c "source /vagrant/vagrant_bootstrap_user.sh" vagrant
