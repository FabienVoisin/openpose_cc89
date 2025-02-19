FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
RUN apt update -y 
RUN apt-get install -y git cmake gcc g++  python3-dev python3-numpy libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev protobuf-compiler libatlas-base-dev libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev libatlas-base-dev libopenblas-dev libleveldb-dev libgoogle-glog-dev libgflags-dev libhdf5-dev hdf5-tools libboost-all-dev  lmdb-utils liblmdb-dev libsnappy-dev libsnappy-dev
RUN apt-get install -y python-is-python3
RUN cd /root
COPY opencv opencv
COPY caffe caffe
COPY openpose openpose
COPY opencv_contrib /usr/opencv_contrib
RUN mkdir opencv/build
RUN cd opencv/build && cmake ../ -DWITH_CUDA=ON -DOPENCV_EXTRA_MODULES_PATH=/usr/opencv_contrib/modules/ && make && make install
RUN cd ../../
RUN mkdir caffe/build
RUN cd caffe/build ; cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local/caffe ; make && make install
RUN cd ../../
RUN mkdir openpose/build
RUN cd /openpose/build && cmake ../  -DBUILD_CAFFE=OFF -DCaffe_INCLUDE_DIRS=/usr/local/caffe/include/ -DCaffe_LIBS=/usr/local/caffe/lib/libcaffe.so.1.0.0 -DBUILD_PYTHON=ON && make && make install
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/caffe/lib:${LD_LIBRARY_PATH}
ENV PATH=/usr/local/caffe/bin/:${PATH}
ENV PYTHONPATH=/usr/local/python:${PYTHONPATH}
COPY openpose/models/ models/
COPY openpose/examples/ examples/
RUN rm -rf /caffe /openpose /opencv
