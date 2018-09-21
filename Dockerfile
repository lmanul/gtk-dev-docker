FROM ubuntu:devel

# TODO: Do not hardcode "cosmic"
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ cosmic main restricted" >> /etc/apt/sources.list
RUN apt-get update

# Live on the bleeding edge!
RUN apt-get -y upgrade

# Install packages without asking questions.
ARG DEBIAN_FRONTEND=noninteractive

# debconf complains without apt-utils.
RUN apt-get -y install apt-utils

# Install dependencies needed to build GTK.
RUN apt-get -y build-dep libgtk-3-0

# Install tools we need to build GTK.
RUN apt-get -y install meson

# Is it a bug that these are not part of build-dep libgtk-3-0?
RUN apt-get -y install libgstreamer-plugins-bad1.0-dev libgraphene-1.0-dev libvulkan-dev sassc

# It's easiest to share files with the host and edit files there, but install a 
# minimal text editor.
RUN apt-get -y install nano

# You can comment out these if bash is good for you.
RUN apt-get -y install zsh
RUN zsh

RUN apt-get -y install sudo

# Some apps to test the X11 connection, e.g. xeyes
RUN apt-get -y install x11-apps

RUN mkdir -p /home/dev
RUN mkdir -p /etc/sudoers.d

# Now a few hacky things to share an X11 socket with the host.
# TODO: Use actual user/group ID instead of 1000
# Replace 'zsh' with your favorite shell
RUN export uid=1000 gid=1000 && \
    echo "dev:x:${uid}:${gid}:Developer,,,:/home/dev:/bin/zsh" >> /etc/passwd && \
    echo "dev:x:${uid}:" >> /etc/group && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev && \
    chown ${uid}:${gid} -R /home/dev

USER dev
ENV HOME /home/dev

WORKDIR "/home/dev/gtk"
