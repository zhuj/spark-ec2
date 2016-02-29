#!/bin/bash

pushd /root > /dev/null

if [ -d "alluxio" ]; then
  echo "Alluxio seems to be installed. Exiting."
  return 0
fi

if [[ "$SPARK_VERSION" == *\|* ]]; then
  echo "Spark git hashes are not yet supported. Please specify a Spark release version."
  return 1
elif [[ "$SPARK_VERSION" != 1.6.* ]]; then
  echo "Unsupported Spark version: $SPARK_VERSION"
  return 1
else
  if [[ "$ALLUXIO_VERSION" != 1.0.* ]]; then
    echo "Unsupported Alluxio version: $ALLUXIO_VERSION"
    return 1
  fi

  wget -c http://alluxio.org/downloads/files/$ALLUXIO_VERSION/alluxio-$ALLUXIO_VERSION-bin.tar.gz

  if [ $? != 0 ]; then
    echo "ERROR: Unknown Alluxio version: $ALLUXIO_VERSION"
    return 1
  fi

  echo "Unpacking Alluxio"
  tar xvzf alluxio-*.tar.gz > /tmp/spark-ec2_alluxio.log
  rm alluxio-*.tar.gz
  mv `ls -d alluxio-*` alluxio
  ln -s /root/alluxio /root/tachyon
fi

popd > /dev/null
