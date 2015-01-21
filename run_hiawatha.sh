#!/bin/sh
set -x
rumprun xen -di -M 128 \
    -n inet,static,10.9.1.200/22 \
    -b images/data.iso,/data \
    -- build/hiawatha/build/hiawatha -d -c /data/conf
