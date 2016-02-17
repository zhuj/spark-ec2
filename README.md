spark-ec2
=========

This project is a fork of [amplab spark-ce2 branch-1.5](https://github.com/amplab/spark-ec2/tree/branch-1.5).
See original description [here](https://github.com/amplab/spark-ec2/blob/branch-1.5/README.md).

This repository contains the set of scripts used to setup a Spark cluster on EC2 by using [Apache Spark on EC2 Script](http://spark.apache.org/docs/latest/ec2-scripts.html).
This fork works only with yarn (which installs hadoop 2.7.1) and spark version 1.6.0.  

### Achtung

Overall status: **testing** (on ec2 - it seems all works fine)

### Goals

* last version of java 8 - **done**
* last version of scala 2.10 - **done**
* hadoop 2.7.1 - **done**  
* spark 1.6.x - **done** 
* tachyon 0.8.2 - **done**

### Plans

* scala 2.11
* spark 1.6.0 (scala-2.11 build)
