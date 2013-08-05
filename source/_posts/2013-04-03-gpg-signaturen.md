---
layout: post
author: Uli Heller
published: true
title: "GPG: Signaturen"
date: 2013-04-03 15:00
updated: 2013-04-05 11:30
comments: true
categories:
- Linux
- GPG
- PGP
---

GPG/PGP-Signatur von Quelltext-Dateien prüfen
=============================================

Quelltextdateien werden oftmals mit GPG/PGP-Signaturen bereitgestellt, über die die Integrität der Dateien geprüft werrden kann. Hier zeige ich exemplarisch, wie dies für Subversion und Nginx gemacht wird.

<!-- more -->

Subversion
----------

1. Quelltext herunterladen: `wget http://mirror.serversupportforum.de/apache/subversion/subversion-1.7.9.tar.gz`

2. Signatur herunterladen: `wget http://www.apache.org/dist/subversion/subversion-1.7.9.tar.gz.asc`

3. Schlüssel importieren: `wget -O - https://people.apache.org/keys/group/subversion.asc|gpg --import`

4. Signatur prüfen: `gpg subversion-1.7.9.tar.gz.asc`

Nginx
-----

1. Quelltexte herunterladen: `wget -O - http://nginx.org/download/nginx-1.2.8.tar.gz|gzip -cd >nginx-1.2.8.tar.gz`

   Hinweis: Dieses umständliche Vorgehen ist notwendig, weil die Version 1.2.8 aus unerfindlichen Gründen "doppelt komprimiert" ist!

2. Signatur herunterladen: `wget http://nginx.org/download/nginx-1.2.8.tar.gz.asc`

3. Signatur prüfen: `gpg  nginx-1.2.8.tar.gz.asc`

   Klappt nicht: Es wird gemeckert weil der zugehörige RSA-Schlüssel fehlt

4. Schlüssel importieren - auf eine der folgenden Arten:

    * Vom Keyserver: `gpg --keyserver pgpkeys.mit.edu --recv-key A1C052F8`

    * Mittels manuellem Download: `wget -O - http://nginx.org/keys/mdounin.key|gzip -cd|gpg --import`

   Ich hab's auf beide Arten gemacht und dabei überprüft, dass der Schlüssel identisch ist!

6. Erneuter Test: `gpg  nginx-1.2.8.tar.gz.asc`

   Klappt halbwegs!
