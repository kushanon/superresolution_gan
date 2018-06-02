FROM nvidia/cuda:8.0-cudnn5-runtime
LABEL maintainer "iazekr@gmail.com"

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev wget unzip eog vim cmake libeigen3-dev libgtk2.0-dev libgtkglext1-dev libqt4-dev freeglut3-dev opencl-headers libtbb-dev libjpeg-dev libpng++-dev libtiff-dev libopenexr-dev libwebp-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip\
  && rm -rf /var/lib/apt/lists/*

RUN pip install numpy==1.11.1\
    chainer==4.0.0a1\
    Pillow
RUN wget https://github.com/opencv/opencv/archive/3.1.0.zip

RUN unzip 3.1.0.zip
WORKDIR /opencv-3.1.0
RUN mkdir build
WORKDIR build

RUN cmake \
-G "Unix Makefiles" \
--build . \
-D BUILD_CUDA_STUBS=OFF \
-D BUILD_DOCS=OFF \
-D BUILD_EXAMPLES=OFF \
-D BUILD_JASPER=OFF \
-D BUILD_JPEG=ON \
-D BUILD_OPENEXR=OFF \
-D BUILD_PACKAGE=ON \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_PNG=ON \
-D BUILD_SHARED_LIBS=ON \
-D BUILD_TBB=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_TIFF=ON \
-D BUILD_WITH_DEBUG_INFO=ON \
-D BUILD_ZLIB=OFF \
-D BUILD_WEBP=OFF \
-D BUILD_opencv_apps=ON \
-D BUILD_opencv_calib3d=ON \
-D BUILD_opencv_core=ON \
-D BUILD_opencv_cudaarithm=ON \
-D BUILD_opencv_cudabgsegm=ON \
-D BUILD_opencv_cudacodec=ON \
-D BUILD_opencv_cudafeatures2d=ON \
-D BUILD_opencv_cudafilters=ON \
-D BUILD_opencv_cudaimgproc=ON \
-D BUILD_opencv_cudalegacy=ON \
-D BUILD_opencv_cudaobjdetect=ON \
-D BUILD_opencv_cudaoptflow=ON \
-D BUILD_opencv_cudastereo=ON \
-D BUILD_opencv_cudawarping=ON \
-D BUILD_opencv_cudev=ON \
-D BUILD_opencv_features2d=ON \
-D BUILD_opencv_flann=ON \
-D BUILD_opencv_hal=OFF \
-D BUILD_opencv_highgui=ON \
-D BUILD_opencv_imgcodecs=ON \
-D BUILD_opencv_imgproc=ON \
-D BUILD_opencv_java=OFF \
-D BUILD_opencv_ml=ON \
-D BUILD_opencv_objdetect=ON \
-D BUILD_opencv_photo=ON \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=ON \
-D BUILD_opencv_shape=ON \
-D BUILD_opencv_stitching=ON \
-D BUILD_opencv_superres=ON \
-D BUILD_opencv_ts=ON \
-D BUILD_opencv_video=ON \
-D BUILD_opencv_videoio=ON \
-D BUILD_opencv_videostab=ON \
-D BUILD_opencv_viz=OFF \
-D BUILD_opencv_world=OFF \
-D CMAKE_BUILD_TYPE=RELEASE \
-D WITH_1394=ON \
-D WITH_CUBLAS=OFF \
-D WITH_CUDA=ON \
-D WITH_CUFFT=OFF \
-D WITH_EIGEN=ON \
-D WITH_FFMPEG=ON \
-D WITH_GDAL=OFF \
-D WITH_GPHOTO2=OFF \
-D WITH_GIGEAPI=ON \
-D WITH_GSTREAMER=ON \
-D WITH_GTK=ON \
-D WITH_INTELPERC=OFF \
-D WITH_IPP=ON \
-D WITH_IPP_A=OFF \
-D WITH_JASPER=ON \
-D WITH_JPEG=ON \
-D WITH_LIBV4L=ON \
-D WITH_OPENCL=ON \
-D WITH_OPENCLAMDBLAS=OFF \
-D WITH_OPENCLAMDFFT=OFF \
-D WITH_OPENCL_SVM=OFF \
-D WITH_OPENEXR=ON \
-D WITH_OPENGL=ON \
-D WITH_OPENMP=OFF \
-D WITH_OPENNI=OFF \
-D WITH_PNG=ON \
-D WITH_PTHREADS_PF=OFF \
-D WITH_PVAPI=ON \
-D WITH_QT=ON \
-D WITH_TBB=ON \
-D WITH_TIFF=ON \
-D WITH_UNICAP=OFF \
-D WITH_V4L=OFF \
-D WITH_VTK=OFF \
-D WITH_WEBP=ON \
-D WITH_XIMEA=OFF \
-D WITH_XINE=OFF \
..
RUN make -j8
RUN make install
COPY superresolution /superresolution
WORKDIR /superresolution
RUN wget https://www.dropbox.com/s/l4s5a6v4licks62/generator_model_3008000.npz

ENV USER_NAME=kusano
RUN adduser $USER_NAME&&\
    gpasswd -a $USER_NAME sudo
RUN passwd -d $USER_NAME
RUN chown $USER_NAME:$USERNAME -R /superresolution
USER $USER_NAME

