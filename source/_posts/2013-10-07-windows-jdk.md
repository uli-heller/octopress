---
layout: post
author: Uli Heller
published: true
title: "JDK unter Windows installieren ohne Administratorrechte"
date: 2013-10-07 18:00
# updated: 2013-07-20 08:00
comments: true
categories:
- Linux
- Ubuntu
- Precise
- Windows
- JDK
---

Leider muß ich bei meinem aktuellen Projekt unter Windows entwickeln.
Es handelt sich um ein Java-Projekt. Die Arbeit kann nur auf einem Notebook
erfolgen, das mir mein Auftraggeber stellt. Das Notebook läuft unter
Windows 7 und stellt eine VPN-Verbindung zum Firmennetz her.

Zur Entwicklung des im Projektrahmen zu erstellenden Programms benötige
ich ein JDK. Das Einspielen auf dem Notebook gestaltet sich schwierig,
denn ich habe dort keine Administratorrechte und Oracle's JDK benötigt
eben diese. Schöner Mist. Nachfolgend eine Beschreibung, wie ich mir
beholfen habe. Ich benötige dazu einen Linux-Rechner und einen USB-Stick.

<!-- more -->

## Linux-Rechner

Auf meinem Linux-Rechner ist Ubuntu-12.04 installiert. Zusätzlich
benötige ich Wine. Dieses wird schnell nachinstalliert mit

    sudo apt-get install wine

Die Installation hat bei mir zunächst nicht geklappt - vermutlich weil
ich auch VirtualBox auf dem Linux-Rechner habe. In einem LXC-Container
ging's problemlos.

Danach:

* Oracle JDK für Windows x86 herunterladen von <http://oracle.com>
* Heruntergeladene Datei in LXC-Container hineinkopieren
* Kopierte Datei im LXC-Container ausführen mittels Wine<pre>
  wine ./jdk.exe</pre>
* Es erscheinen diverse Fehlermeldungen -> ignorieren!
* Ordner ~/.wine/drive_c/Program Files/java verpacken (bspw. mit `zip`)
* Verpackten Ordner auf USB-Stick speichern

## Windows-Rechner

* Ordner vom USB-Stick auspacken nach C:\Uli
* Skript erstellen zur Erweiterung der Umgebungsvariablen PATH
* Test: `javac -version` -> javac 1.7.0_40

Der Aufruf vom Java-Kompiler klappt - ich bin zufrieden!
