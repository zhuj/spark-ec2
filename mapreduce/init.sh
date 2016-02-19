#!/bin/bash

pushd /root > /dev/null

case "$HADOOP_MAJOR_VERSION" in
  yarn)
    echo "Nothing to initialize for MapReduce in Hadoop 2 YARN"
    ;;
  *)
    echo "ERROR: Unknown Hadoop version: $HADOOP_MAJOR_VERSION"
    return 1
esac

/root/spark-ec2/copy-dir /root/mapreduce

popd > /dev/null
