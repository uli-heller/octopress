---
layout: post
author: Uli Heller
published: true
title: "Kompilierung und Tests überspringen beim Paketbau"
date: 2013-10-04 09:00
# updated: 2013-02-16 08:00
comments: true
categories: 
- Linux
- Debian
- Ubuntu
- Packaging
---

Gelegentlich baue ich selbst Pakete für Debian/Ubuntu. Manchmal habe ich dabei Tippfehler
in Paketbeschreibungsdateien wie "debian/rules" und "debian/control". Diese treten oftmals erst
gegen Ende des Paketbauprozesses auf und nach einer Korrektur der Fehler habe ich gerne schnell
Gewissheit, ob die Korrekturen OK sind oder nicht - ein kompletter Neubau scheidet für die
meisten Pakete dann aus.

Mit diesem Befehl werden Kompilierung und Übersprungen:

    fakeroot debuan/rules binary

Innerhalb von wenigen Sekunden weiß ich so, ob die Korrekturen richtig waren oder ob ich noch
weitere Dinge ändern muß. Wenn das Kommando durchläuft, führe ich idR. nochmals

    dpkg-buildpackage

aus um das Paket komplett neu zu bauen und zu paketieren.
