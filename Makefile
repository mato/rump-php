all: hiawatha php images

.PHONY: hiawatha
hiawatha: build/hiawatha_extract_stamp build/hiawatha_patch_stamp \
    build/hiawatha_cmake_stamp
	$(MAKE) -C build/hiawatha/build

build/hiawatha_extract_stamp: deps/hiawatha-9.11.tar.gz
	mkdir -p build/hiawatha
	tar -C build/hiawatha --strip=1 -xzf $<
	touch $@

build/hiawatha_patch_stamp: hiawatha.patch
	patch -d build/hiawatha -p0 < $<
	touch $@

build/hiawatha_cmake_stamp:
	mkdir -p build/hiawatha/build
	( cd build/hiawatha/build; \
	  cmake -DCMAKE_CROSSCOMPILING=1 \
	        -DCMAKE_C_COMPILER=rumpapp-xen-cc \
		-DCMAKE_SYSTEM_NAME=generic \
		-DENABLE_XSLT=off \
		-DENABLE_SSL=off \
		.. \
	)
	echo "#define HAVE_UNSETENV 1" >> build/hiawatha/build/config.h
	touch $@

.PHONY: php
php: build/php_extract_stamp build/php_patch_stamp build/php_configure_stamp
	$(MAKE) -C build/php

build/php_extract_stamp: deps/php-5.6.4.tar.bz2
	mkdir -p build/php
	tar -C build/php --strip=1 -xjf $<
	touch $@

build/php_patch_stamp:
	touch $@

build/php_configure_stamp:
	( cd build/php; rumpapp-xen-configure \
	    ./configure --disable-shared --disable-all )
	echo "#define HAVE_UTIME 1" >> build/php/main/php_config.h
	touch $@

.PHONY: images
images:
# Both hiawatha and php appear to run happily without an /etc :)
#	genisoimage -l -r -o images/stubetc.iso images/stubetc
	genisoimage -l -r -o images/data.iso images/data

.PHONY: clean
clean:
	rm -rf build
