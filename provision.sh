#!/usr/bin/env bash

## provisioning to set up a development environment for the ODI Pathway app
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs libgdbm-dev libncurses5-dev automake libtool bison libffi-dev -y

#install ruby
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.4.0
rvm use 2.4.0 --default
ruby -v

# Install bundler
gem install bundler

# install pathway app dependancies
cd /vagrant

bundle install --without production test

#start server
./bin/rails server -b 0.0.0.0 -d

./bin/rake db:migrate

./bin/rake db:seed

./bin/rake questionnaire:import
