#!/bin/bash

/root/ephemeral-hdfs/bin/hdfs dfs -mkdir -p /spark-logs

/root/spark-ec2/copy-dir /root/spark
