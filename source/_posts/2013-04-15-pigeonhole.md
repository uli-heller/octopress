---
layout: post
author: Uli Heller
published: true
title: "Pigeonhole für für mein Debian-Paket von Dovecot"
date: 2013-04-15 06:00
#updated: 2013-02-16 08:00
comments: true
categories: 
- Linux
- Ubuntu
- Packaging
- Pigdeonhole
- Dovecot
---

Dovecot: Einbinden von Pigeonhole
=================================

Mein Dovecot-Debian-Paket beinhaltet u.a. auch Pigeonhole.
Pigeonhole wird separat zum Herunterladen angeboten, im Debian-Paket
erscheint es aber als Patch unterhalb von debian/patches. Das ist ein
gewisses Problem, weil man das heruntergeladene Paket dann immer erst
in einen Patch umwandeln muß.

Deshalb mein Ziel: Ich würde das Pigeonhole-Paket gerne möglichst
unverändert in's Dovecot-Debian-Paket einbinden!

<!-- more -->

Ausgangspunkt
-------------

Ausgangspunkt ist das bestehende Dovecot-Debian-Paket. Es kann mit
`dpkg-buildpackage` neu erzeugt werden.

Pakete herunterladen
--------------------

* [Dovecot-2.2.0](http://dovecot.org/releases/2.2/dovecot-2.2.0.tar.gz)
* [Pigeonhole für Dovecot-2.2.0](http://hg.rename-it.nl/dovecot-2.2-pigeonhole/archive/tip.tar.bz2)

Dovecot-Debian-Paket anpassen auf neue Version
----------------------------------------------

* `uupdate -u ../dovecot-2.2.0.tar.gz -v 2:2.2.0`
* `cd ../dovecot-2.2.0`

Verweise auf Pigeonhole-Patch entfernen
---------------------------------------

* `cd ./dovecot-2.2.0`
* `rm debian/patches/pigeonhole.patch`
* `sed -i "s/pigeonhole.patch/#pigeonhole.patch/" debian/patches/series`

Verwendung des Pigeonhole-Paketes vorbereiten
---------------------------------------------

* `cp dovecot-2-2-pigeonhole-70f0b7140939.tar.bz2 dovecot_2.2.0.orig-pigeonhole.tar.bz2`
* `cd ./dovecot-2.2.0`
* `mkdir pigeonhole`
* `tar -C pigeonhole --strip-components=1 -jxf ../dovecot_2.2.0.orig-pigeonhole.tar.bz2`

Paket neu erzeugen
------------------

* `cd ./dovecot-2.2.0`
* `dpkg-buildpackage`

Links
-----

* [http://raphaelhertzog.com/2010/09/07/how-to-use-multiple-upstream-tarballs-in-debian-source-packages/](http://raphaelhertzog.com/2010/09/07/how-to-use-multiple-upstream-tarballs-in-debian-source-packages/)
