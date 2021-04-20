FROM ubuntu:18.04 AS prepared

ENV CV_VERSION 4.5.1

RUN apt-get update &&\
    apt-get install -y cmake unzip wget

RUN wget https://github.com/opencv/opencv/archive/refs/tags/$CV_VERSION.zip &&\
    unzip $CV_VERSION.zip &&\
    cd opencv-$CV_VERSION &&\
    mkdir build

RUN wget https://github.com/opencv/opencv_contrib/archive/refs/tags/$CV_VERSION.zip -O opencv_contrib.zip &&\
    unzip opencv_contrib.zip

FROM ubuntu:18.04 AS build

ENV CV_VERSION 4.5.1

RUN apt-get update &&\
    apt-get install -y cmake g++ wget unzip git pkg-config &&\
    apt-get clean

COPY --from=prepared /opencv-$CV_VERSION /opencv
COPY --from=prepared /opencv_contrib-$CV_VERSION /opencv_contrib

WORKDIR /opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=Release\
          -D OPENCV_GENERATE_PKGCONFIG=YES\
          -D BUILD_PROTOBUF=OFF\
          -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules ..

RUN make -j8 && make install

WORKDIR /
RUN apt-get autoremove &&\
    rm -rf /var/lib/apt/lists/* ~/.cache/* /usr/local/share/man