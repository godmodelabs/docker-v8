FROM phusion/baseimage:latest
MAINTAINER Kevin Read <me@kevin-read.com>

# install dependencies
RUN apt-get update && apt-get -y install git subversion make g++ python curl chrpath libc6-dev-i386 g++-multilib lbzip2 unzip bzip2 xz-utils pkg-config libglib2.0-dev libxml2-dev && apt-get clean

# depot tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/local/depot_tools
ENV PATH $PATH:/usr/local/depot_tools

# NDK 15c
RUN cd /usr/local/bin && curl -O "https://dl.google.com/android/repository/android-ndk-r15c-linux-x86_64.zip" && unzip android-ndk-r15c-linux-x86_64.zip  && rm android-ndk-r15c-linux-x86_64.zip
ENV NDK_HOME /usr/local/bin/android-ndk-r15c

# Fetch v8 and setup gclient
RUN cd /usr/local/src && fetch v8 && \
    cd /usr/local/src/v8 && echo "target_os = ['android']" >> ../.gclient && gclient sync --nohooks && mkdir out.gn

ADD build-v8.sh /usr/local/bin

RUN mkdir -p /output
VOLUME ["/output"]

# compile v8 for all supported architectures
CMD /usr/local/bin/build-v8.sh x86.release x86 x86-4.9 i686-linux-android
CMD /usr/local/bin/build-v8.sh x64.release x64 x86_64-4.9 x86_64-linux-android

