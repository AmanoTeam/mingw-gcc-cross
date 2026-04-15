#!/bin/bash

set -eu

declare -r workdir="${PWD}"

declare -r sysroot_directory="/tmp/${CROSS_COMPILE_TRIPLET}-${CRTDLL}"

declare extra_flags=''

git clone https://git.code.sf.net/p/mingw-w64/mingw-w64

patch --directory='mingw-w64' --strip='1' --input="${workdir}/patches/0001-Remove-versioned-SONAME-from-winpthreads.patch"

mkdir mingw-w64/build
cd mingw-w64/build

if [ "${CROSS_COMPILE_TRIPLET}" = 'x86_64-w64-mingw32' ]; then
	extra_flags+=' --disable-lib32'
fi

../configure \
	--with-default-msvcrt="${CRTDLL}" \
	--with-default-win32-winnt='0x0601' \
	--host="${CROSS_COMPILE_TRIPLET}" \
	--prefix="${sysroot_directory}" \
	--with-sysroot="${sysroot_directory}" \
	${extra_flags}

make install

../mingw-w64-libraries/winpthreads/configure \
	--host="${CROSS_COMPILE_TRIPLET}" \
	--prefix="${sysroot_directory}"

make install

../mingw-w64-libraries/libmangle/configure \
	--host="${CROSS_COMPILE_TRIPLET}" \
	--prefix="${sysroot_directory}"

make install

declare tarball_filename="${sysroot_directory}.tar.xz"

if [ "${CROSS_COMPILE_TRIPLET}" != 'aarch64-w64-mingw32' ]; then
	mv "${sysroot_directory}/bin/lib"*'.dll' "${sysroot_directory}/lib"
fi

tar \
	--directory="$(dirname "${sysroot_directory}")" \
	--create \
	--file=- \
	"$(basename "${sysroot_directory}")" |
		xz \
			--threads='0' \
			--compress \
			-9 > "${tarball_filename}"

sha256sum "${tarball_filename}" | sed 's|/tmp/||' > "${tarball_filename}.sha256"
