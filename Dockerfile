FROM ubuntu:22.04

ARG PYTHON_VERSION=3.8
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget bzip2 build-essential openjdk-8-jdk ssh sudo && \
    apt-get clean

# Install Spark and update env variables.
ENV SCALA_VERSION 2.12.15
ENV SPARK_VERSION "3.3.2"
ENV SPARK_BUILD "spark-${SPARK_VERSION}-bin-hadoop3.2"
ENV SPARK_BUILD_URL "https://dist.apache.org/repos/dist/release/spark/spark-${SPARK_VERSION}/${SPARK_BUILD}.tgz"
RUN wget --quiet "$SPARK_BUILD_URL" -O /tmp/spark.tgz && \
    tar -C /opt -xf /tmp/spark.tgz && \
    mv /opt/$SPARK_BUILD /opt/spark && \
    rm /tmp/spark.tgz
ENV SPARK_HOME /opt/spark
ENV PATH $SPARK_HOME/bin:$PATH
ENV PYTHONPATH /opt/spark/python/lib/py4j-0.10.9.2-src.zip:/opt/spark/python/lib/pyspark.zip:$PYTHONPATH
ENV PYSPARK_PYTHON python

# The graphframes dir will be mounted here.
VOLUME /mnt/graphframes
WORKDIR /mnt/graphframes

ENTRYPOINT /bin/bash
