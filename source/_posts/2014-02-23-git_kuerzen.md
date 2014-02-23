---
layout: post
author: Uli Heller
published: true
title: "Git - Versionsgeschichte kürzen"
date: 2014-02-23 08:00
#updated: 2014-02-15 07:00
comments: true
categories: 
- Git
---

Dieser Artikel basiert auf einer Idee aus
<http://honk.sigxcpu.org/con/Truncating_git_history.html>.

Ein privates Git-Repository mit einer langen Git-Versionsgeschichte
soll bspw. auf GitHub veröffentlicht werden. Üblicherweise erscheint
das Repository dann inklusive kompletter Versionsgeschichte.

Ziel des hier beschriebenen Verfahrfens ist:

* Veröffentlichung ohne Versionsgeschichte
* Verfügbarhalten der Versionsgeschichte im lokalen Repository

<!-- more -->

Ausgangslage
------------

Unsere Ausganglage ist diese:

* Wir haben ein lokales Git-Projekt
* Das Git-Projekt hat keine "offenen Dateien":

```
$ git status
On branch master
nothing to commit, working directory clean
```

* Das Git-Projekt hat eine längere Git-Versionsgeschichte:

```
$ git log --oneline
3d5444e Some changes with git-1.9
7d10363 Subversion merge
...
```

* Der aktuell ausgecheckte Stand soll veröffentlicht werden ohne
  Versionsgeschichte.

Ablauf
------

Der für mich einfachste Ablauf ist dieser:

* Alten "master" wegschieben: `git branch -m master ancient-history`
* Neuen "master" erzeugen: `git checkout --orphan master`
* Neuen "master" wegschreiben: `git commit -m "Initial commit"`
* "Kurze" Versionsgeschichte: `git log --oneline master`
* "Lange" Versionsgeschichte: `git log --oneline master ancient-history`
