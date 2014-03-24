---
layout: post
author: Uli Heller
published: true
title: "Erstellen von Debian-Paketen"
date: 2013-03-21 07:00
updated: 2014-03-24 11:00
comments: false
---

Ausgangspunkt
-------------

Minimalinstallation von Ubuntu-14.04

Grundinstallation
-----------------

```
$ mkdir build
$ cd build
$ sudo apt-get install dpkg-dev
... {viele pakete werden installiert}
$ apt-get source git
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: You must put some 'source' URIs in your sources.list
```

Anpassen von /etc/apt/sources.list - "deb-src"-Zeilen hinzufügen:

```
deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
```

Danach: `sudo apt-get update` und dann läuft auch `apt-get source git` durch!

```
$ sudo apt-get build-dep git
... {viele pakete werden installiert}
```

debian/changelog
----------------

### Neuen Eintrag erstellen

`debchange --increment`
