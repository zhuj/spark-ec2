#!/bin/bash

pushd /root > /dev/null

if [ -d "tachyon" ]; then
  echo "Tachyon seems to be installed. Exiting."
  return 0
fi

# Github tag:
if [[ "$TACHYON_VERSION" == *\|* ]]; then
  echo "Tachyon git hashes are not yet supported. Please specify a Tachyon release version."
  return -1
else

  # TODO: hadoop 2.7.1 (2.6 is still ok)
  # CURRENT: https://s3.amazonaws.com/Tachyon/tachyon-0.8.2-hadoop2.6-bin.tar.gz
  wget https://s3.amazonaws.com/Tachyon/tachyon-$TACHYON_VERSION-hadoop2.6-bin.tar.gz
  if [ $? != 0 ]; then
    echo "ERROR: Unknown Tachyon version: $TACHYON_VERSION"
    return -1
  fi

  echo "Unpacking Tachyon"
  tar xvzf tachyon-*.tar.gz > /tmp/spark-ec2_tachyon.log
  rm tachyon-*.tar.gz
  mv `ls -d tachyon-*` tachyon
fi

popd > /dev/null
