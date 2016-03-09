#!/bin/bash

# Load the environment variables specific to this AMI
source /root/.bash_profile

# Start modules
pushd /root/spark-ec2 > /dev/null
source ./setup-modules.sh
popd > /dev/null