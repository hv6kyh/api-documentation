#!/bin/bash

set -e

apt-get update

apt-get install -y --assume-yes ruby ruby-dev make zlib1g-dev
# Needed for javascript runtime
apt-get install -y  nodejs
# Needed for gem builds
apt-get install -y build-essential

gem install bundle

# We add a fake HOME so that bundle does not try to install in /
export HOME=/gem
mkdir ${HOME}

bundle install --gemfile $(dirname $0)/Gemfile
rm -rf ${HOME}

# Cleanup
rm -rf /var/lib/apt/lists/* /tmp/* || :
