################################################################################
#
# libdrm
#
################################################################################

LIBDRM_ETNAVIV_VERSION = dae8d506d3d10a0aedb4129abf0eb64c82f6b4ad
LIBDRM_ETNAVIV_SITE = https://github.com/austriancoder/libdrm.git
LIBDRM_ETNAVIV_SITE_METHOD = git
LIBDRM_ETNAVIV_LICENSE = MIT

LIBDRM_ETNAVIV_AUTORECONF = YES
LIBDRM_ETNAVIV_INSTALL_STAGING = YES

LIBDRM_ETNAVIV_DEPENDENCIES = \
	libpthread-stubs \
	xutil_util-macros \
	host-pkgconf

LIBDRM_ETNAVIV_CONF_OPTS = \
	--disable-cairo-tests \
	--disable-manpages

LIBDRM_ETNAVIV_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_INTEL),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-intel
LIBDRM_ETNAVIV_DEPENDENCIES += libatomic_ops libpciaccess
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-intel
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_RADEON),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-radeon
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-radeon
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_AMDGPU),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-amdgpu
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-amdgpu
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_NOUVEAU),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-nouveau
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-nouveau
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_VMWGFX),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-vmwgfx
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-vmwgfx
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_OMAP),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-omap-experimental-api
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-omap-experimental-api
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_EXYNOS),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-exynos-experimental-api
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-exynos-experimental-api
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_FREEDRENO),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-freedreno
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-freedreno
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_TEGRA),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-tegra-experimental-api
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-tegra-experimental-api
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_ETNAVIV),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-etnaviv-experimental-api
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-etnaviv-experimental-api
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-udev
LIBDRM_ETNAVIV_DEPENDENCIES += udev
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-udev
endif

ifeq ($(BR2_PACKAGE_VALGRIND),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-valgrind
LIBDRM_ETNAVIV_DEPENDENCIES += valgrind
else
LIBDRM_ETNAVIV_CONF_OPTS += --disable-valgrind
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV_INSTALL_TESTS),y)
LIBDRM_ETNAVIV_CONF_OPTS += --enable-install-test-programs
endif

$(eval $(autotools-package))
