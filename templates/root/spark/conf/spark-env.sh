#!/usr/bin/env bash

export JAVA_HOME="{{java_home}}"

export SPARK_LOCAL_DIRS="{{spark_local_dirs}}"

# Standalone cluster options
export SPARK_MASTER_OPTS="{{spark_master_opts}}"
if [ -n "{{spark_worker_instances}}" ]; then
  export SPARK_WORKER_INSTANCES={{spark_worker_instances}}
fi
export SPARK_WORKER_CORES={{spark_worker_cores}}

export HADOOP_HOME="/root/ephemeral-hdfs"
export SPARK_MASTER_IP={{active_master}}
export MASTER=`cat /root/spark-ec2/cluster-url`

export SPARK_SUBMIT_LIBRARY_PATH="$SPARK_SUBMIT_LIBRARY_PATH:/root/ephemeral-hdfs/lib/native/"
export SPARK_SUBMIT_CLASSPATH="$SPARK_CLASSPATH:$SPARK_SUBMIT_CLASSPATH:/root/ephemeral-hdfs/conf"

# look at https://github.com/apache/spark/blob/master/docs/hadoop-provided.md
export SPARK_DIST_CLASSPATH="$($HADOOP_HOME/bin/hadoop classpath):$HADOOP_HOME/share/hadoop/tools/lib/*"

# Bind Spark's web UIs to this machine's public EC2 hostname otherwise fallback to private IP:
export SPARK_PUBLIC_DNS=`
wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname ||\
wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`

# Used for YARN model
export YARN_CONF_DIR="/root/ephemeral-hdfs/conf"

# Set a high ulimit for large shuffles, only root can do this
if [ $(id -u) == "0" ]
then
    ulimit -n 1000000
fi
