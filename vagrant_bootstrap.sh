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

export HOME=/home/vagrant

echo "Cloning percona-toolkit into ${HOME}/perldev"
mkdir ${HOME}/perldev
git clone https://github.com/davidkellis/percona-toolkit.git ${HOME}/perldev/percona-toolkit

echo "Setup mysql sandbox"
mkdir -p ${HOME}/mysql/percona-server
wget http://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.24-72.2/binary/tarball/Percona-Server-5.6.24-rel72.2-Linux.x86_64.ssl100.tar.gz
tar xvzf Percona-Server-5.6.24-rel72.2-Linux.x86_64.ssl100.tar.gz --strip 1 -C ${HOME}/mysql/percona-server

export PERCONA_TOOLKIT_BRANCH=${HOME}/perldev/percona-toolkit
export PERL5LIB=${HOME}/perldev/percona-toolkit/lib
export PERCONA_TOOLKIT_SANDBOX=${HOME}/mysql/percona-server

# echo "Start mysql sandbox"
cd ${HOME}/perldev/percona-toolkit
sandbox/test-env start

# run tests
echo "Running tests"
prove -v t/pt-online-schema-change/

echo "Stop mysql sandbox"
sandbox/test-env stop