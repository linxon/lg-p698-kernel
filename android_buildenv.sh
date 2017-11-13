#!/bin/sh
#####################################################################
#                               CONFIG                              #
#####################################################################

# Current work dir (root of kernel directory)
WORK_DIR="$(pwd)"

# Toolchain "arm-*" (for LG-P698 — arm-2009q3-v67 or arm-2009q3-v68)
TC_DIR="/tmp/linxon-tmp-files/arm-2009q3"

# Modules dir (for linux kernel)
MODULES_DIR="${WORK_DIR}/ready-modules"

# Directory for searching patches...
PATCHES_DIR="${WORK_DIR}/patches"

#####################################################################
#                                BODY                               #
#####################################################################

SYSROOT="${WORK_DIR}/root"
CROSS_COMPILE="${TC_DIR}/bin/arm-none-linux-gnueabi-"
CC="${CROSS_COMPILE}gcc"
CXX="${CROSS_COMPILE}g++"
LD="${CROSS_COMPILE}ld"

CFLAGS="--sysroot=${SYSROOT}" # -Os -ggdb -fPIE
CXXFLAGS="${CFLAGS}"
CPPFLAGS="--sysroot=${SYSROOT}"
LDFLAGS="--sysroot=${SYSROOT}" # -pie

PATH="${PATH}:${TC_DIR}/bin"
INSTALL_PATH="${TC_DIR}/bin"
INSTALL_MOD_PATH="${MODULES_DIR}"

if ! [ -f "${WORK_DIR}/.patch.applied" ] && [ -d "${PATCHES_DIR}" ]; then
	DIFF_LIST=$(ls "${WORK_DIR}"/diff | grep -E "*.diff|*.patch$")
	for f in ${DIFF_LIST} ; do
		echo "Apply patch >>> ${PATCHES_DIR}/${f}"
		patch -p0 < "${WORK_DIR}/diff/${f}" && touch "${WORK_DIR}/.patch.applied" || {
			echo "Error: can't apply patch — ${PATCHES_DIR}/${f}"
			exit 1
		}
	done
fi

export CROSS_COMPILE CC CXX LD CPPFLAGS CFLAGS CXXFLAGS LDFLAGS PATH INSTALL_PATH INSTALL_MOD_PATH
exec "$@"
