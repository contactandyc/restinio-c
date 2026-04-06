# BUILDING

This project: **Restinio C Library**
Version: **0.1.4**

## Local build

```bash
# one-shot build + install
./build.sh install
```

Or run the steps manually:

```bash
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . -j"$(nproc || sysctl -n hw.ncpu || echo 4)"
sudo cmake --install .
```



## Install dependencies (from `deps.libraries`)


### System packages (required)

```bash
sudo apt-get update && sudo apt-get install -y zlib1g-dev
```



### Development tooling (optional)

```bash
sudo apt-get update && sudo apt-get install -y autoconf automake gdb libtool perl python3 python3-pip python3-venv valgrind
```



### asio

Clone & build:

```bash
git clone --depth 1 --branch asio-1-30-2 --single-branch "https://github.com/chriskohlhoff/asio.git" "asio"
cd "asio"
(cd asio && ./autogen.sh)
(cd asio && ./configure --prefix=/usr/local)
(cd asio && make -j"$(nproc)")
(cd asio && sudo make install)
cd ..
rm -rf "asio"
```


### expected-lite

Clone & build:

```bash
git clone --depth 1 --branch v.0.7.3-fork --single-branch "https://github.com/contactandyc/restinio.git" "expected-lite"
cd "expected-lite"
cmake -S expected-lite -B expected-lite/build -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build expected-lite/build -j"$(nproc)"
sudo cmake --install expected-lite/build
cd ..
rm -rf "expected-lite"
```


### fmt

Clone & build:

```bash
git clone --depth 1 --branch v.0.7.3-fork --single-branch "https://github.com/contactandyc/restinio.git" "fmt"
cd "fmt"
cmake -S fmt -B fmt/build -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build fmt/build -j"$(nproc)"
sudo cmake --install fmt/build
cd ..
rm -rf "fmt"
```


### restinio

Clone & build:

```bash
git clone --depth 1 --branch v.0.7.3-fork --single-branch "https://github.com/contactandyc/restinio.git" "restinio"
cd "restinio"
cmake -S dev -B dev/build -DCMAKE_INSTALL_PREFIX=/usr/local -DRESTINIO_SAMPLE=OFF -DRESTINIO_TEST=OFF -DRESTINIO_DEP_FMT=system -DRESTINIO_DEP_EXPECTED_LITE=system
cmake --build dev/build -j"$(nproc)"
sudo cmake --install dev/build
cd ..
rm -rf "restinio"
```


### the-macro-library

Clone & build:

```bash
git clone --depth 1 --single-branch "https://github.com/contactandyc/the-macro-library.git" "the-macro-library"
cd "the-macro-library"
./build.sh clean
./build.sh install
cd ..
rm -rf "the-macro-library"
```


### a-memory-library

Clone & build:

```bash
git clone --depth 1 --single-branch "https://github.com/contactandyc/a-memory-library.git" "a-memory-library"
cd "a-memory-library"
./build.sh clean
./build.sh install
cd ..
rm -rf "a-memory-library"
```


### the-lz4-library

Clone & build:

```bash
git clone --depth 1 --single-branch "https://github.com/contactandyc/the-lz4-library.git" "the-lz4-library"
cd "the-lz4-library"
./build.sh clean
./build.sh install
cd ..
rm -rf "the-lz4-library"
```


### ZLIB

Install via package manager:

```bash
sudo apt-get update && sudo apt-get install -y zlib1g-dev
```


### the-io-library

Clone & build:

```bash
git clone --depth 1 --single-branch "https://github.com/contactandyc/the-io-library.git" "the-io-library"
cd "the-io-library"
./build.sh clean
./build.sh install
cd ..
rm -rf "the-io-library"
```

