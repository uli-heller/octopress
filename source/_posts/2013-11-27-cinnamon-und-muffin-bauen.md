---
layout: post
title: "Cinnamon-2.0.14 und Muffin-2.0.5 für Ubuntu-12.04 bauen"
date: 2013-11-27 08:00
comments: true
external-url: 
categories: 
- Linux
- Ubuntu
- Precise
- Cinnamon
- Muffin
---

Hier kurz eine Beschreibung, wie ich Cinnamon und Muffin für Ubuntu-12.04
baue:

* Quellen runterladen von GitHub

    * <https://github.com/linuxmint/Cinnamon/tags> ... tar.gz
    * <https://github.com/linuxmint/muffin/tags> ... tar.gz

* Quellen auf das Build-System kopieren

Muffin
------

* Quellen auspacken: `gzip -cd muffin-2.0.5.tar.gz|tar xf -`
* ChangeLog-Eintrag anlegen: `(cd muffin-2.0.5; debchange --increment)`
* Verzeichnis rückbenennen: `mv muffin-2.0.5ubuntu1 muffin-2.0.5`
* ChangeLog-Eintrag editieren: `jmacs muffin-2.0.5/debian/changelog`
* Bau-Vorgang starten:<pre>
  cd muffin-2.0.5
  ./autogen.sh
  dpkg-buildpackage
</pre>

Cinnamon
--------

* Muffin-Pakete installieren:<pre>
  sudo dpkg -i \
      gir1.2-muffin-3.0_2.0.5dp01precise~1_amd64.deb \
      libmuffin-dev_2.0.5dp01precise~1_amd64.deb     \
      libmuffin0_2.0.5dp01precise~1_amd64.deb        \
      muffin-common_2.0.5dp01precise~1_all.deb 
</pre>
* Quellen auspacken: `gzip -cd Cinnamon-2.0.14.tar.gz|tar xf -`
* ChangeLog-Eintrag anlegen: `(cd Cinnamon-2.0.14; debchange --increment)`
* ChangeLog-Eintrag editieren: `jmacs Cuffin-2.0.14/debian/changelog`
* Bau-Vorgang starten:<pre>
  cd Cinnamon-2.0.14
  ./autogen.sh
  dpkg-buildpackage
</pre>
