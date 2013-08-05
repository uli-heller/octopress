---
layout: post
title: "GrubReboot: Reboot eines anderen Eintrages des Grub-Menüs"
date: 2013-05-11 06:31
comments: true
external-url: 
categories: 
- Linux
- Ubuntu
- Precise
- Grub
---

Üblicherweise starte ich meine diversen VMs einfach mit `sudo reboot`
neu. Dabei wird dann der Standard-Eintrag im Grub-Menü selektiert und
das betreffende Betriebssystem hochgefahren.

Manchmal möchte ich aber einen anderen Eintrag aktivieren und ein
alternatives Betriebssystem oder einen anderen Linux-Kernel starten.
Das Verfahren habe ich mir von [Michael Prokop's Blog](http://michael-prokop.at/blog/2013/05/10/how-to-get-grub-reboot-working/) 'geklaut'.

<!-- more -->

## Sichten: Welche Menüeinträge gibt es?

{% codeblock Liste der Menüeinträge in Grub lang:sh %}
# grep "^menuentry" /boot/grub/grub.cfg
menuentry 'Ubuntu, with Linux 3.2.0-36-virtual' --class ubuntu --class gnu-linux --class gnu --class os {
menuentry 'Ubuntu, with Linux 3.2.0-36-virtual (recovery mode)' --class ubuntu --class gnu-linux --class gnu --class os {
menuentry "Memory test (memtest86+)" {
menuentry "Memory test (memtest86+, serial console 115200)" {
{% endcodeblock %}

## Umstellen des Standard-Boot-Eintrages

{% codeblock Umstellen der Standard-Boot-Eintrages lang:sh %}
# grep GRUB_DEFAULT /etc/default/grub
GRUB_DEFAULT=0
# sed -i 's/^GRUB_DEFAULT.*/GRUB_DEFAULT=saved/' /etc/default/grub
# grep GRUB_DEFAULT /etc/default/grub
GRUB_DEFAULT=saved
# update-grub
Generating grub.cfg ...
Found linux image: /boot/vmlinuz-3.2.0-36-virtual
Found initrd image: /boot/initrd.img-3.2.0-36-virtual
Found memtest86+ image: /memtest86+.bin
done
{% endcodeblock %}

## Neustart eines anderen Eintrages

Ich möchte den Eintrag "Memory test (memtest86+)"
starten, das ist der dritte Eintrag im Boot-Menü:

{% codeblock Neustart mit dem dritten Standard-Boot-Eintrag lang:sh %}
# grub-reboot 2
# reboot
{% endcodeblock %}

Nun wird der dritte Eintrag gestartet, der blaue Bildschirm von
"Memory Test" erscheint.

Beim nächsten Neustart wird dann wieder der ursprüngliche Boot-Eintrag
geladen.
