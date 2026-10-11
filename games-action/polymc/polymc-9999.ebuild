# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-2 optfeature xdg

HOMEPAGE="https://polymc.org/ https://github.com/PolyMC/PolyMC"
DESCRIPTION="A custom, open source Minecraft launcher"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="
		https://github.com/PolyMC/PolyMC
		https://github.com/MultiMC/libnbtplusplus
		https://github.com/stachenov/quazip
	"

	# Include all submodules
	EGIT_SUBMODULES=( '*' )
else
	MY_PN="PolyMC"

	# Let's use the vendored tarball to avoid dealing with the submodules directly
	SRC_URI="
		https://github.com/PolyMC/PolyMC/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"

	# The PolyMC's files are unpacked to ${WORKDIR}/PolyMC-${PV}
	S="${WORKDIR}/${MY_PN}-${PV}"

	KEYWORDS="amd64 arm64"
fi

# Apache-2.0 for MultiMC (PolyMC is forked from it)
# GPL-3 for PolyMC
# LGPL-3 for libnbtplusplus
# LGPL-2.1 with linking exception for Quazip
# See the rest of PolyMC's libraries at https://github.com/PolyMC/PolyMC/tree/develop/libraries
LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 GPL-2+ GPL-3 LGPL-3 LGPL-2.1-with-linking-exception OFL-1.1 MIT"

SLOT="0"

IUSE="debug lto test"

MIN_QT="6.4.0"

QT_DEPS="
	>=dev-qt/qtbase-${MIN_QT}:6[concurrent,gui,network,widgets,xml]
	>=dev-qt/qt5compat-${MIN_QT}:6
"

# Required at both build-time and run-time
COMMON_DEPENDS="
	${QT_DEPS}
	>=dev-libs/quazip-1.5
	sys-libs/zlib
"

BDEPEND="
	app-text/scdoc
	kde-frameworks/extra-cmake-modules
"

DEPEND="
	${COMMON_DEPENDS}
	media-libs/libglvnd
	>=virtual/jdk-1.8.0:*
"

# runtime only needs a jre and opengl drivers
RDEPEND="
	${QT_DEPS}
	sys-libs/zlib
	>=virtual/jre-1.8.0:*
	virtual/opengl
"

src_prepare() {
	cmake_src_prepare
}

src_configure(){
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		# Prepare for LTO in 1.2.0 (?)
		# See https://github.com/PolyMC/PolyMC/pull/333
		CMAKE_BUILD_TYPE=Release
	fi

	local mycmakeargs=(
		-DLauncher_QT_VERSION_MAJOR=6
		-DCMAKE_INSTALL_PREFIX="/usr"

		# Resulting binary is named polymc
		-DLauncher_APP_BINARY_NAME="${PN}"

		-DENABLE_LTO=$(usex lto)
		-DBUILD_TESTING=$(usex test
	)

	cmake_src_configure
}

src_compile(){
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	# https://github.com/PolyMC/PolyMC/issues/227
	optfeature "old Minecraft (<= 1.12.2) support" x11-libs/libXrandr

	optfeature "built-in MangoHud support" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
