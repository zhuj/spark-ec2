#!/bin/bash

pushd /root > /dev/null

if [ -d "scala" ]; then
  echo "Scala seems to be installed. Exiting."
  return 0
fi

# TODO: SCALA_VERSION="2.11.7"
SCALA_VERSION="2.10.6"

echo "Unpacking Scala"
wget -c http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz
tar xvzf scala-*.tgz > /tmp/spark-ec2_scala.log
rm scala-*.tgz
mv `ls -d scala-* | grep -v ec2` scala

popd > /dev/null
