---
layout: post
author: Uli Heller
published: true
title: "Ubuntu-Debian-Pakete mit LXC erzeugen"
date: 2013-05-12 10:00
updated: 2013-05-12 19:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Lxc
- Pakete
---

Installation von LXC
--------------------

{% codeblock Installation von LXC %}
sudo apt-get install lxc
{% endcodeblock %}

Container-Partition /lxc
------------------------

Dieser Abschnitt kann optional ausgeführt werden.
Voraussetzung ist, dass es eine Volume Group namens "datavg"
gibt und dass diese über mindestens 10 GB freien Speicherplatz
verfügt.

### Partition anlegen

{% codeblock %}
sudo lvcreate -n lxclv -L10G datavg
sudo mkfs.btrfs /dev/datavg/lxclv
{% endcodeblock %}

### Partition einbinden

{% codeblock %}
sudo -s
mkdir /lxc
echo "/dev/datavg/lxclv /lxc btrfs defaults 0 3" >>/etc/fstab
mount /lxc
rmdir /var/lib/lxc
ln -s /lxc/lib /var/lib/lxc
rm -rf /var/cache/lxc
ln -s /lxc/cache /var/cache/lxc
{% endcodeblock %}

<!--
Verwendung vom lokalen Apt-Cacher-Ng
------------------------------------

Datei /etc/default/lxc editieren:

{% codeblock %}
MIRROR="http://127.0.0.1:3142/archive.ubuntu.com/ubuntu"
{% endcodeblock %}

... funktioniert nicht, es werden viele Pakete als "nicht verifizierbar" ausgewiesen.
-->

Erstellen von Containern
------------------------

### 12.04, 32bit

{% codeblock %}
sudo lxc-create -t ubuntu -n ubuntu1204-32-build -- -r precise -a i386
{% endcodeblock %}

Das Komando liefert typischerweise Ausgaben dieser Art:

{% codeblock %}
$ sudo lxc-create -t ubuntu -n ubuntu1204-32 -- -r precise -a i386
[sudo] password for uli: 

No config file specified, using the default config
debootstrap ist /usr/sbin/debootstrap
Checking cache download in /var/cache/lxc/precise/rootfs-i386 ... 
Copy /var/cache/lxc/precise/rootfs-i386 to /var/lib/lxc/ubuntu1204-32/rootfs ... 
Copying rootfs to /var/lib/lxc/ubuntu1204-32/rootfs ...

##
# The default user is 'ubuntu' with password 'ubuntu'!
# Use the 'sudo' command to run tasks as root in the container.
##

'ubuntu' template installed
'ubuntu1204-32' created
{% endcodeblock %}

### 12.04, 64bit

64-bit Container können nur erstellt werden, wenn das Basissystem auch ein 64-bit-System ist!

{% codeblock %}
sudo lxc-create -t ubuntu -n ubuntu1204-64-build -- -r precise -a amd64
{% endcodeblock %}

Arbeit mit Containern
---------------------

* Anmelden
    * Benutzer: "ubuntu"
    * Kennwort: "ubuntu"
* Netzwerk
    * IP-Adressen: Aus dem Adressbereich 10.0.3/24
    * NAT: Funktioniert - @ping google.com@
    * SSH vom Host in den Container: Funktioniert - @ssh ubuntu@10.0.3.250@

Anpassung der Container
-----------------------

### Verwenden des Apt-Cacher-Ng vom Host-System

Erstellen von /etc/apt/apt.conf.d/01proxy:

{% codeblock /etc/apt/apt.conf.d/01proxy %}
Acquire::http::Proxy "http://10.0.3.1:3142";
{% endcodeblock %}

### Installation von JOE/JMACS

{% codeblock %}
sudo apt-get install joe
{% endcodeblock %}

### Paketquellen ergänzen um Source-Repositories

{% codeblock /etc/apt/sources.list lang:diff %}
diff -u sources.list.orig sources.list
--- sources.list.orig	2012-09-30 09:41:15.000000000 +0200
+++ sources.list	2013-05-12 18:27:29.615640758 +0200
@@ -1,3 +1,6 @@
 deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse
+deb-src http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse
 deb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse
+deb-src http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse
 deb http://security.ubuntu.com/ubuntu precise-security main restricted universe multiverse
+deb-src http://security.ubuntu.com/ubuntu precise-security main restricted universe multiverse
{% endcodeblock %}

### Aktualisierung auf den neuesten Stand

{% codeblock %}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get clean
{% endcodeblock %}

Build-Tools einspielen
----------------------

{% codeblock %}
sudo apt-get update
sudo apt-get install build-essential fakeroot dpkg-dev devscripts
sudo apt-get install autotools-dev debhelper pkg-config
sudo apt-get install dh-autoreconf
sudo apt-get clean
{% endcodeblock %}

GPG-Schlüssel übernehmen
------------------------

Dieser Abschnitt ist optional. Er wird nur benötigt, um signierte
DEB-Pakete zu erzeugen!

Auf dem bestehenden Build-System wird der GPG-Schlüssel exportiert:

{% codeblock GPG-Schlüssel exportieren %}
gpg --export-secret-keys >gpg.keys
{% endcodeblock %}

Auf dem neuen LXC-Build-System wird der GPG-Schlüssel importiert:

{% codeblock GPG-Schlüssel importieren %}
gpg --import <gpg.keys
{% endcodeblock %}

Durchführen eines Builds
------------------------

### nginx

{% codeblock %}
mkdir nginx
cd nginx
apt-get source nginx
sudo apt-get build-dep nginx
cd nginx-1.1.19
dpkg-buildpackage
{% endcodeblock %}

### libseccomp

{% codeblock %}
# Kopieren der nachfolgenden Dateien:
#  libseccomp_0.1.0-1dp01~precise2.debian.tar.gz
#  libseccomp_0.1.0-1dp01~precise2.dsc 
#  libseccomp_0.1.0.orig.tar.gz
dpkg-source -x  libseccomp_0.1.0-1dp01~precise2.dsc
cd libseccomp-0.1.0
dpkg-buildpackage
{% endcodeblock %}

### lxc

... läuft analog zu "libseccomp"

Sichern und Rückspielen von Containern
--------------------------------------

### Sichern

{% codeblock %}
cd /lxc
sudo tar -cvjpf /backups/lxc/20121119.tar.bz2 .
{% endcodeblock %}

### Rückspielen

{% codeblock %}
cd /lxc
sudo tar -xvjpf /backups/lxc/20121119.tar.bz2
{% endcodeblock %}

Probleme
--------

### Offene Punkte

#### Wie sorgt man dafür, dass ein Container nur über ein Host-Only-Netzwerk erreichbar ist?

### Erledigte Punkte

#### Verwendung des Apt-Cacher-Ng durch einen Container

... geht wie üblich durch /etc/apt/apt.conf.d/01proxy innerhalb des Containers

#### Wie übernimmt man einen Container auf ein anderes System?

... durch Sichern und Rückspielen.

Links
-----

* [Ubuntu 12.04 Server Guide](https://help.ubuntu.com/12.04/serverguide/lxc.html)
