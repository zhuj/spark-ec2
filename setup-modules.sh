#!/bin/bash

# usage: echo_time_diff name start_time end_time
echo_time_diff () {
  local format='%Hh %Mm %Ss'

  local diff_secs="$(($3-$2))"
  echo "[timing] $1: " "$(date -u -d@"$diff_secs" +"$format")"
}

# Make sure we have java
if [[ "x$JAVA_HOME" == "x" ]] ; then
    echo "Expected JAVA_HOME to be set in .bash_profile!"
    exit 1
fi

# Check for tty
if [[ `tty` == "not a tty" ]] ; then
    echo "Expecting a tty or pty! (use the ssh -t option)."
    exit 1
fi

# Make sure we are in the spark-ec2 directory
pushd /root/spark-ec2 > /dev/null

# Load the cluster variables set by the deploy script
source ec2-variables.sh

# Start
echo "Setting up Spark on `hostname`..."

# Set up the masters, slaves, etc files based on cluster env variables
echo "$MASTERS" > masters
echo "$SLAVES" > slaves

MASTERS=`cat masters`
NUM_MASTERS=`cat masters | wc -l`
OTHER_MASTERS=`cat masters | sed '1d'`
SLAVES=`cat slaves`
SSH_OPTS="-o StrictHostKeyChecking=no -o ConnectTimeout=5"

echo "Setting executable permissions on scripts..."
find . -regex "^.+.\(sh\|py\)" | xargs chmod a+x

echo "RSYNC'ing /root/spark-ec2 to other cluster nodes..."
rsync_start_time="$(date +'%s')"
for node in $SLAVES $OTHER_MASTERS; do
  echo $node
  rsync -e "ssh $SSH_OPTS" -az /root/spark-ec2 $node:/root &
  scp $SSH_OPTS ~/.ssh/id_rsa $node:.ssh &
  sleep 0.1
done
wait
rsync_end_time="$(date +'%s')"
echo_time_diff "rsync /root/spark-ec2" "$rsync_start_time" "$rsync_end_time"

echo "Running setup-slave on all cluster nodes to mount filesystems, etc..."
setup_slave_start_time="$(date +'%s')"
pssh --inline \
    --host "$MASTERS $SLAVES" \
    --user root \
    --extra-args "-t -t $SSH_OPTS" \
    --timeout 0 \
    "spark-ec2/setup-slave.sh"
setup_slave_end_time="$(date +'%s')"
echo_time_diff "setup-slave" "$setup_slave_start_time" "$setup_slave_end_time"

# Always include 'scala' module if it's not defined as a work around
# for older versions of the scripts.
if [[ ! $MODULES =~ *scala* ]]; then
  MODULES=$(printf "%s\n%s\n" "scala" $MODULES)
fi

# Install / Init module
for module in $MODULES; do
  echo "Initializing $module"
  module_init_start_time="$(date +'%s')"
  if [[ -e $module/init.sh ]]; then
    source ./$module/init.sh
  fi
  module_init_end_time="$(date +'%s')"
  echo_time_diff "$module init" "$module_init_start_time" "$module_init_end_time"
  cd /root/spark-ec2  # guard against init.sh changing the cwd
done

# Deploy templates
# TODO: Move configuring templates to a per-module ?
echo "Creating local config files..."
./deploy_templates.py

# Copy spark conf by default
echo "Deploying Spark config files..."
chmod u+x /root/spark/conf/spark-env.sh
/root/spark-ec2/copy-dir /root/spark/conf

# Setup each module
for module in $MODULES; do
  echo "Setting up $module"
  module_setup_start_time="$(date +'%s')"
  if [[ -e $module/setup.sh ]]; then
    source ./$module/setup.sh
  fi
  sleep 0.1
  module_setup_end_time="$(date +'%s')"
  echo_time_diff "$module setup" "$module_setup_start_time" "$module_setup_end_time"
  cd /root/spark-ec2  # guard against setup.sh changing the cwd
done

# Clean up all modules
for module in $MODULES; do
  echo "Cleaning up $module"
  module_cleanup_start_time="$(date +'%s')"
  if [[ -e $module/cleanup.sh ]]; then
    source ./$module/cleanup.sh
  fi
  sleep 0.1
  module_cleanup_end_time="$(date +'%s')"
  echo_time_diff "$module cleanup" "$module_cleanup_start_time" "$module_cleanup_end_time"
  cd /root/spark-ec2  # guard against setup.sh changing the cwd
done


popd > /dev/null
