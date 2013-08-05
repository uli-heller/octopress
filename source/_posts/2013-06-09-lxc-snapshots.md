---
layout: post
author: Uli Heller
published: true
title: "LXC: Schnelles Clonen mit BTRFS-Snapshots"
date: 2013-06-09 10:00
updated: 2013-06-10 17:30
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Lxc
---

Seit einiger Zeit verwende ich LXC als Ergänzung zu VirtualBox.
Meine LXC-Installation läuft unter BTRFS, so dass der Einsatz von
`lxc-clone ... -s` zum schnellen und resourcensparenden Clonen
von LXC-Containern eigentlich kein Problem sein sollte. Leider bricht
das aber immer ab mit der Meldung "cannot snapshot a directory":

    $ sudo lxc-clone -o my-lxc-container -n cloned-lxc-container -s
    Tweaking configuration
    Copying rootfs...
    lxc-clone: cannot snapshot a directory
    lxc-clone: aborted

<!-- more -->

## Analyse

Zur Analyse baut man am besten in "lxc-clone" relativ weit oben eine
Zeile mit "set -x" ein. Da sieht man dann dieses:

    $ sudo lxc-clone -o my-lxc-container -n cloned-lxc-container -s
    + set -e
    + . /usr/share/lxc/lxc.functions
    + globalconf=/etc/lxc/lxc.conf
    ...
    + container_running=False
    + sed -i /lxc.rootfs/d /var/lib/lxc/x/config
    + [ -b /var/lib/lxc/my-lxc-container/rootfs ]
    + which btrfs
    + btrfs subvolume list /var/lib/lxc/my-lxc-container/rootfs
    + [ -d /var/lib/lxc/my-lxc-container/delta0 ]
    + [ yes = yes ]
    + basename /usr/bin/lxc-clone
    + echo lxc-clone: cannot snapshot a directory
    lxc-clone: cannot snapshot a directory
    ...

Man erkennt, dass der Fehler wohl in Zusammenhang mit `btrfs subvolume list`
steht. Hier eine manuelle Ausführung des Befehls:

    $ btrfs subvolume list /var/lib/lxc/my-lxc-container/rootfs
    ERROR: '/var/lib/lxc/my-lxc-container/rootfs' is not a subvolume

Vermutlich muß "rootfs" also ein BTRFS-Subvolume sein.

Nicht vergessen: Änderung an "lxc-clone" wieder rückgängig machen!

## Korrekturversuch

Zunächst lege ich ein BTRFS-Subvolume für "rootfs" an und
befülle es mit dem alten Inhalt:

    $ cd /var/lib/lxc
    $ sudo mv lib/my-lxc-container/rootfs lib/my-lxc-container/rootfs.saved
    $ sudo btrfs subvolume create lib/my-lxc-container/rootfs
    Create subvolume 'lib/my-lxc-container/rootfs'
    $ sudo mv lib/my-lxc-container/rootfs.saved/* lib/my-lxc-container/rootfs
    $ sudo rmdir lib/my-lxc-container/rootfs.saved

Nun nochmals den Befehl zum Auflisten des Subvolumes:

    $ btrfs subvolume list /var/lib/lxc/my-lxc-container/rootfs
    ERROR: can't perform the search
    $ sudo btrfs subvolume list /var/lib/lxc/my-lxc-container/rootfs
    ...
    ID 260 top level 5 path lib/my-lxc-container/rootfs

Sieht schonmal deutlich besser aus. Jetzt nochmals `lxc-clone ... -s':

    $ sudo lxc-clone -o my-lxc-container -n cloned-lxc-container -s
    Tweaking configuration
    Copying rootfs...
    Create a snapshot of '/var/lib/lxc/my-lxc-container/rootfs' in '/var/lib/lxc/cloned-lxc-container/rootfs'
    Updating rootfs...
    'cloned-lxc-container' created

Scheint geklappt zu haben! Die Ausführung ist ultra-schnell!

## Korrektur für alle LXC-Container

Nun muß die oben genannte Korrektur noch für alle anderen LXC-Container
durchgeführt werden. Hier ein kurzes Skript, welches dies für mich
erledigt:

{% codeblock lang:sh %}
#!/bin/sh
for rootfs in /var/lib/lxc/*/rootfs; do
  sudo btrfs subvolume list "${rootfs}" >/dev/null 2>&1 || {  
    sudo mv "${rootfs}" "${rootfs}.saved" \
    && sudo btrfs subvolume create "${rootfs}" \
    && sudo mv "${rootfs}.saved"/* "${rootfs}" \
    && sudo rmdir "${rootfs}.saved"
  }
done
{% endcodeblock %}
