FROM scratch

MAINTAINER Marvin W <eterna-urbo@larma.de>

# 2016-12-13 debootstraps of stretch (via official image)
ADD rootfs.tar.xz /
COPY sources.list /etc/apt/sources.list

RUN echo 'Acquire::Check-Valid-Until "0";' > /etc/apt/apt.conf.d/10no-check-valid-until
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

RUN apt-get update
RUN apt-get install -y bsdmainutils
RUN apt-get install -y build-essential
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y lib32ncurses5-dev lib32z1-dev libesd0-dev libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2-utils zlib1g-dev
RUN apt-get install -y bison flex g++-multilib gcc-multilib gperf pngcrush
RUN apt-get install -y bc curl git gnupg lzop sudo procps schedtool xsltproc zip
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/aosp"]

WORKDIR /aosp
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache

COPY docker-entrypoint.sh /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]

