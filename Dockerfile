FROM ubuntu:devel

# TODO: Do not hardcode "cosmic"
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ cosmic main restricted" >> /etc/apt/sources.list
RUN apt-get update

# Live on the bleeding edge!
RUN apt-get -y upgrade

# debconf complains without this.
RUN apt-get -y install apt-utils

# Install dependencies needed to build GTK.
RUN apt-get -y build-dep libgtk-3-0

# Install tools we need to build GTK.
RUN apt-get -y install meson

# Is it a bug that these are not part of build-dep libgtk-3-0?
RUN apt-get -y install libgstreamer-plugins-bad1.0-dev libgraphene-1.0-dev libvulkan-dev sassc

# You can comment out these if bash is good for you.
RUN apt-get install -y zsh
RUN zsh

WORKDIR "/media/gtk"
