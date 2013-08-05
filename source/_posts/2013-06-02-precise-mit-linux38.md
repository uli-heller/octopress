---
layout: post
author: Uli Heller
published: true
title: "Ubuntu-12.04 mit 3.8-er-Kernel"
date: 2013-06-02 17:30
updated: 2013-06-14 19:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Kernel
---

Heute habe ich den Drang verspürt, den Raring-Kernel - also Linux-3.8 - auf
mein Precise-System zu installieren.

<!--more -->

Zuvor hatte ich
dan Hardware-Enablement-Stack für 12.04 installiert
und damit schon den 3.5-er-Kernel verwendet und auch
den neueren XServer. Details dazu stehen hier:
[Neuer Kernel für Ubuntu-12.04](/2013/02/20/precise-hardware-enablement/).

Das Einspielen des Kernels geht ganz einfach. Nach dem Einspielen
muß man seinen Rechner neu starten, damit der neue Kernel auch
verwendet wird:

{% codeblock Einspielen des Raring-Kernels lang:sh %}
$ sudo apt-get install linux-generic-lts-raring
...
Error! Could not locate dkms.conf file.
File:  does not exist.
...
$ reboot
{% endcodeblock %}

Wie oben angedeutet erschien bei mir u.a. eine Fehlermeldung bzgl. "dkms.conf".
Die habe ich einfach ignoriert und noch keinen Fehler festgestellt (auch nicht
mit "VirtualBox" und anderen Dingen, die Kernel-Module benötigen).

Nachdem der neue Kernel gut funktioniert, lösche ich nun die alten Kernels:

{% codeblock Entfernen der Alt-Kernel lang:sh %}
sudo apt-get purge linux-generic
sudo apt-get purge linux-generic-lts-quantal
dpkg --get-selections "linux*-3.2*"|cut -f1|xargs sudo apt-get purge -y
dpkg --get-selections "linux*-3.5*"|cut -f1|xargs sudo apt-get purge -y
{% endcodeblock %}

## Fehlermeldung bzgl. dkms.conf

Die oben genannte Fehlermeldung erscheint auch bei späteren Aktualisierungen
des Kernels. Dennoch scheint nach der Aktualisierung alles zu funktionieren,
auch VirtualBox-VMs können gestartet werden.

Die Fehlermeldung erscheint auch beim Neukompilieren der Kernel-Module
von VirtualBox:

{% codeblock Neukompilieren der Kernel-Module von VirtualBox lang:sh %}
$ sudo /etc/init.d/vboxdrv setup
 * Stopping VirtualBox kernel modules                                    [ OK ] 
 * Uninstalling old VirtualBox DKMS kernel modules                              Error! Could not locate dkms.conf file.
File:  does not exist.
                                                                         [ OK ]
 * Trying to register the VirtualBox kernel modules using DKMS           [ OK ] 
 * Starting VirtualBox kernel modules                                    [ OK ] 
{% endcodeblock %}

Folgende Dinge habe ich ausprobiert, um das Problem zu lösen:

* `sudo apt-get install --reinstall dkms` ... keine Besserung
* `sudo dpkg -i virtualbox-4.2_4.2.12-84980~Ubuntu~precise_amd64.deb` ... keine Besserung
* `sudo apt-get purge dkms; sudo apt-get install dkms` ... keine Besserung
* `sudo rm -rf /var/lib/dkms/vboxhost/4.2.*` ... danach klappt's wieder ohne Fehlermeldung (siehe <http://8thstring.blogspot.fr/2012/01/error-could-not-locate-dkmsconf-file.html>)
