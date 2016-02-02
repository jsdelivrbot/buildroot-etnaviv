################################################################################
#
# mesa3d_etnaviv
#
################################################################################

# When updating the version, please also update mesa3d_etnaviv-headers
MESA3D_ETNAVIV_VERSION = 60ec206aabad7b0b83e314e6666ae9893dd97d23
MESA3D_ETNAVIV_SITE = https://github.com/austriancoder/mesa-1.git
MESA3D_ETNAVIV_SITE_METHOD = git
MESA3D_ETNAVIV_LICENSE = MIT, SGI, Khronos
MESA3D_ETNAVIV_LICENSE_FILES = docs/license.html
MESA3D_ETNAVIV_AUTORECONF = YES

MESA3D_ETNAVIV_INSTALL_STAGING = YES

MESA3D_ETNAVIV_PROVIDES =

MESA3D_ETNAVIV_DEPENDENCIES = \
	expat \
	host-python-mako \
	libdrm_etnaviv

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MESA3D_ETNAVIV_DEPENDENCIES += openssl
MESA3D_ETNAVIV_CONF_OPTS += --with-sha1=libcrypto
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
MESA3D_ETNAVIV_DEPENDENCIES += libgcrypt
MESA3D_ETNAVIV_CONF_OPTS += --with-sha1=libgcrypt
endif

ifeq ($(BR2_PACKAGE_HAS_LIBUDEV),y)
MESA3D_ETNAVIV_DEPENDENCIES += udev
MESA3D_ETNAVIV_CONF_OPTS += --disable-sysfs
else
MESA3D_ETNAVIV_CONF_OPTS += --enable-sysfs
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
MESA3D_ETNAVIV_DEPENDENCIES += \
	xproto_xf86driproto \
	xproto_dri2proto \
	xproto_glproto \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXdamage \
	xlib_libXfixes \
	libxcb
MESA3D_ETNAVIV_CONF_OPTS += --enable-glx --disable-mangling
# quote from MESA3D_ETNAVIV configure "Building xa requires at least one non swrast gallium driver."
ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_NEEDS_XA),y)
MESA3D_ETNAVIV_CONF_OPTS += --enable-xa
else
MESA3D_ETNAVIV_CONF_OPTS += --disable-xa
endif
else
MESA3D_ETNAVIV_CONF_OPTS += \
	--disable-glx \
	--disable-xa
endif

# Drivers

#Gallium Drivers
MESA3D_ETNAVIV_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_NOUVEAU)  += nouveau
MESA3D_ETNAVIV_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_R600)     += r600
MESA3D_ETNAVIV_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_SVGA)     += svga
MESA3D_ETNAVIV_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_SWRAST)   += swrast
MESA3D_ETNAVIV_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_VIRGL)    += virgl
MESA3D_ETNAVIV_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_ETNAVIV)  += etnaviv
# DRI Drivers
MESA3D_ETNAVIV_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER_SWRAST) += swrast
MESA3D_ETNAVIV_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER_I915)   += i915
MESA3D_ETNAVIV_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER_I965)   += i965
MESA3D_ETNAVIV_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER_NOUVEAU) += nouveau
MESA3D_ETNAVIV_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER_RADEON) += radeon
MESA3D_ETNAVIV_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER_ETNAVIV) += etnaviv

ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER),)
MESA3D_ETNAVIV_CONF_OPTS += \
	--without-gallium-drivers
else
MESA3D_ETNAVIV_CONF_OPTS += \
	--enable-shared-glapi \
	--with-gallium-drivers=$(subst $(space),$(comma),$(MESA3D_ETNAVIV_GALLIUM_DRIVERS-y))
endif

define MESA3D_ETNAVIV_REMOVE_OPENGL_PC
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/dri.pc
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/gl.pc
	rm -rf $(STAGING_DIR)/usr/include/GL/
endef

ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER),)
MESA3D_ETNAVIV_CONF_OPTS += \
	--without-dri-drivers --disable-dri3
MESA3D_ETNAVIV_POST_INSTALL_STAGING_HOOKS += MESA3D_ETNAVIV_REMOVE_OPENGL_PC
else
ifeq ($(BR2_PACKAGE_XPROTO_DRI3PROTO),y)
MESA3D_ETNAVIV_DEPENDENCIES += xlib_libxshmfence xproto_dri3proto xproto_presentproto
MESA3D_ETNAVIV_CONF_OPTS += --enable-dri3
else
MESA3D_ETNAVIV_CONF_OPTS += --disable-dri3
endif
ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
MESA3D_ETNAVIV_DEPENDENCIES += xlib_libXxf86vm
endif
MESA3D_ETNAVIV_PROVIDES += libgl
MESA3D_ETNAVIV_CONF_OPTS += \
	--enable-shared-glapi \
	--enable-driglx-direct \
	--with-dri-drivers=$(subst $(space),$(comma),$(MESA3D_ETNAVIV_DRI_DRIVERS-y))
endif

# APIs

ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_OSMESA),y)
MESA3D_ETNAVIV_CONF_OPTS += --enable-osmesa
else
MESA3D_ETNAVIV_CONF_OPTS += --disable-osmesa
endif

# Always enable OpenGL:
#   - it is needed for GLES (MESA3D_ETNAVIV's ./configure is a bit weird)
#   - but if no DRI driver is enabled, then libgl is not built,
#     remove dri.pc and gl.pc in this case (MESA3D_ETNAVIV_REMOVE_OPENGL_PC)
MESA3D_ETNAVIV_CONF_OPTS += --enable-opengl --enable-dri

# libva and mesa3d_etnaviv have a circular dependency
# we do not need libva support in MESA3D_ETNAVIV, therefore disable this option
MESA3D_ETNAVIV_CONF_OPTS += --disable-va

ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_OPENGL_EGL),y)
MESA3D_ETNAVIV_PROVIDES += libegl
ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_DRI_DRIVER),y)
MESA3D_ETNAVIV_EGL_PLATFORMS = drm
else ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_GALLIUM_DRIVER_VIRGL),y)
MESA3D_ETNAVIV_EGL_PLATFORMS = drm
endif
ifeq ($(BR2_PACKAGE_WAYLAND),y)
MESA3D_ETNAVIV_DEPENDENCIES += wayland
MESA3D_ETNAVIV_EGL_PLATFORMS += wayland
endif
ifeq ($(BR2_PACKAGE_XORG7),y)
MESA3D_ETNAVIV_EGL_PLATFORMS += x11
endif
MESA3D_ETNAVIV_CONF_OPTS += \
	--enable-gbm \
	--enable-egl \
	--with-egl-platforms=$(subst $(space),$(comma),$(MESA3D_ETNAVIV_EGL_PLATFORMS))
else
MESA3D_ETNAVIV_CONF_OPTS += \
	--disable-egl
endif

ifeq ($(BR2_PACKAGE_MESA3D_ETNAVIV_OPENGL_ES),y)
MESA3D_ETNAVIV_PROVIDES += libgles
MESA3D_ETNAVIV_CONF_OPTS += --enable-gles1 --enable-gles2
else
MESA3D_ETNAVIV_CONF_OPTS += --disable-gles1 --disable-gles2
endif

# Avoid automatic search of llvm-config
MESA3D_ETNAVIV_CONF_OPTS += --with-llvm-prefix=$(STAGING_DIR)/usr/bin

$(eval $(autotools-package))
