FROM python:3.8.10

RUN apt-get update -y
RUN apt install libgl1-mesa-glx -y
RUN apt-get install 'ffmpeg'\
    'libsm6'\
    'libxext6'  -y

# Install pip requirements
RUN apt install cmake qt5-default libboost-all-dev build-essential libzbar-dev libdlib-dev libssl-dev git libavc1394-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavresample-dev libavutil-dev libavresample-dev libswresample-dev libswscale-dev libeigen3-dev opencl-c-headers opencl-clhpp-headers opencl-headers ocl-icd-dev libtesseract-dev libzbar-dev libdmtx-dev libvtk7-qt-dev libopenni2-dev libopenni-dev python3-dev -y
WORKDIR /home/
RUN mkdir /home/libs

WORKDIR /home/libs
RUN git clone https://github.com/opencv/opencv.git --branch 4.5.5 --single-branch
RUN git clone https://github.com/opencv/opencv_contrib.git --branch 4.5.5 --single-branch
RUN pip3 install numpy
RUN mkdir /home/libs/opencv/build
WORKDIR /home/libs/opencv/build
RUN cmake .. -DWITH_QT=ON -DWITH_OPENCL=ON -DWITH_FFMPEG=ON -DWITH_TESSERACT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON -DOPENCV_EXTRA_MODULES_PATH=/home/libs/opencv_contrib/modules -DOPENCV_DNN_OPENCL=ON -DBUILD_TESTS=ON -DBUILD_PYTHON=ON -DBUILD_TESTS=OFF -DBUILD_TESTING=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_opencv_python3=ON
RUN make -j2 install



WORKDIR /home/libs
RUN git clone https://github.com/davisking/dlib.git --branch v19.22 --single-branch
RUN mkdir /home/libs/dlib/build
WORKDIR /home/libs/dlib/build
RUN apt install libflann-dev libblas-dev -y
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
RUN make -j2 install

WORKDIR /home/libs
RUN git clone https://github.com/PointCloudLibrary/pcl.git --branch pcl-1.12.1 --single-branch
RUN mkdir /home/libs/pcl/build
WORKDIR /home/libs/pcl/build
RUN apt install libusb-1.0-0-dev -y
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_VTK=ON -DWITH_QT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON
RUN make -j2 install

WORKDIR /home
RUN rm -rf /home/libs

ENV QT_DEBUG_PLUGINS=1
ENV QT_QPA_PLATFORM=xcb
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/opt/Qt/${QT_VERSION}/gcc_64/plugins
ENV QT_PLUGIN_PATH=/opt/Qt/${QT_VERSION}/gcc_64/plugins
ENV DISPLAY=:1

ENTRYPOINT ["/bin/sh"]

