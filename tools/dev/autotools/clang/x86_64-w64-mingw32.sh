#/bin/bash

kopt="${-}"

set +u
set -e

if [ -z "${MINGW_HOME}" ]; then
	MINGW_HOME="$(realpath "$(( [ -n "${BASH_SOURCE}" ] && dirname "$(realpath "${BASH_SOURCE[0]}")" ) || dirname "$(realpath "${0}")")""/../../../../../..")"
fi

set -u

CROSS_COMPILE_TRIPLET='x86_64-w64-mingw32'
CROSS_COMPILE_SYSTEM='windows'
CROSS_COMPILE_ARCHITECTURE='x86_64'
CROSS_COMPILE_SYSROOT="${MINGW_HOME}/${CROSS_COMPILE_TRIPLET}-msvcrt"

CMAKE_TOOLCHAIN_FILE="${MINGW_HOME}/build/cmake/clang/${CROSS_COMPILE_TRIPLET}.cmake"

CC="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-msvcrt-clang"
CXX="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-msvcrt-clang++"
RC="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-windres"
WINDRES="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-windres"
DLLTOOL="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-dlltool"
AR="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ar"
AS="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-as"
LD="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ld"
NM="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-nm"
RANLIB="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ranlib"
STRIP="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-strip"
OBJCOPY="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-objcopy"
OBJDUMP="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-objdump"
READELF="${MINGW_HOME}/bin/${CROSS_COMPILE_TRIPLET}-readelf"
YASM="${MINGW_HOME}/bin/yasm"

export \
	CROSS_COMPILE_TRIPLET \
	CROSS_COMPILE_SYSTEM \
	CROSS_COMPILE_ARCHITECTURE \
	CROSS_COMPILE_SYSROOT \
	CMAKE_TOOLCHAIN_FILE \
	CC \
	CXX \
	RC \
	WINDRES \
	DLLTOOL \
	AR \
	AS \
	LD \
	NM \
	RANLIB \
	STRIP \
	OBJCOPY \
	OBJDUMP \
	READELF \
	YASM

[[ "${kopt}" = *e*  ]] || set +e
[[ "${kopt}" = *u*  ]] || set +u
