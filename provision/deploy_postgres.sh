#!/bin/bash

apt-get install -q=2 postgresql postgresql-client postgresql-contrib libpq-dev

sudo -u postgres createuser --superuser vagrant
