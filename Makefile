all: php images

.PHONY: php
php: build/php/sapi/cgi/php-cgi

build/php/sapi/cgi/php-cgi: build/php_configure_stamp
	$(MAKE) -C build/php sapi/cgi/php-cgi

build/php_extract_stamp: deps/php-5.6.5.tar.bz2
	mkdir -p build/php
	tar -C build/php --strip=1 -xjf $<
	touch $@

build/php_patch_stamp: build/php_extract_stamp
	touch $@

build/php_configure_stamp: build/php_patch_stamp
	( cd build/php; rumprun-xen-configure \
	    ./configure --disable-shared --disable-all )
	touch $@

.PHONY: images
images: images/stubetc.iso images/data.iso

images/stubetc.iso: images/stubetc/*
	genisoimage -l -r -o images/stubetc.iso images/stubetc

images/data.iso: images/data/conf/* images/data/www/* images/data/www/static/*
	genisoimage -l -r -o images/data.iso images/data

.PHONY: clean
clean:
	rm -rf build
	rm -f images/stubetc.iso images/data.iso
