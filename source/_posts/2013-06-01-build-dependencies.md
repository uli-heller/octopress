---
layout: post
author: Uli Heller
published: true
title: "Abhängigkeiten für Debian-Paketbau installieren"
date: 2013-06-01 17:30
#updated: 2013-05-12 19:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Packaging
---

Normalerweise spiele ich alle zum Bau eines Debian-Paketes notwendigen
Programme ein mittels `sudo apt-get build-dep {paketname}`. Blöderweise
geht das nicht, wenn das zu bauende Paket nicht aus einem
Repository "geladen" werden soll, so zum Beispiel wenn ich nur die
Quelltexte und die DSC-Datei des Paketes vorliegen habe.

Nachfolgend beschreibe ich am Beispiel von MUFFIN, wie man die Pakete
dennoch ohne allzuviel Tipparbeit installieren kann.

<!-- more -->

## Quelltexte herunterladen

Beispielsweise von <https://github.com/linuxmint/muffin/archive/1.8.2.tar.gz>

## Quelltexte entpacken

* `gzip -cd muffin-1.8.2.tar.gz|tar xf -`
* `cd muffin-1.8.2`

## Abhängigkeiten anzeigen

* `dpkg-buildpackage`

... liefert eine Ausgabe der Art:

```
...
dpkg-checkbuilddeps: Unmet build dependencies: debhelper (>= 8) dh-autoreconf intltool (>= 0.34.90) libgtk-3-dev (>= 3.0.8-1~) libcanberra-gtk3-dev gobject-introspection (>= 0.9.12-5~) libgirepository1.0-dev (>= 0.9.12) libjson-glib-dev (>= 0.13.2-1~) libclutter-1.0-dev (>= 1.7.5) libpango1.0-dev (>= 1.2.0) libgconf2-dev (>= 2.6.1-2) libglib2.0-dev (>= 2.6.0) libstartup-notification0-dev (>= 0.7) libxcomposite-dev (>= 1:0.2) libxfixes-dev libxrender-dev libxdamage-dev libxcursor-dev libxinerama-dev libxext-dev libxrandr-dev gnome-doc-utils (>= 0.8) gnome-pkg-tools (>= 0.10) gsettings-desktop-schemas-dev (>= 3.3.0)
```

## Abhängigkeiten installieren

    dpkg-checkbuilddeps 2>&1 \
    | sed                    \
      -e "s/^.*: //"         \
      -e "s/([^(]*)//g"      \
    |sudo xargs apt-get install -y

## Paket bauen

* `dpkg-buildpackage`

... läuft nun durch!
