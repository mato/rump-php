#!/bin/sh
set -x
rumprun xen -di -M 128 \
    -n inet,static,10.0.120.201/24 \
    -b images/data.iso,/data \
    -e PHP_FCGI_MAX_REQUESTS=0 \
    -- bin/php-cgi -b 8000
