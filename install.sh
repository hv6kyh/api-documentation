#!/bin/bash

set -e

apt-get install -y --assume-yes ruby ruby-dev make zlib1g-dev
# Needed for javascript runtime
apt-get install nodejs

gem install bundle

# We add a fake HOME so that bundle does not try to install in /
export HOME=/gem
mkdir ${HOME}

bundle install --gemfile $(dirname $0)/Gemfile
rm -rf ${HOME}
