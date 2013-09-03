---
layout: post
author: Uli Heller
published: true
title: "LXC: Fehler bei 'apt-get upgrade' - udev"
date: 2013-09-03 08:00
comments: true
categories:
- Linux
- Ubuntu
- LXC
---

In letzter Zeit tritt ein Problem beim Ausführen
von `apt-get upgrade` in meinen LXC-Containern auf:

    $ sudo apt-get upgrade
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following packages will be upgraded:
      apt apt-utils base-files gnupg gpgv libapt-inst1.4 libapt-pkg4.12 libudev0
      lsb-base lsb-release udev
    11 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    Need to get 3752 kB of archives.
    After this operation, 25.6 kB of additional disk space will be used.
    Do you want to continue [Y/n]? 
    ...
    Preparing to replace udev 175-0ubuntu9.3 (using .../udev_175-0ubuntu9.4_amd64.deb) ...
    Adding 'diversion of /sbin/udevadm to /sbin/udevadm.upgrade by fake-udev'
    dpkg: unrecoverable fatal error, aborting:
     failed to fstat previous diversions file: No such file or directory
    E: Sub-process /usr/bin/dpkg returned an error code (2)

Ich denke, das Problem hängt zusammen mit der Aktualisierung des
Paketes "udev".

Zur Korrektur des Problems muß ich mehrfach diese Kommandos ausführen:

```
$ sudo dpkg --configure -a
$ sudo apt-get upgrade
```

Nach zwei bis drei Durchläufen ist das Problem verschwunden.
