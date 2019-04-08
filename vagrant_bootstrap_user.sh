#!/bin/bash -x

# This bootstrap modeled after user-config.sh described in at https://coderwall.com/p/uzkokw/configure-the-vagrant-login-user-during-provisioning-using-the-shell-provider

# echo "bootstrap user:"
# echo `pwd`
# echo `whoami`
# echo $HOME

# export HOME=/home/vagrant
cd $HOME

echo "Cloning percona-toolkit into ${HOME}/perldev"
mkdir ${HOME}/perldev
# git clone https://github.com/davidkellis/percona-toolkit.git ${HOME}/perldev/percona-toolkit
sudo ln -s /vagrant ${HOME}/perldev/percona-toolkit

echo "Setup mysql sandbox"
mkdir -p ${HOME}/mysql/percona-server
wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.43-84.3/binary/tarball/Percona-Server-5.6.43-rel84.3-Linux.x86_64.ssl100.tar.gz
tar xvzf Percona-Server-5.6.43-rel84.3-Linux.x86_64.ssl100.tar.gz --strip 1 -C ${HOME}/mysql/percona-server

export PERCONA_TOOLKIT_BRANCH=${HOME}/perldev/percona-toolkit
export PERL5LIB=${HOME}/perldev/percona-toolkit/lib
export PERCONA_TOOLKIT_SANDBOX=${HOME}/mysql/percona-server

echo "Start mysql sandbox"
cd ${HOME}/perldev/percona-toolkit
sandbox/test-env start

# run tests
echo "Running tests"
prove -v t/pt-online-schema-change/

echo "Stop mysql sandbox"
sandbox/test-env stop
