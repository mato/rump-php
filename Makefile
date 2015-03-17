all: nginx php images

.PHONY: nginx
nginx: nginx/objs/nginx

nginx/objs/nginx: nginx/Makefile
	$(MAKE) -C nginx CC=rumprun-xen-cc

NGINX_CONF_ENV += \
	ngx_force_c_compiler=yes \
	ngx_force_c99_have_variadic_macros=yes \
	ngx_force_gcc_have_variadic_macros=yes \
	ngx_force_gcc_have_atomic=yes \
	ngx_force_have_libatomic=no \
	ngx_force_sys_nerr=100 \
	ngx_force_have_map_anon=yes \
	ngx_force_have_map_devzero=no \
	ngx_force_have_timer_event=yes \
	ngx_force_have_posix_sem=yes

NGINX_CONF_OPTS += \
	--crossbuild=NetBSD \
	--with-cc=rumprun-xen-cc \
	--prefix=/none \
	--conf-path=/data/conf/nginx.conf \
	--sbin-path=/none \
	--pid-path=/tmp/nginx.pid \
	--lock-path=/tmp/nginx.lock \
	--error-log-path=/tmp/error.log \
	--http-log-path=/tmp/access.log \
	--http-client-body-temp-path=/tmp/client-body \
	--http-proxy-temp-path=/tmp/proxy \
	--http-fastcgi-temp-path=/tmp/fastcgi \
	--http-scgi-temp-path=/tmp/scgi \
	--http-uwsgi-temp-path=/tmp/uwsgi \
	--without-http_rewrite_module

nginx/Makefile: nginx/src
	(cd nginx; $(NGINX_CONF_ENV) ./configure $(NGINX_CONF_OPTS))

nginx/src:
	git submodule init
	git submodule update

.PHONY: php
php: build/php/sapi/cgi/php-cgi

build/php/sapi/cgi/php-cgi: build/php_configure_stamp
	$(MAKE) -C build/php CC=rumprun-xen-cc sapi/cgi/php-cgi

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
	$(MAKE) -C nginx clean
	rm -f images/stubetc.iso images/data.iso
