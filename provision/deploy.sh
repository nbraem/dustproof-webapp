#!/bin/bash

LOCAL_USER=vagrant
RUN_AS_LOCAL_USER="sudo -u $LOCAL_USER -H"
REPO_DIR="/vagrant"

apt-get update
apt-get install -q=2 git build-essential

cd $REPO_DIR/provision
. ./deploy_postgres.sh
. ./deploy_rvm.sh
. ./deploy_ruby.sh
. ./prepare_rails.sh
