#!/bin/bash

# Create history directory
[ -d /mnt/spark-events ] || mkdir /mnt/spark-events

/root/spark-ec2/copy-dir /root/spark
/root/spark-ec2/copy-dir /mnt/spark-events
