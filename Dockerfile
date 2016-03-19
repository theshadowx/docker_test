 FROM ubuntu 
 MAINTAINER Ali Diouri <alidiouri@gmail.com>
 
 RUN sudo apt-get update                                       &&  \
     DEBIAN_FRONTEND=noninteractive sudo apt-get -y upgrade    &&  \
     DEBIAN_FRONTEND=noninteractive sudo apt-get install -y        \
        nano                                                       \
        git                                                        \
        perl                                                       \
        python                                                     \
        python2.7                                                  \
        g++                                                        \
        make                                                       \
        build-essential                                            \
        openssl                                                    \
        "^libxcb.*"                                                \
        libx11-xcb-dev                                             \
        libglu1-mesa-dev                                           \
        libxrender-dev                                             \
        libxi-dev                                                  \
        flex                                                       \
        bison                                                      \
        gperf                                                      \
        libicu-dev                                                 \
        libxslt-dev                                                \
        ruby                                                       \
        libssl-dev                                                 \
        libxcursor-dev                                             \
        libxcomposite-dev                                          \
        libxdamage-dev                                             \
        libxrandr-dev                                              \
        libfontconfig1-dev                                         \
        libcap-dev                                                 \
        libbz2-dev                                                 \
        libgcrypt11-dev                                            \
        libpci-dev                                                 \
        libnss3-dev                                                \
        libxcursor-dev                                             \
        libxcomposite-dev                                          \
        libxdamage-dev                                             \
        libxrandr-dev                                              \
        libdrm-dev                                                 \
        libfontconfig1-dev                                         \
        libxtst-dev                                                \
        libasound2-dev                                             \
        libcups2-dev                                               \
        libpulse-dev                                               \
        libudev-dev                                                \
        libssl-dev                                                 \
        libxss-dev                                                 \
        libatkmm-1.6-dev                                           \
        libasound2-dev                                             \
        libgstreamer0.10-dev                                       \
        libgstreamer-plugins-base0.10-dev                        &&\
    apt-get build-dep -y qt5-default


WORKDIR /opt
RUN git clone git://code.qt.io/qt/qt5.git qt_src
WORKDIR qt_src
RUN git checkout 5.6
RUN git submodule update --init  
RUN ./configure -developer-build -opensource -confirm-license -opensource -nomake examples -nomake tests -prefix /opt/qt5
RUN make -j6
RUN make install
WORKDIR /opt
RUN printf 'y' | rm -rf  qt_src
