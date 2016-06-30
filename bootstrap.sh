#!/bin/sh

# Provision a fresh Vagrant instance to be able to develop pytest-dbfixtures or run its tests. This script runs as the
# vagrant user.

# Stop on error. Log invoked commands.
set -ex

# MongoDB needs several gigabytes of free space in /tmp, while vagrant-lxc mounts only 2G. See
# <https://github.com/fgrehm/vagrant-lxc/issues/406> for details.
sudo mount -o remount,size=5G /tmp

# We need CA certificates to download keys over HTTPS.
sudo apt-get update
sudo apt-get install -y ca-certificates

# Add keys and repos for third-party packages.
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" \
    | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.7.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" \
    | sudo tee -a /etc/apt/sources.list.d/pgdg.list

# Set MySQL root password so its installation won't block.
sudo debconf-set-selections <<EOF
mysql-server mysql-server/root_password password 123
mysql-server mysql-server/root_password_again password 123
EOF

sudo apt-get update
sudo apt-get install -y \
     build-essential \
     elasticsearch \
     libmysqlclient-dev \
     libpq-dev \
     mongodb-server \
     mysql-server \
     openjdk-7-jre-headless \
     postgresql-9.1 \
     postgresql-9.2 \
     postgresql-9.3 \
     postgresql-9.4 \
     python2.7-dev \
     rabbitmq-server \
     redis-server \
     virtualenv

# Install DynamoDB Local into the default path searched by pytest-dbfixtures.
mkdir /tmp/dynamodb
wget -qO - http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest \
    | tar xz --directory /tmp/dynamodb

# Stop PostgreSQL: they will use the port that postgresql_proc uses by default.
sudo service postgresql stop
sudo update-rc.d postgresql disable

# Make a virtualenv, install Python dependencies.
virtualenv /home/vagrant/venv
. /home/vagrant/venv/bin/activate
cd /vagrant
python setup.py develop
pip install pytest_dbfixtures[mongodb,redis,rabbitmq,mysql,postgresql,elasticsearch,dynamodb,tests]
pip install -r requirements-test.txt

# Delete compiled modules, otherwise imports will fail if these were compiled outside Vagrant, having different paths.
find . -name '*.py[co]' -delete
