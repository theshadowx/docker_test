# FROM debian:wheezy
# MAINTAINER MeteorHacks Pvt Ltd.

# ENV METEORD_DIR /opt/meteord
# COPY scripts $METEORD_DIR

# RUN bash $METEORD_DIR/init.sh

# WORKDIR /root
# RUN meteor create hell
# WORKDIR /root/hell

# EXPOSE 3000
# # CMD ["bash"]
# ENTRYPOINT bash 
# #ENTRYPOINT bash $METEORD_DIR/run_app.sh


FROM ubuntu:14.04.4
MAINTAINER Ali Diouri

RUN apt-get update -y \
    && apt-get install -y \
        curl \
        bzip2 \
        build-essential \
        python \
        git \
        nano \
        libfreetype6 \
        libfreetype6-dev \
        fontconfig

#-------------------------------------------------------------------------------------
# Install Node Js
ENV NODE_VERSION=6.1.0
ENV NODE_ARCH=x64
ENV NODE_DIST=node-v${NODE_VERSION}-linux-${NODE_ARCH}

WORKDIR /tmp 
RUN curl -O -L http://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.gz \
    && tar xvzf ${NODE_DIST}.tar.gz \
    && rm -rf /opt/nodejs \
    && mv ${NODE_DIST} /opt/nodejs \
    && ln -sf /opt/nodejs/bin/node /usr/bin/node \
    && ln -sf /opt/nodejs/bin/npm /usr/bin/npm

#-------------------------------------------------------------------------------------
# Install phantomjs
ENV ARCH=x86_64
ENV PHANTOMJS_VERSION=2.1.1
ENV PHANTOMJS_TAR_FILE=phantomjs-${PHANTOMJS_VERSION}-linux-${ARCH}.tar.bz2

WORKDIR /usr/local/share/
RUN curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-${ARCH}.tar.bz2 \
    && tar xjf $PHANTOMJS_TAR_FILE \
    && ln -s -f /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-${ARCH}/bin/phantomjs /usr/local/share/phantomjs \
    && ln -s -f /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-${ARCH}/bin/phantomjs /usr/local/bin/phantomjs \
    && ln -s -f /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-${ARCH}/bin/phantomjs /usr/bin/phantomjs \
    && rm $PHANTOMJS_TAR_FILE

#-------------------------------------------------------------------------------------

RUN locale-gen en_US.UTF-8 \
    && localedef -i en_GB -f UTF-8 en_US.UTF-8 

# Install Meteor
WORKDIR /tmp
RUN curl https://install.meteor.com/ | sh

WORKDIR /root
RUN meteor create hell
WORKDIR /root/hell
RUN npm install

EXPOSE 3000
CMD meteor
