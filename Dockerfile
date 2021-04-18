FROM ubuntu:18.04

RUN apt-get update && apt-get install -y -–no-install-recommends cmake g++ wget unzip git pkg-config && apt-get clean
RUN wget https://github.com/opencv/opencv/archive/refs/tags/4.5.1.zip && unzip 4.5.1.zip && cd opencv-4.5.1 && mkdir build
RUN git clone https://github.com/opencv/opencv_contrib.git 
WORKDIR /opencv-4.5.1/build
RUN echo "raw.githubusercontents.com raw.githubusercontent.com" > /etc/hosts
RUN cmake -D CMAKE_BUILD_TYPE=Release -D OPENCV_GENERATE_PKGCONFIG=YES -D BUILD_PROTOBUF=OFF -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules .. && make -j8 && make install

WORKDIR /
RUN apt-get autoremove && rm -rf /var/lib/apt/lists/* ~/.cache/* /usr/local/share/man