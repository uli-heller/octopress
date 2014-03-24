---
layout: post
author: Uli Heller
published: true
title: "LXC"
date: 2014-02-14 07:00
updated: 2014-03-24 10:00
comments: true
categories: 
- Linux
- Ubuntu
- Lxc
---

## Einleitung

Dies ist mein Artikel über LXC. Er enthält (hoffentlich) alle Dinge,
die ich für die tägliche Arbeit mit LXC so brauche. Er ist eine Zusammenstellung
alles LXC-Erkenntnisse aus dem Blog.

## Installation

```
sudo apt-get install lxc
```

## Container-Partition /lxc

Dieser Teil ist optional. Man kann ihn auch einfach weglassen, dann
werden die LXC-Container eben unterhalb von /var angelegt. Das setzt
dann natürlich voraus, dass dort noch genügend freier Platz vorhanden ist
- etwa 10GB sollten für den Anfang reichen. Prüfen kann man das mit
`df -h /var`.

Die nachfolgende Beschreibung geht davon aus, dass das System mit LVM
partitioniert ist und dass eine VolumeGroup namens "datavg" vorhanden
ist.

### Partition anlegen

```
sudo lvcreate -n lxclv -L10G datavg
sudo mkfs.btrfs /dev/datavg/lxclv
```

### Partition einbinden

```
sudo -s
mkdir /lxc
echo "/dev/datavg/lxclv /lxc btrfs defaults 0 3" >>/etc/fstab
mount /lxc
rmdir /var/lib/lxc
ln -s /lxc/lib /var/lib/lxc
rm -rf /var/cache/lxc
ln -s /lxc/cache /var/cache/lxc
```

## Erstellen von Containern

### 14.04, 64 bit

```
$ sudo lxc-create -t ubuntu -n ubuntu1404-64 -B btrfs -- -r trusty -a amd64
Checking cache download in /var/cache/lxc/trusty/rootfs-amd64 ... 
Installing packages in template: ssh,vim,language-pack-de,language-pack-en
Downloading ubuntu trusty minimal ...
I: Retrieving Release
I: Retrieving Release.gpg
I: Checking Release signature
...
##
# The default user is 'ubuntu' with password 'ubuntu'!
# Use the 'sudo' command to run tasks as root in the container.
##
```

### 14.04, 32 bit

```
$ sudo lxc-create -t ubuntu -n ubuntu1404-32 -B btrfs -- -r trusty -a i386
Checking cache download in /var/cache/lxc/trusty/rootfs-i386 ... 
Installing packages in template: ssh,vim,language-pack-de,language-pack-en
Downloading ubuntu trusty minimal ...
I: Retrieving Release
I: Retrieving Release.gpg
I: Checking Release signature
...
##
# The default user is 'ubuntu' with password 'ubuntu'!
# Use the 'sudo' command to run tasks as root in the container.
##
```

### Alt-Container

Die nachfolgend aufgeführten Alt-Container habe ich vor grob einem Jahr angelegt.
Sie werden teilweise mit falschen Optionen angelegt!

#### 12.04, 64bit

64-bit Container können nur erstellt werden, wenn das Basissystem auch ein 64-bit-System ist!

```
sudo lxc-create -t ubuntu -n ubuntu1204-64 -- -r precise -a amd64
```

#### 12.04, 32bit

```
sudo lxc-create -t ubuntu -n ubuntu1204-32 -- -r precise -a i386
```

```
uli@uli-hp-ssd:~/Downloads/virtualbox$ sudo lxc-create -t ubuntu -n ubuntu1204-32 -- -r precise -a i386
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
```

#### 13.04, 64bit

```
sudo lxc-create -t ubuntu -n ubuntu1304-64 -- -r raring -a amd64
```

#### 13.04, 32bit

```
sudo lxc-create -t ubuntu -n ubuntu1304-32 -- -r raring -a i386
```

#### 10.04, 32bit

```
sudo lxc-create -t ubuntu -n ubuntu1204-32 -- -r lucid -a i386
```

## Arbeit mit Containern

* Anmelden
    * Benutzer: "ubuntu"
    * Kennwort: "ubuntu"
* Netzwerk
    * IP-Adressen: Aus dem Adressbereich 10.0.3/24
    * NAT: Funktioniert - `ping google.com`
    * SSH vom Host in den Container: Funktioniert - `ssh ubuntu@10.0.3.250`

## Anpassung der Container

### Verwenden des Apt-Cache-Ng vom Host-System

Erstellen von /etc/apt/apt.conf.d/01proxy:

```
Acquire::http::Proxy "http://10.0.3.1:3142";
```

### Installation von JOE/JMACS

```
sudo apt-get install joe
```

## Sichern und Rückspielen von Containern

### Sichern

```
cd /lxc
sudo tar -cvjpf /backups/lxc/20121119.tar.bz2 .
```

### Rückspielen

```
cd /lxc
sudo tar -xvjpf /backups/lxc/20121119.tar.bz2
```

## Probleme

### Offene Punkte

#### Wie sorgt man dafür, dass ein Container nur über ein Host-Only-Netzwerk erreichbar ist?

#### lxc-create hängt endlos direkt nach dem Start - was ist zu tun?

Ich habe mit lxc-1.0.1 folgendes beobachtet:

* Anlegen von Ubuntu-14.04 amd64 funktioniert problemlos
* Darauffolgendes Anlegen von Ubuntu-14.04 i386 hängt endlos

Ich konnte das nur durch Abbrechen des Anlegens, Löschen des halb angelegten Containers und von /run/lock/subsys/lxc-ubuntutrusty
gefolgt vom erneuten Anlegen korrigieren.

```
$ sudo lxc-create -t ubuntu -n ubuntu1404-32 -B btrfs -- -r trusty -a i386
{hängt endlos}
^C
$ sudo lxc-destroy -n ubuntu1404-32
lxc-destroy: Error: ubuntu1404-32 creation was not completed
Container is not defined
$ sudo rm -f /run/lock/subsys/lxc-ubuntutrusty
$ sudo lxc-create -t ubuntu -n ubuntu1404-32 -B btrfs -- -r trusty -a i386
{jetzt geht's}
```

### Erledigte Punkte

#### Verwendung des Apt-Cacher-Ng durch einen Container

... geht wie üblich durch /etc/apt/apt.conf.d/01proxy innerhalb des Containers

#### Wie übernimmt man einen Container auf ein anderes System?

... durch Sichern und Rückspielen.

## Links

* Ubuntu 12.04 Server Guide: <https://help.ubuntu.com/12.04/serverguide/lxc.html>
