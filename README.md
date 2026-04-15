# mingw-gcc-cross

A Clang and GCC cross-compiler targeting MinGW on Windows.

### Quick start

First, start by [downloading the precompiled binaries for your platform](#releases). For reference, you can download the prebuilt binaries of the toolchain for Linux x86_64 with:

```
$ wget https://github.com/AmanoTeam/mingw-gcc-cross/releases/download/latest/x86_64-unknown-linux-gnu.tar.xz
$ tar --extract --file=x86_64-unknown-linux-gnu.tar.xz
```

After unpacking the tarball, you will find the cross-compiler as well as wrapper scripts for targeting a specific C runtime inside the `mingw-gcc-cross/bin` directory:

```
$ ls mingw-gcc-cross/bin
...
x86_64-w64-mingw32-ucrt-clang
x86_64-w64-mingw32-ucrt-clang++
x86_64-w64-mingw32-ucrt-g++
x86_64-w64-mingw32-ucrt-gcc
...
```

You can use them as follows:

```
# Compile C programs
x86_64-w64-mingw32-ucrt-gcc main.c -o main
# Compile C++ programs
x86_64-w64-mingw32-ucrt-g++ main.cpp -o main
```

If you prefer, you can use Clang instead of GCC. Just make sure to replace the `gcc`/`g++` suffixes with `clang`/`clang++`.

You can also switch between the MSVCRT and UCRT runtimes by using compilers with the corresponding `*-msvcrt-*` or `*-ucrt-*` suffixes.

## Cross-compilation

### CMake

Inside the `mingw-gcc-cross/build/cmake` directory, there is a custom CMake toolchain file for each supported cross-compilation target:

```bash
$ ls mingw-gcc-cross/build/cmake
x86_64-w64-mingw32-ucrt.cmake
x86_64-w64-mingw32.cmake
...
i686-w64-mingw32-ucrt.cmake
i686-w64-mingw32.cmake
...
```

To use one of them, pass the `CMAKE_TOOLCHAIN_FILE` definition to your CMake command invocation:

```bash
# Setup the environment for cross-compilation
cmake \
  -DCMAKE_TOOLCHAIN_FILE=~/mingw-gcc-cross/build/cmake/x86_64-w64-mingw32-ucrt.cmake \
  -B build \
  -S  ./
# Build the project
cmake --build ./build
```

### GNU Autotools (aka GNU Build System)

Inside the `mingw-gcc-cross/build/autotools` directory, there is a custom bash script for each supported cross-compilation target:

```bash
$ ls mingw-gcc-cross/build/autotools
x86_64-w64-mingw32-ucrt.sh
x86_64-w64-mingw32.sh
...
i686-w64-mingw32-ucrt.sh
i686-w64-mingw32.sh
...
```

They are meant to be `source`d by you whenever you want to cross-compile something:

```bash
# Setup the environment for cross-compilation
source ~/mingw-gcc-cross/build/autotools/x86_64-w64-mingw32-ucrt.sh
# Configure & build the project
./configure --host="${CROSS_COMPILE_TRIPLET}"
make
```

Essentially, these scripts handle the setup of `CC`, `CXX`, `LD`, and other environment variables so you don’t need to configure them manually.

To restore your environment to its original state, run the `deactivate.sh` script from the same directory:

```bash
source ~/mingw-gcc-cross/build/autotools/deactivate.sh
```

## Software availability

For convenience, the toolchain includes an APT-like utility that installs packages from remote repositories into a local directory and makes them available for use during cross-compilation. It is powered by the package collection of the [MSYS2](https://msys2.org) project.

Below is an example of building a CMake project that uses prebuilt dependencies installed through this package manager:

1. Fetch the project sources (using curl as an example):

    ```bash
    git clone https://github.com/curl/curl
    cd curl
    ```

2. Configure the environment for cross-compilation:

    ```bash
    source ~/mingw-gcc-cross/build/autotools/x86_64-w64-mingw32-ucrt.sh
    ```

3. Install the required dependencies:

    ```bash
    ~/mingw-gcc-cross/bin/x86_64-w64-mingw32-ucrt-apt install mingw-w64-ucrt-x86_64-curl
    ```

4. Build curl as usual:

    ```bash
    cmake -S . -B build
    cmake --build build
    ```

## Releases

The current release is based on GCC 15 and supports cross-compiling for the `x86` and `x86_64` targets. The toolchain includes support for the C and C++ frontends.

You can download the prebuilt toolchains from the [releases](https://github.com/AmanoTeam/mingw-gcc-cross/releases) page.
