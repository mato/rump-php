# rump-php

## What is this?

PHP packaging and infrastructure for running as Unikernels atop
the Xen hypervisor, powered by [rumprun](http://repo.rumpkernel.org/rumprun)
and [Rump Kernels](http://rumpkernel.org).

## Trying it out

To play with this, build rumprun for Xen according to the
[instructions](http://wiki.rumpkernel.org/Repo%3A-rumprun) and add the
`app-tools` directory to your `$PATH`. 

You will also need to install:
* `genisoimage`, to build the data images for the domUs.

Then, run:

````
make
````

This will build PHP and data images, leaving the PHP unikernel binary
in `bin/php-cgi`.

## Running a nginx + PHP demo

To run a full demo stack consisting of an nginx unikernel talking over FastCGI
to a PHP unikernel:

You will need a working Xen network set up, and two IP addresses for the demo.
One will be used by the Xen domU running the HTTP server, the other by the domU
running PHP serving FastCGI.

1. Build the nginx unikernel which is now packaged in its own
   [rump-nginx](https://github.com/mato/rump-nginx) repository.
2. Edit `run_nginx.sh` and `run_php.sh`, replacing the IP addresses used as
   appropriate, and adjusting the path to the nginx unikernel if required.
3. Edit `images/data/conf/nginx.conf` replacing the IP address in
   `fastcgi_pass` to match the IP you will use for the PHP domU.
4. As root on your Xen dom0, run `./run_nginx.sh` in one window and
   `./run_php.sh` in another.
5. Browse to `http://<nginx_ip>/`.

Comments, questions, criticism welcome at the Rump Kernel mailing list or IRC:
http://wiki.rumpkernel.org/Info:-Community
