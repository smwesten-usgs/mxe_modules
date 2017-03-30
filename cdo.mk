# This file is part of MXE. See LICENSE.md for licensing information.

# $(SOURCE_DIR) is a directory with package source
# $(BUILD_DIR) is an empty directory intended for build files.
# $(PREFIX) is path to usr/ directory.
# $(TOP_DIR) is path to MXE root directory.
# $(TARGET) is target triplet (e.g., i686-w64-mingw32.static).
# $(BUILD) is build triplet (e.g., x86_64-unknown-linux-gnu).
# $(MXE_CONFIGURE_OPTS) adds standard options to ./configure script.

PKG             := cdo
$(PKG)_WEBSITE  := https://code.zmaw.de/projects/cdo
$(PKG)_DESCR    := Climate Data Operators
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.1rc2
$(PKG)_CHECKSUM := 5cea4d6edc1941cd2570158e20281036297b6ca0ae764598e56495db6b8a8202
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-current.tar.gz
$(PKG)_URL      := https://code.zmaw.de/attachments/download/14165/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 zlib szip

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
				--disable-shared      \
        --disable-grib        \
        --disable-cgribex     \
				--enable-all-static   \
        --with-zlib='$(PREFIX)' \
        --with-szlib='$(PREFIX)' \
        --with-hdf5='$(PREFIX)' \
        --with-netcdf='$(PREFIX)' \
        CPPFLAGS="-D_DLGS_H -DWIN32_LEAN_AND_MEAN -std=gnu++14" \
				CFLAGS="-std=gnu11" \
        LIBS="-lhdf5_hl -lhdf5 -lsz -lz -lws2_32"

    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS=-no-undefined

    $(MAKE) -C '$(1)' -j 1 install
endef
