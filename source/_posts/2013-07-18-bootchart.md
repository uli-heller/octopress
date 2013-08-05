---
layout: post
author: Uli Heller
published: true
title: "Analyse des Systemstarts"
date: 2013-07-18 10:00
updated: 2013-07-19 17:00
comments: true
categories:
- Linux
- Ubuntu
- Precise
---

Mein Samsung-Laptop benötigt sehr lange für den Systemstart.
Gefühlt dauert's 5 Minuten vom Einschalten bis zum Login-Prompt.
Das sollte doch irgendwie schneller gehen - nur wie?

<!-- more -->

## Bootchart

### Installieren

```
sudo apt-get install bootchart pybootchartgui
```

### Neustart

```
sudo reboot
```

### Sichten

* Verzeichnis: /var/log/bootchart
* Dateien: uli-samsung-precise-20130718-1.tgz und uli-samsung-precise-20130718-1.png

![Bootchart vom Samsung-Laptop](/images/bootchart/uli-samsung-precise-20130718-1.png)

Es fällt auf, dass ein Großteil der Zeit in IOWAIT verbracht wird (dicke rotbraune Balken). Somit liegt die Vermutung nahe, dass die interne Festplatte wohl schnarchlahm ist. Das deckt sich auch wunderbar mit meinen Beobachtungen bei der täglichen Arbeit:

* Editieren eines Shell-Skriptes
* Speichern
* Fenster-Wechsel + Start des Skriptes
* Start scheitert mit einer Fehlermeldung (sinngemäß: "Skript gesperrt")
* 2 Sekunden warten + nochmaliger Start
* Start klappt

### Versuch: SSD an USB-3

Eine externe SSD angeschlossen an die USB-3-Schnittstelle startet "schnell" (... gefühlt dauert's ähnlich lang wie beim Macbook Air 2013).

Also: Scheint wirklich an der lahmen Platte zu liegen.
