# vim: set ts=4 sw=4 sts=0 sta et :
FROM ubuntu:16.04

# Data volume
VOLUME ["/data"]

# Chain apt-get update, apt-get install for dependencies
RUN apt-get update \
    && apt-get install -y \
        openjdk-8-jre-headless \
        build-essential \
        libelf-dev \
        bc \
        wget

WORKDIR /data

RUN mkdir /scripts/

COPY kernelhaven.sh /scripts/kernelhaven.sh
COPY autoupdate-plugins.txt /scripts/autoupdate-plugins.txt
COPY autoupdate-root.txt /scripts/autoupdate-root.txt

CMD ["/bin/sh", "/scripts/kernelhaven.sh"]
