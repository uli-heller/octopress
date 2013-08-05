---
layout: post
author: Uli Heller
published: true
title: "GitHub - Downloads"
date: 2013-02-12 08:00
updated: 2013-02-14 08:00
comments: true
categories: 
- Git
- GitHub
---

GitHub - Anlegen eines Download-Bereichs
========================================

Ende 2012 sorgte GitHub bei mir für einige Verwirrung, indem
die Möglichkeit des Bereitstellens von Download-Dateien abgeschafft wurde.

Als Notbehelf verwende ich aktuell einfach einen speziellen Zweig namens
"downloads" und lege dann die runterladbaren Dateien darin ab.

Download-Zweig anlegen
----------------------

Den Download-Zweig legt man grob so an:

* Sicherstellen: Alle Dateien sind gespeichert in Git! (mittels: `git status`)
* Neuen Zweig anlegen und leeren
* README.txt erzeugen mit einer kurzen Beschreibung
* README.txt in Git abspeichern
* Zweig nach GitHub hochschieben

{% codeblock Download-Zweig anlegen lang:sh %}
$ git checkout master
$ git status
# On branch master
nothing to commit, working directory clean
$ git checkout --orphan downloads
$ git rm -rf .
$ jmacs README.txt # Enter description of the branch
$ git add README.txt
$ git commit -m "Created branch: downloads"
$ git push --set-upstream origin downloads
$ git checkout master
{% endcodeblock %}

Dateien ablegen
---------------

{% codeblock Dateien ablegen lang:sh %}
$ git checkout downloads
$ cp .../my-project-0.1-bin.tar.xz .
$ cp .../my-project-0.1-bin.zip .
$ git add my-project-0.1-bin.tar.xz my-project-0.1-bin.zip
$ git commit -m "Added downloads of version 0.1" .
$ git push # might take some time depending on your internet connection bandwidth
$ git checkout master # switch back to master
{% endcodeblock %}
