---
layout: post
author: Uli Heller
published: true
title: "Dovecot: Aktualisierung mit Pigeonhole"
date: 2013-04-19 06:00
updated: 2013-07-05 07:00
comments: true
categories: 
- Linux
- Ubuntu
- Packaging
- Pigdeonhole
- Dovecot
---

Dovecot: Aktualisierung des Debian-Paketes mit Pigeonhole
=========================================================

Gestern oder heute wurde die Version 2.2.1 von Dovecot veröffentlicht.
Natürlich habe ich gleich versucht, mein Debian-Paket zu aktualisieren:

* `cd .../dovecot-2.2.0`
* `uupdate -u ../dovecot-2.2.1.tar.gz`
* `cd ../dovecot-2.2.1`
* `dpkg-buildpackage`

Dummerweise klappt das nicht! Pigeonhole scheint zu fehlen, so dass
schon die Anwendung der Quilt-Patches scheitert.

<!-- more -->


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

Ausgangspunkt ist das bestehende Dovecot-Debian-Paket in der Version 2.2.0.
Es kann mit `dpkg-buildpackage` neu erzeugt werden.

Wir wissen, dass es eine neue Version 2.2.1 von Dovecot gibt. Die haben wir
auch schon heruntergeladen. Von Pigeonhole gibt es keine neue Version, also
verwenden wir die alte einfach weiter.

Pigeonhole vorbereiten
----------------------

* `cp dovecot_2.2.0.orig-pigeonhole.tar.bz2  dovecot_2.2.1.orig-pigeonhole.tar.bz2`

Dovecot vorbereiten
-------------------

* `cd .../dovecot-2.2.0`
* `uupdate -u ../dovecot-2.2.1.tar.gz`
* `cd ../dovecot-2.2.1`

Dovecot/Pigeonhole sichten
--------------------------

Prüfen: Gibt es innerhalb des Dovecot-Verzeichnisses nun ein Verzeichnis für
Pigeonhole? -> Nein!

Pigeonhole auspacken und umbenennen
-----------------------------------

* `bzip2 -cd ../dovecot_2.2.1.orig-pigeonhole.tar.bz2|tar xf -`
* `mv dovecot-2-2-pigeonhole-70f0b7140939 pigeonhole`

Dovecot neu erzeugen
--------------------

* `dpkg-buildpackage`

Nun klappt's!
