FROM ubuntu:14.04.4
MAINTAINER Ali Diouri <alidiouri@gmail.com>
 
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android_sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_NDK_ROOT=/opt/android_ndk
ENV ANDROID_NDK_TOOLCHAIN_VERSION=4.9
ENV ANDROID_NDK_HOST=linux-x86_64
ENV ANDROID_NDK_PLATFORM=android-21
ENV QT_PATH=/opt/Qt
ENV QT_ANDROID_ARM=${QT_PATH}/5.6/android_armv7
ENV QMAKESPEC=android-g++
ENV PATH=a${PATH}:${QT_ANDROID_ARM}/bin:${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools


RUN sudo apt-get update                                       &&  \
    sudo apt-get -y upgrade                                   &&  \
    sudo apt-get install -y                                       \
       default-jdk                                                \
       nano                                                       \
       wget                                                       \
       unzip                                                      \
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
RUN wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar zxvf android-sdk_r24.4.1-linux.tgz && mv android-sdk-linux $ANDROID_SDK_ROOT && rm -rf /opt/android-sdk_r24.4.1-linux.tgz
RUN wget http://dl.google.com/android/repository/android-ndk-r11b-linux-x86_64.zip && unzip android-ndk-r11b-linux-x86_64.zip && mv android-ndk-r11b $ANDROID_NDK_ROOT && rm -rf android-ndk-r11b-linux-x86_64.zip
RUN echo "y" | android update sdk -u -a -t tools,platform-tools,build-tools-21.1.2,${ANDROID_NDK_PLATFORM}
RUN wget http://download.qt.io/official_releases/qt/5.6/5.6.0/single/qt-everywhere-opensource-src-5.6.0.tar.gz  \
    && tar zxvf qt-everywhere-opensource-src-5.6.0.tar.gz \
    && mv qt-everywhere-opensource-src-5.6.0 qt_src \
    && rm -rf qt-everywhere-opensource-src-5.6.0.tar.gz \
    && cd /opt/qt_src
WORKDIR /opt/qt_src
RUN  ./configure \
     -opensource -confirm-license \
     -release \
     -xplatform ${QMAKESPEC} \
     -nomake tests -nomake examples \
     -android-ndk ${ANDROID_NDK_ROOT} \
     -android-sdk ${ANDROID_SDK_ROOT} \
     -android-ndk-host ${ANDROID_NDK_HOST} \
     -android-toolchain-version ${ANDROID_NDK_TOOLCHAIN_VERSION} \
     -skip qttranslations -skip qtserialport \
     -no-warnings-are-errors \
     -prefix ${QT_ANDROID_ARM} && \
     make -j6 && make install && \
     echo "y" | rm -rf  /opt/qt_src
WORKDIR /root

