#!/usr/bin/env bash

# mainly taken from: https://rvm.io/integration/vagrant
# note that we do multi-user install

set +x

# get ruby version from ruby directive in Gemfile
RUBY_VERSION=$(grep "^ruby " $REPO_DIR/Gemfile | sed "s/^ruby '\([0-9.]*\)'/\1/")

source /usr/local/rvm/scripts/rvm || source /etc/profile.d/rvm.sh

rvm use --default --install $RUBY_VERSION

gem install bundler

# make rvm shutup about Gemfile
rvm rvmrc warning ignore allGemfiles
rvm cleanup all
