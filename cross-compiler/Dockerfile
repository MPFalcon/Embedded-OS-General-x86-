FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------
# Install build dependencies
# -----------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    bison \
    flex \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    wget \
    xz-utils \
    nasm \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Cross compiler config
# -----------------------------
ENV TARGET=i386-elf
ENV PREFIX=/opt/cross
ENV PATH=$PREFIX/bin:$PATH

WORKDIR /build

# -----------------------------
# Build binutils
# -----------------------------
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz && \
    tar -xf binutils-2.41.tar.xz && \
    mkdir binutils-build && cd binutils-build && \
    ../binutils-2.41/configure \
        --target=$TARGET \
        --prefix=$PREFIX \
        --with-sysroot \
        --disable-nls \
        --disable-werror && \
    make -j$(nproc) && \
    make install

# -----------------------------
# Build GCC (C only, freestanding)
# -----------------------------
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz && \
    tar -xf gcc-13.2.0.tar.xz && \
    cd gcc-13.2.0 && \
    ./contrib/download_prerequisites

RUN mkdir gcc-build && cd gcc-build && \
    ../gcc-13.2.0/configure \
        --target=$TARGET \
        --prefix=$PREFIX \
        --disable-nls \
        --enable-languages=c \
        --without-headers && \
    make all-gcc -j$(nproc) && \
    make all-target-libgcc -j$(nproc) && \
    make install-gcc && \
    make install-target-libgcc

# -----------------------------
# Copy result to mounted volume
# -----------------------------
CMD ["bash", "-c", "cp -r /opt/cross /out && echo 'Cross compiler exported to ./out/cross'"]
