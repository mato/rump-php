#!/bin/sh
set -x
rumprun xen -di -M 128 \
    -n inet,static,10.9.1.200/22 \
    -b images/data.iso,/data \
    -b images/stubetc.iso,/etc \
    -- nginx/objs/nginx -c /data/conf/nginx.conf
