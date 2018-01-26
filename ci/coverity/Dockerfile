#
# Pristine docker build environment for Coverity Scan of glibc
#
# Build Arguments (--build-arg "arg=value")
#
# COVERITY_SCAN_TOKEN - the Coverity Scan token (should be secure)
#
# To install Docker on Ubuntu:
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
#
# To allow mere mortals to use docker:
# https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo
#

FROM buildpack-deps:artful-scm
MAINTAINER James E. King III <jking@apache.org>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \ 
    apt-get dist-upgrade -y 

#
# Install some essentials
#

RUN apt-get install -y --no-install-recommends \
      apt \
      apt-transport-https \
      apt-utils \
      bash-completion \
      binutils \
      bison \
      build-essential \
      ca-certificates \
      gawk \
      g++-7 \
      gcc-7 \
      gdb \
      gettext \
      libgd-dev \
      make \
      perl \
      software-properties-common \
      texinfo \
      valgrind \
      vim

#
# Coverity Scan
#

ARG COVERITY_SCAN_TOKEN=$COVERITY_SCAN_TOKEN
RUN wget -q https://scan.coverity.com/download/linux64 --post-data "token=$COVERITY_SCAN_TOKEN&project=GNU+C+Library+-+glibc" -O /usr/local/coverity_tool.tgz && \
    cd /usr/local && tar xzf coverity_tool.tgz && mv /usr/local/cov-* /usr/local/coverity
ENV PATH /usr/local/coverity/bin:$PATH

#
# Clean up - you need to run apt-get update inside the instance to use apt
# This shrinks the image a little
#

RUN rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

#
# Place a copy of the Dockerfile in the container's root
# This is used to detect deltas in the checked-in file
# against what was used to build the docker container.
#

COPY Dockerfile /

#
# /develop is where the glibc sources are mounted in the container
#

ENV DEVELOP_ROOT /develop
RUN mkdir -p $DEVELOP_ROOT
WORKDIR $DEVELOP_ROOT

