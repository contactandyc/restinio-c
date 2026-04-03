# syntax=docker/dockerfile:1
ARG UBUNTU_TAG=22.04
FROM ubuntu:${UBUNTU_TAG}

# --- Configurable (can be overridden with --build-arg) ---
ARG CMAKE_VERSION=3.26.4
ARG CMAKE_BASE_URL=https://github.com/Kitware/CMake/releases/download
ARG GITHUB_TOKEN

ENV DEBIAN_FRONTEND=noninteractive

# --- Base system setup --------------------------------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    abigail-tools \
    tar \
    unzip \
    zip \
    pkg-config \
    sudo \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Development tooling (optional)
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    gdb \
    libtool \
    perl \
    valgrind \
 && rm -rf /var/lib/apt/lists/*

# --- Install CMake from official binaries (arch-aware) ------------------------
RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "$ARCH" in \
      x86_64) CMAKE_ARCH=linux-x86_64 ;; \
      aarch64) CMAKE_ARCH=linux-aarch64 ;; \
      *) echo "Unsupported arch: $ARCH" >&2; exit 1 ;; \
    esac; \
    apt-get update && apt-get install -y wget tar && rm -rf /var/lib/apt/lists/*; \
    wget -q "${CMAKE_BASE_URL}/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-${CMAKE_ARCH}.tar.gz" -O /tmp/cmake.tgz; \
    tar --strip-components=1 -xzf /tmp/cmake.tgz -C /usr/local; \
    rm -f /tmp/cmake.tgz

# --- Create a non-root 'dev' user with passwordless sudo ----------------------
RUN useradd --create-home --shell /bin/bash dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /workspace && chown dev:dev /workspace

USER dev
WORKDIR /workspace


# --- Build & install asio ---
RUN set -eux; \
    git clone --depth 1 --branch asio-1-30-2 --single-branch "https://github.com/chriskohlhoff/asio.git" "asio"; \
    cd "asio"; \
    (cd asio && ./autogen.sh) && \
    (cd asio && ./configure --prefix=/usr/local) && \
    (cd asio && make -j"$(nproc)") && \
    (cd asio && sudo make install); \
    cd ..; \
    rm -rf "asio"
# --- Build & install expected-lite ---
RUN set -eux; \
    git clone --depth 1 --branch v.0.7.3-fork --single-branch "https://github.com/contactandyc/restinio.git" "expected-lite"; \
    cd "expected-lite"; \
    cmake -S expected-lite -B expected-lite/build -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build expected-lite/build -j"$(nproc)" && \
    sudo cmake --install expected-lite/build; \
    cd ..; \
    rm -rf "expected-lite"
# --- Build & install fmt ---
RUN set -eux; \
    git clone --depth 1 --branch v.0.7.3-fork --single-branch "https://github.com/contactandyc/restinio.git" "fmt"; \
    cd "fmt"; \
    cmake -S fmt -B fmt/build -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build fmt/build -j"$(nproc)" && \
    sudo cmake --install fmt/build; \
    cd ..; \
    rm -rf "fmt"
# --- Build & install restinio ---
RUN set -eux; \
    git clone --depth 1 --branch v.0.7.3-fork --single-branch "https://github.com/contactandyc/restinio.git" "restinio"; \
    cd "restinio"; \
    cmake -S dev -B dev/build -DCMAKE_INSTALL_PREFIX=/usr/local -DRESTINIO_SAMPLE=OFF -DRESTINIO_TEST=OFF -DRESTINIO_DEP_FMT=system -DRESTINIO_DEP_EXPECTED_LITE=system && \
    cmake --build dev/build -j"$(nproc)" && \
    sudo cmake --install dev/build; \
    cd ..; \
    rm -rf "restinio"

# --- Build & install this project --------------------------------------------
COPY --chown=dev:dev . /workspace/restinio-c
RUN mkdir -p /workspace/build/restinio-c && \
    cd /workspace/build/restinio-c && \
    cmake /workspace/restinio-c && \
    make -j"$(nproc)" && sudo make install

CMD ["/bin/bash"]
