#!/bin/bash

# install pssh
sudo yum install -y -q pssh

# install & populate java8
sudo yum install -y -q java-1.8.0-openjdk java-1.8.0-openjdk-devel
sudo yum remove -y java-1.7.0*

echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0" >> /root/.bash_profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bash_profile

# Load the environment variables specific to this AMI
source /root/.bash_profile

if false; then
  # Set hostname based on EC2 private DNS name, so that it is set correctly
  # even if the instance is restarted with a different private DNS name
  PRIVATE_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/local-hostname`
  PUBLIC_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/hostname`
  hostname $PRIVATE_DNS
  echo $PRIVATE_DNS > /etc/hostname
  export HOSTNAME=$PRIVATE_DNS  # Fix the bash built-in hostname variable too
fi

# Start modules
pushd /root/spark-ec2 > /dev/null
source /root/setup-modules.sh
popd > /dev/null