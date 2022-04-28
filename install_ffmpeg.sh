#!/bin/bash

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y build-essential cmake git unzip pkg-config default-jdk cmake-curses-gui yasm meson git-all \
libjpeg-dev libtiff-dev libpng-dev libavcodec-dev libavformat-dev libswscale-dev \
libgtk2.0-dev libcanberra-gtk* libgtk-3-dev libgstreamer1.0-dev gstreamer1.0-gtk3 \
libgstreamer-plugins-base1.0-dev gstreamer1.0-gl libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
libxvidcore-dev libtbb2 libtbb-dev libdc1394-22-dev \
libv4l-dev v4l-utils libopenblas-dev libatlas-base-dev libblas-dev \
liblapack-dev gfortran libhdf5-dev libprotobuf-dev libgoogle-glog-dev libgflags-dev python3-dev \
protobuf-compiler libngraph0 libngraph0-dev ngraph-gtk ngraph-gtk-addins* \
qtcreator libqt5serialport5-dev qtmultimedia5-dev libeigen3-dev libvtkgdcm-dev \
libopenblas-dev libtbb-dev libxcb-xinerama0 libxkbcommon-dev \
libxkbcommon-x11-dev libxkbcommon-x11-0 libxkbcommon0 libxmp4 libgavl-dev libgmp-dev \
ladspa-sdk libaom-dev libaribb24-dev lv2-dev libsndfile-dev libiec61883-dev libavc1394-dev \
libass-dev libbluray-dev libbs2b-dev libcaca-dev libcodec2-dev dav1d libdrm-dev libfdk-aac-dev \
flite libgme-dev libjack-dev spirv-tools liblensfun-dev libmodplug-dev libmp3lame-dev \
libopencore-amrnb-dev libopencore-amrwb-dev libopenmpt-dev libpulse-dev \
libwebp-dev libzstd-dev librabbitmq-dev libmysofa-dev librist* librsvg* librubberband* \
librtmp-dev libshine-dev libsmbclient-dev libsnappy-dev libsoxr-dev libspeex-dev \
libsrt-openssl-dev libssh-dev libtheora-dev libtlsh-dev libtwolame-dev libvidstab-dev \
libvo-amrwbenc-dev libvpx-dev libxcb* libzimg* libzmq3-dev libzvbi-dev nasm \
libtesseract-dev pocketsphinx libraspberrypi* libopenal-dev libclc-dev opencl-clhpp-headers \
opencl-c-headers opencl-headers libomxil-bellagio-dev swig bison libgcrypt-dev \
libcdio* libbz2-dev libglm-dev doxygen libcjson-dev

sudo apt-get install -y autoconf automake libass-dev libfreetype6-dev libsdl2-dev \
libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev


pip install --upgrade pip
pip install --upgrade ninja cython

sudo rm -rf ffmpeg_deps
sudo rm -rf FFmpeg
sudo rm -rf ffmpeg
mkdir ffmpeg_deps
cd ffmpeg_deps

#Install h.264
git clone https://code.videolan.org/videolan/x264.git
cd x264
./configure \
    --enable-pic \
    --enable-shared \
    --enable-static \
    --disable-asm
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/drobilla/serd.git --recursive
cd serd
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
./waf configure
./waf
sudo ./waf install
cd ..

git clone https://github.com/drobilla/sord.git --recursive
cd sord
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
./waf configure
./waf
sudo ./waf install
cd ..

git clone https://github.com/drobilla/sratom.git --recursive
cd sratom
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
./waf configure
./waf
sudo ./waf install
cd ..

git clone https://gitlab.com/lv2/lilv.git --recursive
cd lilv
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
./waf configure
./waf
sudo ./waf install
cd ..

git clone https://github.com/Netflix/vmaf.git --recursive
cd vmaf/libvmaf
meson build --buildtype release -Denable_float=true
ninja -vC build
ninja -vC build test
sudo ninja -vC build install
cd ..
cd ..

#Install h.265
git clone https://bitbucket.org/multicoreware/x265_git.git
cd x265_git/source
cmake -DCHECKED_BUILD=ON -DCMAKE_BUILD_TYPE=Release \
-DENABLE_HDR10_PLUS=ON -DENABLE_LIBVMAF=ON -DENABLE_PIC=ON \
-DENABLE_PIC=ON -DENABLE_PPA=ON -DENABLE_SVT_HEVC=ON \
-DENABLE_TESTS=ON -DENABLE_VTUNE=ON .
make --jobs=$(nproc --all)
sudo make install
sudo cp x265.pc /usr/lib/aarch64-linux-gnu/pkgconfig/x265.pc
cd ..
cd ..

git clone https://github.com/acoustid/chromaprint.git
cd chromaprint
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOLS=ON .
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/dyne/frei0r.git
cd frei0r
cmake .
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/mumble-voip/celt-0.11.0.git
cd celt-0.11.0
./autogen.sh
./configure 
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://code.videolan.org/videolan/dav1d.git
cd dav1d
meson build --buildtype release -Denable_float=true
ninja -vC build
ninja -vC build test
sudo ninja -vC build install
cd ..

git clone https://github.com/pkuvcl/davs2.git
cd davs2/build/linux
./configure --disable-asm
make --jobs=$(nproc --all)
sudo make install
cd ..
cd ..
cd ..

