#!/bin/sh
set -x
rumprun xen -di -M 128 \
    -n inet,static,10.9.1.201/22 \
    -b images/data.iso,/data \
    -e PHP_FCGI_MAX_REQUESTS=0 \
    -- build/php/sapi/cgi/php-cgi -b 8000
