# rump-php

## What is this?

A demonstration of a Nginx + FastCGI + PHP stack, running on Unikernels atop
the Xen hypervisor, powered by rumprun-xen
(http://repo.rumpkernel.org/rumprun-xen) and Rump Kernels
(http://rumpkernel.org).

*Full announcement on rumpkernel-users:* http://thread.gmane.org/gmane.comp.rumpkernel.user/709

Many thanks to Samuel Martin (@tSed) for developing patches to improve the
cross-compilation support for Nginx.

## Trying it out

To play with this, build rumprun-xen according to the instructions and add the
`app-tools` directory to the *end* of your `$PATH`.

You will also need to install:
* `genisoimage`, to build the data images for the domUs.

You will need a working Xen network set up, and two IP addresses for the demo.
One will be used by the Xen domU running the HTTP server, the other by the domU
running PHP serving FastCGI.

1. Edit `run_nginx.sh` and `run_php.sh`, replacing the IP addresses used as
   appropriate.
2. Edit `images/data/conf/nginx.conf` replacing the IP address in
   `fastcgi_pass` to match the IP you will use for the PHP domU.
3. Run `rumpapp-xen-make`.
4. As root on your Xen dom0, run `./run_nginx.sh` in one window and
   `./run_php.sh` in another.
5. Browse to http://_hiawatha domU_/.

Comments, questions, criticism welcome at the Rump Kernel mailing list or IRC:
http://wiki.rumpkernel.org/Info:-Community


