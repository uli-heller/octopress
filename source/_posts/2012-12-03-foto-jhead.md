---
layout: post
author: Uli Heller
published: no
title: "Fotos - Aufnahmezeitpunkt als Dateiname"
date: 2012-12-03 10:00
updated: 2012-12-03 10:00
comments: true
categories: 
- Ubuntu
---

Fotos - Aufnahmezeitpunkt als Dateiname
=======================================

Vorbereitung
------------

```sh
$ sudo apt-get install jhead
```

Umbenennung aller Fotos
-----------------------

```sh
$ cd {bilderverzeichnis}
$ jhead -n"%Y%m%d-%H%M%S" *.jpg
# Benennt die Bilder um nach bspw. "20121006-174624.jpg"
```

Geotagging
----------

```sh
$ sudo apt-get install libimage-exiftool-perl
$ java -jar geotag-0.082.jar
```
