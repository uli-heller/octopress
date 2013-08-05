---
layout: post
title: "Cinnamon-1.7.4 auf Ubuntu-12.04"
date: 2013-04-25 09:05
comments: true
external-url: 
categories: 
- Linux
- Ubuntu
- Precise
- Cinnamon
---

Heute habe ich versucht, die aktuelle Cinnamon-Version auf Ubuntu-12.04
zu installieren und zum Laufen zu bringen. Das Ergebnis war erstmal
ernüchternd: Nach dem Anmelden erscheint ein komplett leerer Bildschirm,
man sieht nur das Hintergrundbild.

Mit "Alt-t" kann man ein Terminal-Fenster öffnen und darin ein paar Tests
vornehmen:

* `muffin` ... startet problemlos
* `cinnamon` ... startet nicht, stattdessen erscheint eine Fehlermeldung bzgl. GJsDbus

Eine Google-Suche zeigt dann die Lösung: `sudo apt-get install gir1.2-gjsdbus-1.0`. Danach erscheint nach dem Anmelden die gewohnte Arbeitsoberfläche.

Jetzt habe ich mein Debian-Paket für Cinnamon so überarbeitet, dass
gir1.2-gjsdbus-1.0 direkt als Abhängigkeit eingetragen ist. Somit wird
es beim Installieren von Cinnamon künftig automatisch mit installiert.
