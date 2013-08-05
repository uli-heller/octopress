---
layout: post
author: Uli Heller
published: true
title: "Neue Einträge für debian/changelog"
date: 2013-03-21 07:00
comments: true
categories:
- Linux
- Debian
- Ubuntu
---

Erstellen von Debian-Paketen: Neue Einträge für debian/changelog
================================================================

Wenn man selbst gelegentlich Debian-Pakete erstellt, so kommt man öfter in die Lage die Datei debian/changelog editieren zu müssen.

<!-- more -->

Die Datei selbst ist eine einfache Text-Datei und hat beispielsweise so einen Inhalt:

{% codeblock Beispiel: debian/changelog %}
gexiv2 (0.3.1-0maverick1) maverick; urgency=low

  * All debug and log messages from Exiv2 are now routed through GLib's logging functions.

 -- Jim Nelson <jim@yorba.org>  Tue, 22 Mar 2011 14:46:17 -0700


gexiv2 (0.3.0-0maverick1) maverick; urgency=low

  * Updated to work with Exiv2 0.21, which has an ABI change from 0.20.

 -- Jim Nelson <jim@yorba.org>  Mon, 10 Jan 2011 12:18:07 -0800
{% endcodeblock %}

Wenn man nun einen neuen Eintrag anlegen möchte, so muß man diese Dinge erzeugen:

* die Überschrift; hierbei darauf achten, dass die Versionsnummer hochgezählt wird!
* einen neuen "Bullet-Item" erzeugen
* die Unterschrift mit eigener Mail-Adresse und richtigem Zeitstempel

Besonders die Sache mit dem Zeitstempel empfinde ich als lästig.

Viel einfacher geht's mit `debchange --increment`: Es öffnet sich direkt ein Editor mit einer Vorlage für den neuen Eintrag!

{% codeblock debchange --increment %}
gexiv2 (0.3.1-0ubuntu1) precise; urgency=low

  *

 -- Uli Heller <uli.heller@daemons-point.com>  Thu, 21 Mar 2013 07:36:33 +0100

gexiv2 (0.3.1-0maverick1) maverick; urgency=low

  * All debug and log messages from Exiv2 are now routed through GLib's logging functions.

 -- Jim Nelson <jim@yorba.org>  Tue, 22 Mar 2011 14:46:17 -0700

...
{% endcodeblock %}
