---
layout: post
author: Uli Heller
published: true
title: "Xubuntu mit deutscher Tastatur"
date: 2014-07-27 12:00
#updated: 2014-02-15 07:00
comments: true
categories: 
- Linux
- Ubuntu
---

In letzter Zeit habe ich mehrfach ein Xubuntu-14.04 neu aufgesetzt und
mich immer wieder über die Tastaturbelegung geärgert. Irgendwie ist per
Standard immer die englische Belegung (QWERTY) aktiv.

<!-- more -->

Xubuntu Grundinstallation
-------------------------

Für die Grundinstallation verwende ich imer die Server-CD,
weil ich damit bei der Partitionierung flexibler bin. Hier der Grobablauf:

* Basissystem von ubuntu-server-14.01 mit eigener Partitionierung - hier ist
  die deutsche Tastaturbelegung kein Problem
* xubuntu-desktop nachinstallieren: `sudo apt-get install xubuntu-desktop`
* Neustart und graphische Anmeldung - nun ist die Tastaturbelegung englisch.
* Umschalten auf Konsole - hier ist die Tastaturbelegung deutsch.

Sprachinstallation komplettieren
--------------------------------

* Alle Einstellungen - Sprachen
* "Die Sprachunterstützung ist nicht vollständig installiert" - Installieren
* Das dauert eine ganze Weile...
* Danach ist die Tastaturbelegung immer noch falsch!
* Auch ein Neustart bringt keine Verbesserung, es erscheinen lediglich mehr
  Texte auf Deutsch statt auf Englisch

Tastaturbelegung ändern
-----------------------

* Alle Einstellungen - Tastatur
* "Systemweite Einstellungen benutzen" - nein!
* Tastaturbelegung - Hinzufügen
* Deutsch - Deutsch (ohne Akzenttasten)
* Ganz nach oben schieben
* Schließen
* Nun ist die Tastaturbelegung OK
* Auch nach einem Neustart ist sie OK
