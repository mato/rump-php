# rump-php

## What is this?

A demonstration of a httpd + FastCGI + PHP stack, running on Unikernels atop
the Xen hypervisor, powered by rumprun-xen
(http://repo.rumpkernel.org/rumprun-xen) and Rump Kernels
(http://rumpkernel.org).

## Trying it out

To play with this, build rumprun-xen according to the instructions and add the
`app-tools` directory to the *end* of your `$PATH`. You will also need to
install `genisoimage`.

You will need a working Xen network set up, and two IP addresses for the demo.
One will be used by the Xen domU running the HTTP server, the other by the domU
running PHP serving FastCGI.

1. Edit `run_hiawatha.sh` and `run_php.sh`, replacing the IP addresses used as
   appropriate.
2. Edit `images/data/conf/hiawatha.conf` replacing the IP address in
   `ConnectTo` to match the IP you will use for the PHP domU.
3. Run `rumpapp-xen-make`.
4. As root on your Xen dom0, run `./run_hiawatha.sh` in one window and
   `./run_php.sh` in another.
5. Browse to http://_hiawatha domU_/.

Comments, questions, criticism welcome at the Rump Kernel mailing list or IRC:
http://wiki.rumpkernel.org/Info:-Community


