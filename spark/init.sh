#!/bin/bash

pushd /root > /dev/null

if [ -d "spark" ]; then
  echo "Spark seems to be installed. Exiting."
  return 0
fi

if [[ "$SPARK_VERSION" == *\|* ]]; then
  echo "Spark git hashes are not yet supported. Please specify a Spark release version."
  return 1
elif [[ "$SPARK_VERSION" != 1.6.* ]]; then
  echo "Unsupported Spark version: $SPARK_VERSION"
  return 1
else

  # TODO: http://s3.amazonaws.com/spark-related-packages/spark-$SPARK_VERSION-bin-without-hadoop.tgz
  # TODO: http://s3.amazonaws.com/spark-related-packages/spark-$SPARK_VERSION-bin-hadoop2.6.tgz

  wget http://s3.amazonaws.com/spark-related-packages/spark-$SPARK_VERSION-bin-without-hadoop.tgz

  if [ $? != 0 ]; then
    echo "ERROR: Unknown Spark version: $SPARK_VERSION"
    return 1
  fi

  echo "Unpacking Spark"
  tar xvzf spark-*.tgz > /tmp/spark-ec2_spark.log
  rm spark-*.tgz
  mv `ls -d spark-* | grep -v ec2` spark
fi

popd > /dev/null
