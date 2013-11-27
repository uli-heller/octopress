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

NOCH NICHT FERTIG!
<pre>
dpkg: Abhängigkeitsprobleme verhindern Konfiguration von cinnamon:
 cinnamon hängt ab von cinnamon-translations; aber:
  Paket cinnamon-translations ist nicht installiert.
 cinnamon hängt ab von cinnamon-settings-daemon; aber:
  Paket cinnamon-settings-daemon ist nicht installiert.
 cinnamon hängt ab von cinnamon-session; aber:
  Paket cinnamon-session ist nicht installiert.
 cinnamon hängt ab von python-opencv; aber:
  Paket python-opencv ist nicht installiert.
</pre>
NOCH NICHT FERTIG!

Hier kurz eine Beschreibung, wie ich Cinnamon und Muffin für Ubuntu-12.04
baue:

* Quellen runterladen von GitHub

    * <https://github.com/linuxmint/muffin/tags> ... tar.gz
    * <https://github.com/linuxmint/cjs/tags> ... tar.gz
    * <https://github.com/linuxmint/cinnamon-desktop/tags> ... tar.gz
    * <https://github.com/linuxmint/Cinnamon/tags> ... tar.gz

* Quellen auf das Build-System kopieren

Cjs
---

* Quellen auspacken: `gzip -cd cjs-2.0.0.tar.gz|tar xf -`
* ChangeLog-Eintrag anlegen: `(cd cjs-2.0.0; debchange --increment)`
* Verzeichnis rückbenennen: `mv cjs-2.0.0ubuntu1 cjs-2.0.0`
* ChangeLog-Eintrag editieren: `jmacs cjs-2.0.0/debian/changelog`
* Bau-Vorgang starten:<pre>
  cd cjs-2.0.0
  ./autogen.sh
  dpkg-buildpackage
  # Paket-Signierung klappt nicht
</pre>
* Cjs-Pakete signieren: `cd cjs-2.0.0; debsign`
* Cjs-Pakete installieren:<pre>
  sudo dpkg -i \
    libcjs-dev_2.0.0dp01~precise1_amd64.deb \
    libcjs0c_2.0.0dp01~precise1_amd64.deb 
</pre>

Cinnamon Desktop
----------------

* Quellen auspacken: `gzip -cd cinnamon-desktop-2.0.4.tar.gz|tar xf -`
* ChangeLog-Eintrag anlegen: `(cd cinnamon-desktop-2.0.4; debchange --increment)`
* Verzeichnis rückbenennen: `mv cinnamon-desktop-2.0.4ubuntu1 cinnamon-desktop-2.0.4`
* ChangeLog-Eintrag editieren: `jmacs cinnamon-desktop-2.0.4/debian/changelog`
* Bau-Vorgang starten:<pre>
  cd cinnamon-desktop-2.0.4
  ./autogen.sh
  dpkg-buildpackage
</pre>
* Cinnamon-Desktop-Pakete installieren:<pre>
  sudo dpkg -i \
     cinnamon-desktop-data_2.0.4_all.deb        \
     gir1.2-cinnamondesktop-3.0_2.0.4_amd64.deb \
     libcinnamon-desktop-dev_2.0.4_amd64.deb    \
     libcinnamon-desktop0_2.0.4_amd64.deb
</pre>

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
* Muffin-Pakete installieren:<pre>
  sudo dpkg -i \
      gir1.2-muffin-3.0_2.0.5dp01precise~1_amd64.deb \
      libmuffin-dev_2.0.5dp01precise~1_amd64.deb     \
      libmuffin0_2.0.5dp01precise~1_amd64.deb        \
      muffin-common_2.0.5dp01precise~1_all.deb 
</pre>

Cinnamon
--------

* Quellen auspacken: `gzip -cd Cinnamon-2.0.14.tar.gz|tar xf -`
* ChangeLog-Eintrag anlegen: `(cd Cinnamon-2.0.14; debchange --increment)`
* ChangeLog-Eintrag editieren: `jmacs Cuffin-2.0.14/debian/changelog`
* Bau-Vorgang starten:<pre>
  cd Cinnamon-2.0.14
  ./autogen.sh
  dpkg-buildpackage
</pre>