git clone https://github.com/KhronosGroup/glslang.git --recursive
cd glslang
git clone https://github.com/google/googletest.git External/googletest
cmake -DCMAKE_BUILD_TYPE=Release
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/stoth68000/libklvanc.git
cd libklvanc
./autogen.sh --build
./configure --enable-shared=yes
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/TimothyGu/libilbc.git --recursive
cd libilbc
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
cmake .
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/ultravideo/kvazaar.git --recursive
cd kvazaar
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
./autogen.sh
./configure
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/uclouvain/openjpeg.git
cd openjpeg
cmake -DCMAKE_BUILD_TYPE=Release .
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/xiph/rav1e.git
cd rav1e
mkdir temp
cargo build --release
cargo install cargo-c
cargo cinstall --release --prefix=temp
sudo cp temp/include/rav1e/* /usr/include/
sudo cp temp/lib/* /usr/lib/
sudo cp temp/lib/pkgconfig/* /usr/lib/aarch64-linux-gnu/pkgconfig/
cd ..

git clone https://github.com/AOMediaCodec/SVT-AV1.git
cd SVT-AV1
cmake -DCMAKE_BUILD_TYPE=Release
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/uavs3/uavs3d.git
cd uavs3d
cmake .
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://code.videolan.org/rist/librist.git --recursive
cd librist
mkdir build 
cd build
meson ..
ninja
sudo ninja install
cd ..

git clone https://github.com/Haivision/srt.git --recursive
cd srt
./configure
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/sekrit-twc/zimg.git
cd zimg
./autogen.sh
./configure
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/KhronosGroup/OpenCL-SDK.git --recursive
cd OpenCL-SDK
git submodule update --init --recursive
while [ $? -ne 0 ]
do
	git submodule update --init --recursive
done
cmake .
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/cmusphinx/sphinxbase.git
cd sphinxbase
./autogen.sh
./configure
make --jobs=$(nproc --all)
sudo make install
cd ..


git clone https://github.com/cmusphinx/pocketsphinx.git
cd pocketsphinx
./autogen.sh
./configure
make --jobs=$(nproc --all)
sudo make install
cd ..

git clone https://github.com/lensfun/lensfun.git
cd lensfun
cmake .
make --jobs=$(nproc --all)
sudo make install
cd ..

cd ~
git clone https://github.com/FFmpeg/FFmpeg.git --recursive
cd FFmpeg
./configure \
--enable-gpl \
--enable-version3 \
--disable-static \
--enable-shared \
--enable-gray \
--enable-autodetect \
--enable-ffmpeg \
--enable-ffplay \
--enable-ffprobe \
--enable-avdevice \
--enable-avcodec \
--enable-avformat \
--enable-swresample \
--enable-swscale \
--enable-postproc \
--enable-avfilter \
--enable-pthreads \
--enable-network \
--enable-dct \
--enable-dwt \
--enable-error-resilience \
--enable-lsp \
--enable-mdct \
--enable-rdft \
--enable-fft \
--enable-faan \
--enable-pixelutils \
--enable-alsa \
--enable-bzlib \
--enable-chromaprint \
--enable-frei0r \
--enable-gcrypt \
--enable-gmp \
--enable-ladspa \
--enable-libaom \
--enable-libaribb24 \
--enable-libass \
--enable-libbluray \
--enable-libbs2b \
--enable-libcaca \
--enable-libcelt \
--enable-libcdio \
--enable-libcodec2 \
--enable-libdav1d \
--enable-libdavs2 \
--enable-libdc1394 \
--enable-libfdk-aac \
--enable-libfontconfig \
--enable-libfreetype \
--enable-libfribidi \
--enable-libglslang \
--enable-libgme \
--enable-libiec61883 \
--enable-libilbc \
--enable-libjack \
--enable-libklvanc \
--enable-libkvazaar \
--enable-liblensfun \
--enable-libmodplug \
--enable-libmp3lame \
--enable-libopencore-amrnb \
--enable-libopencore-amrwb \
--enable-libopenjpeg \
--enable-libopenmpt \
--enable-libopus \
--enable-libpulse \
--enable-librabbitmq \
--enable-librav1e \
--enable-librist \
--enable-librsvg \
--enable-librubberband \
--enable-librtmp \
--enable-libshine \
--enable-libsmbclient \
--enable-libsnappy \
--enable-libsoxr \
--enable-libspeex \
--enable-libsrt \
--enable-libssh \
--enable-libsvtav1 \
--disable-libtensorflow \
--disable-libopencv \
--disable-libopenvino \
--enable-libtesseract \
--enable-libtheora \
--disable-libtls \
--enable-libtwolame \
--enable-libuavs3d \
--enable-libv4l2 \
--enable-libvidstab \
--enable-libvo-amrwbenc \
--enable-libvorbis \
--enable-libvpx \
--enable-libwebp \
--enable-libxcb \
--enable-libxcb-shm \
--enable-libxcb-xfixes \
--enable-libxcb-shape \
--enable-libxvid \
--enable-libxml2 \
--enable-libzimg \
--enable-libzmq \
--enable-libzvbi \
--enable-lv2 \
--enable-lzma \
--disable-mediacodec \
--disable-mediafoundation \
--enable-libmysofa \
--enable-openal \
--disable-opencl \
--disable-opengl \
--enable-openssl \
--enable-pocketsphinx \
--enable-sndio \
--disable-schannel \
--enable-sdl2 \
--disable-securetransport \
--disable-vapoursynth \
--disable-vulkan \
--enable-xlib \
--enable-zlib \
--disable-amf \
--disable-audiotoolbox \
--enable-libdrm \
--disable-mmal \
--disable-omx \
--disable-omx-rpi \
--enable-v4l2-m2m \
--enable-nonfree \
--disable-jni \
--enable-libx264 \
--disable-libx265 \
--disable-asm
make --jobs=$(nproc --all)
sudo make install
cd ~
sudo ldconfig