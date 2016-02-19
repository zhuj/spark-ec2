#!/usr/bin/env bash

export JAVA_HOME="{{java_home}}"

export SPARK_LOCAL_DIRS="{{spark_local_dirs}}"

# Standalone cluster options
export SPARK_MASTER_OPTS="{{spark_master_opts}}"
if [ -n "{{spark_worker_instances}}" ]; then
  export SPARK_WORKER_INSTANCES={{spark_worker_instances}}
fi
export SPARK_WORKER_CORES={{spark_worker_cores}}

# Used for YARN model
export YARN_HOME="/root/ephemeral-hdfs"
export YARN_CONF_DIR="$YARN_HOME/conf"

# Used for YARN model
export HADOOP_HOME="$YARN_HOME"
export HADOOP_CONF_DIR="$YARN_CONF_DIR"

export TACHYON_HOME="/root/tachyon"

export SPARK_MASTER_IP={{active_master}}
export MASTER=`cat /root/spark-ec2/cluster-url`

export SPARK_SUBMIT_LIBRARY_PATH="$SPARK_SUBMIT_LIBRARY_PATH:$HADOOP_HOME/lib/native/"
export SPARK_SUBMIT_CLASSPATH="$SPARK_CLASSPATH:$SPARK_SUBMIT_CLASSPATH:$HADOOP_CONF_DIR"

# look at https://github.com/apache/spark/blob/master/docs/hadoop-provided.md
export SPARK_DIST_CLASSPATH="$($HADOOP_HOME/bin/hadoop classpath):$HADOOP_HOME/share/hadoop/tools/lib/*"
export SPARK_DIST_CLASSPATH="$SPARK_DIST_CLASSPATH:$TACHYON_HOME/clients/client/target/tachyon-client-{{tachyon_version}}.jar"

# Set a high ulimit for large shuffles, only root can do this
if [ $(id -u) == "0" ]; then
    ulimit -n 1000000
fi
