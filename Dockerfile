FROM ubuntu:22.04

ENV DEV="make cmake gcc git g++ automake curl wget autoconf build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev ca-certificates gnupg"
ENV FFMPEG_VERSION=7.0.1

RUN apt-get update && \
    apt-get -y install $DEV && \
    apt-get -y install yasm libx264-dev libmp3lame-dev libopus-dev libvpx-dev && \
    apt-get -y install libx265-dev libnuma-dev && \
    apt-get -y install libasound2 libass9 libvdpau1 libva-x11-2 libva-drm2 libxcb-shm0 libxcb-xfixes0 libxcb-shape0 libvorbisenc2 libtheora0 libaribb24-dev && \
    # Build libaribcaption
    git clone https://github.com/xqq/libaribcaption /tmp/libaribcaption && \
    cd /tmp/libaribcaption && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . -j$(nproc) && \
    cmake --install . && \
    # Build ffmpeg
    mkdir /tmp/ffmpeg_sources && \
    cd /tmp/ffmpeg_sources && \
    curl -fsSL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | tar -xj --strip-components=1 && \
    ./configure \
    --prefix=/usr/local \
    --disable-shared \
    --pkg-config-flags=--static \
    --enable-gpl \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-version3 \
    --enable-libaribb24 \
    --enable-nonfree \
    --disable-debug \
    --disable-doc \
    --enable-fontconfig \
    --enable-libaribcaption \
    && \
    make -j$(nproc) && \
    make install

CMD ["ffmpeg"]