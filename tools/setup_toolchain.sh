#!/bin/bash

set -eu

declare -r MINGW_W64_HOME='/var/tmp/mingw-gcc-cross-toolchain'

if [ -d "${MINGW_W64_HOME}" ]; then
	PATH+=":${MINGW_W64_HOME}/bin"
	export MINGW_W64_HOME \
		PATH
	return 0
fi

declare -r MINGW_W64_CROSS_TAG="$(jq --raw-output '.tag_name' <<< "$(curl --retry 10 --retry-delay 3 --silent --url 'https://api.github.com/repos/AmanoTeam/Senna/releases/latest')")"
declare -r MINGW_W64_CROSS_TARBALL='/var/tmp/mingw-gcc-cross.tar.xz'
declare -r MINGW_W64_CROSS_URL="https://github.com/AmanoTeam/mingw-gcc-cross/releases/download/${MINGW_W64_CROSS_TAG}/x86_64-linux-gnu.tar.xz"

curl --retry 10 --retry-delay 3 --silent --location --url "${MINGW_W64_CROSS_URL}" --output "${MINGW_W64_CROSS_TARBALL}"
tar --directory="$(dirname "${MINGW_W64_CROSS_TARBALL}")" --extract --file="${MINGW_W64_CROSS_TARBALL}"

rm "${MINGW_W64_CROSS_TARBALL}"

mv '/var/tmp/mingw-gcc-cross' "${MINGW_W64_HOME}"

PATH+=":${MINGW_W64_HOME}/bin"

export MINGW_W64_HOME \
	PATH
