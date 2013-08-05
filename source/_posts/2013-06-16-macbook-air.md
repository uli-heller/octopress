---
layout: post
author: Uli Heller
published: true
title: "Ubuntu auf einem Macbook Air - erste Eindrücke"
date: 2013-06-16 12:00
updated: 2013-06-24 06:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Raring
- Macbook Air
---

Bedingt durch die Probleme mit meinem Samsung-Notebook habe ich
mir nun ein Macbook Air 2013 11 Zoll gegönnt.

<!-- more -->

## Ubuntu-12.04.2 Live CD auf Macbook Air 2011

Einfach das Mac-Iso auf einen USB-Stick schreiben mittels @dd@,
den Stick an's Macbook anschließen und beim Neustart die "Alt"-Taste
gedrückt halten.

Das Macbook startet völlig problemlos. Alles scheint zu funktionieren,
sogar die WLAN-Karte.

## Ubuntu-12.04.2 Live CD auf Macbook Air 2013

Vorgehen wie zuvor. Bereits beim Start fällt auf, dass der "Splash-Screen"
mit dem Ubuntu-Logo nur in Textdarstellung erscheint. WLAN funktioniert
nicht und beim Versuch, den proprietären Treiber zu aktivieren stürzt der
Kernel ab.

## Ubuntu-13.04 Live CD auf Macbook Air 2013

Vorgehen wie zuvor, nur mit der 13.04-CD. Der Start sieht wesentlich besser
aus - eigentlich genauso, wie bei 12.04.2 mit dem alten Macbook Air. Der
"Splash Screen" erscheint in graphischer Form.

Leider funktioniert die WLAN-Karte im Live-CD-Modus nicht. Der proprietäre
Treiber wird auch nicht zum Nachladen angeboten.

## Ubuntu-12.04.2 Test-Installation auf Macbook Air 2013

Die Test-Installation verläuft weitgehend problemlos.
Der Start des installierten Systems funktioniert aber erstmal nicht, der
Bildschirm bleibt nach dem Grub-Menü einfach schwarz.
Über den Zwischenschritt "recovery mode" läßt sich der Desktop
aber normal starten.

Im Desktop fällt auf:

* die "Kleiner-Größer-Pipe-Taste" ist vertauscht mit der
  "Kreis-Dächlein-Taste" links neben der "1".
* die Funktionstasten zur Änderung der Helligkeit, ... funktionieren
  nicht

Da der WLAN-Adapter nicht funktioniert, kann ich aber

* keine Updates einspielen
* keine proprietären Treiber installieren

Bin also erstmal "ausgebremst".

## Ubuntu-12.04.2 Test-Installation auf Macbook Air 2011

Hierfür habe ich einfach die Test-Installation vom Macbook Air 2013
genommen und an das ältere Macbook Air drangestöpselt.

* Der Start ist ähnlich wie beim 2013-er-Modell: Bildschirm bleibt schwarz
* Recovery-Mode: Bleibt hängen mit

      Loading Linux 3.5.0-23-generic ...
      Loading initial ramdisk

Die Laufwerkslampe blinkt dabei permanent. Nachdem sich in 15 Minuten keine
Änderung getan hat, habe ich den Boot-Vorgang abgebrochen.
