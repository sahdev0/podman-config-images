# ---------- Stage 1: Build full-featured static FFmpeg ----------
FROM docker.io/library/alpine:3.19 AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    musl-dev \
    yasm \
    nasm \
    pkgconfig \
    wget \
    tar \
    bash \
    perl \
    x264-dev \
    lame-dev \
    libvpx-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    fontconfig-dev

WORKDIR /build

ARG FFMPEG_VERSION=6.1.1

# Download FFmpeg source
RUN wget https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz \
    && tar xzf ffmpeg-${FFMPEG_VERSION}.tar.gz

WORKDIR /build/ffmpeg-${FFMPEG_VERSION}

# Configure FFmpeg with YouTube-style features
# Note: Do NOT use --enable-libpng or --enable-libjpeg; they are auto-detected
RUN ./configure \
    --enable-gpl \
    --enable-nonfree \
    --enable-static \
    --disable-shared \
    --disable-doc \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-debug \
    \
    # Protocols
    --enable-protocol=file,http,https,tcp,rtmp \
    \
    # Demuxers
    --enable-demuxer=mov,mp4,mkv,avi,flv \
    \
    # Decoders
    --enable-decoder=h264,hevc,mpeg4,aac,mp3 \
    \
    # Encoders
    --enable-encoder=png,mjpeg,mpeg4,libx264,libmp3lame,aac \
    \
    # Muxers
    --enable-muxer=image2,mp4,flv,webm \
    \
    # Parsers
    --enable-parser=h264,hevc \
    \
    # Filters
    --enable-filter=fps,scale,tile,trim,crop,split,overlay,drawtext \
    \
    # Libraries
    --enable-libx264 \
    --enable-avformat \
    --enable-avcodec \
    --enable-avutil \
    --enable-avfilter \
    --enable-swscale \
    --enable-swresample \
    \
    # Misc
    --enable-small \
    --disable-network \
    --pkg-config-flags="--static" \
    --extra-cflags="-static -Os" \
    --extra-ldflags="-static"

# Build FFmpeg
RUN make -j$(nproc) && strip ffmpeg

# ---------- Stage 2: Minimal runtime ----------
FROM scratch

ARG FFMPEG_VERSION=6.1.1

# Copy fully static binary
COPY --from=builder /build/ffmpeg-${FFMPEG_VERSION}/ffmpeg /ffmpeg

ENTRYPOINT ["/ffmpeg"]
