# BUILDING

This project: **Restinio C Library**
Version: **0.0.2**

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



### Development tooling (optional)

```bash
sudo apt-get update && sudo apt-get install -y valgrind gdb perl autoconf automake libtool
```



### asio

Clone & build:

```bash
git clone --depth 1 --branch asio-1-30-2 --single-branch "https://github.com/chriskohlhoff/asio.git" "asio"
cd "asio"
./autogen.sh
./configure --prefix=/usr/local
make -j"$(nproc)"
sudo make install
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

