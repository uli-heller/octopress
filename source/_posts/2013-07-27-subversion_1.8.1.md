---
layout: post
author: Uli Heller
published: true
title: "Subversion 1.8.1 für Ubuntu-12.04"
date: 2013-07-27 10:00
#updated: 2013-07-12 07:00
comments: true
categories:
- Linux
- Ubuntu
- Precise
- Subversion
---

Vor ein paar Tagen wurde Subversion-1.8.1 veröffentlicht.
Hier meine Versuche, ein Paket für Ubuntu-12.04 zu bauen.
Eingeflossen sind dabei auch die gescheiterten Versuche
mit Subversion-1.8.0. Schlußendlich kommt eine für mich funktionierende
Version von Subversion-1.8.1 heraus.

<!-- more -->

## Ausgangpunkt: Subversion-1.8.0

Mein Ausgangspunkt sind meine kaputten Pakete für Subversion-1.8.0.

    $ cd subversion-1.8.0
    $ uupdate -u ../subversion-1.8.1
    $ cd ../subversion-1.8.1

Nun habe ich folgende Generierungs-Abhängigkeiten (build dependencies)
festgelegt:

* subversion: serf-1.2.1 und sqlite-3.7.15
* serf: sqlite-3.7.15

## Erste Hürde: Sqlite3-3.7.15

Subversion benötigt eine relativ aktuelle Version von Sqlite3. Die
Standard-Version von Ubuntu-12.04 ist zu alt. Ich habe mir so beholfen:

* Quellpakete von sqlite3-3.7.15.2 aus "raring" runtergeladen
* Ein paar kleine Anpassungen an debian/rules vorgenommen, damit
  tcl85 an der richtigen Stelle ausgelesen wird
* Pakete erzeugen mit `dpkg-buildpackage`
* Pakete installieren

## Zweite Hürde: Serf-1.2.1

* Diverse Umstellungen nötig, damit die Generierung durchläuft
* Pakete erzeugen mit `dpkg-buildpackage`
* Pakete installieren

## Subversion-1.8.1

* Kann nun wie üblich mit `dpkg-buildpackage` erzeugt werden

## Kurztests: Installation und Funktionsweise

{% codeblock %}
$ sudo dpkg -i subversion_1.8.1-3dp12~precise1_amd64.deb libsvn1_1.8.1-3dp12~precise1_amd64.deb libserf1_1.2.1-0dp01~precise1_amd64.deb
$ sudo dpkg -i sqlite3_3.7.15.2-1dp01~precise1_amd64.deb libsqlite3-0_3.7.15.2-1dp01~precise1_amd64.deb
$ svn --version
svn, Version 1.8.1 (r1503906)
   übersetzt am Jul 26 2013, um 15:38:27 auf x86_64-pc-linux-gnu

Copyright (C) 2013 The Apache Software Foundation.
Diese Software besteht aus Beiträgen vieler Personen;
siehe Datei NOTICE für weitere Informationen.
Subversion ist Open Source Software, siehe http://subversion.apache.org/

Die folgenden ZugriffsModule (ZM) für Projektarchive stehen zur Verfügung:

* ra_svn : Modul zum Zugriff auf ein Projektarchiv über das svn-Netzwerkprotokoll.
  - mit Cyrus-SASL-Authentifizierung
  - behandelt Schema »svn«
* ra_local : Modul zum Zugriff auf ein Projektarchiv auf der lokalen Festplatte
  - behandelt Schema »file«
* ra_serf : Modul zum Zugriff auf ein Projektarchiv über das Protokoll WebDAV mittels serf.
  - behandelt Schema »http«
  - behandelt Schema »https«
$ cd svn/my-project
$ svn status
svn: E155036: Please see the 'svn upgrade' command
svn: E155036: The working copy at '/home/uli/svn/my-project'
is too old (format 29) to work with client version '1.8.1 (r1503906)' (expects format 31). You need to upgrade the working copy first.
$ svn upgrade
Upgraded '.'
$ svn status
$ svn update
Updating '.':
A    minianwendungjsf/.classpath
A    minianwendungjsf/ant
A    minianwendungjsf/ant/build.xml
A    minianwendungjsf/.project
...
A    EJB3.1_Test/login.config
Updated to revision 13.
$ svn checkout https://.....
A    my-project2/git-test
A    my-project2/git-test/Hello.txt
A    my-project2/git-test/01-git-neu.txt
...
A    my-project2/testfolder2
A    my-project2/testfolder2/testbin-ticket9.odt
Checked out revision 78.
{% endcodeblock %}

Also: Grobtest ist OK.
