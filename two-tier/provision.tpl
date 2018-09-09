#!/bin/bash
set -e
set -o pipefail

apt-get -y update
apt-get -y install nginx
service nginx start
