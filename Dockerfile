FROM ubuntu:18.04

ENV CV_VERSION 4.5.1

RUN apt-get update &&\
    apt-get install -y cmake g++ wget unzip git pkg-config &&\
    apt-get clean
RUN wget https://github.com/opencv/opencv/archive/refs/tags/$CV_VERSION.zip &&\
    unzip $CV_VERSION.zip &&\
    cd opencv-$CV_VERSION &&\
    mkdir build
RUN wget https://github.com/opencv/opencv_contrib/archive/refs/tags/$CV_VERSION.zip -O opencv_contrib.zip &&\
    unzip opencv_contrib.zip

WORKDIR /opencv-$CV_VERSION/build
RUN cmake -D CMAKE_BUILD_TYPE=Release\
          -D OPENCV_GENERATE_PKGCONFIG=YES\
          -D BUILD_PROTOBUF=OFF\
          -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-$CV_VERSION/modules .. &&\
    make -j8 && make install

WORKDIR /
RUN apt-get autoremove &&\
    rm /$CV_VERSION.zip /opencv_contrib.zip &&\
    rm -rf /var/lib/apt/lists/* ~/.cache/* /usr/local/share/man