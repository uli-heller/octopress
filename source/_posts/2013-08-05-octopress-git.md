---
layout: post
author: Uli Heller
published: true
title: "Octopress und Git ohne Umbenennung"
date: 2013-08-05 08:00
updated: 2013-08-07 10:00
comments: true
categories:
- Linux
- Octopress
---

Octopress hat die Eigenart, bei Verwendung von Git als "Deployment-Methode"
die Zweige umzubenennen:

* Umbenennung: origin -> octopress
* Neuanlage:   origin <- repo_url
* Umbenennung: master -> source
* etc.

Die ganze Umbenennerei gefällt mir garnicht. Ich mag's so:

* uli-octopress: Das ist mein "normales" GitHub-Repository, in dem ich alle
  Quelltexte meiner Octopress-Installation halte
* uli-heller.github.com: Das ist das GitHub-Repository, in dem ich die
  generierten HTML-Seiten veröffentliche

<!-- more -->

## uli-octopress

Hierbei gibt es keine Besonderheiten. Einfach das Repository in GitHub
anlegen und klonen wie üblich.

## uli-heller.github.com

Am besten erstmal einfach leer anlegen mit einem Branch namens "master".

## Deployment-Methode konfigurieren

### _deploy

Das Verzeichnis "_deploy" wird angelegt durch `git clone ...` und
anschließendes Umbenennen mit `mv ...`.

{% codeblock Anlegen des Verzeichnisses _deploy lang:sh %}
$ cd uli-octopress

uli-octopress$ git clone git@github.com:uli-heller/uli-heller.github.com.git
Klone nach 'uli-heller.github.com'...
remote: Counting objects: 14438, done.
remote: Compressing objects: 100% (3999/3999), done.
remote: Total 14438 (delta 7274), reused 13662 (delta 6502)
Empfange Objekte: 100% (14438/14438), 16.14 MiB | 218.00 KiB/s, done.
Löse Unterschiede auf: 100% (7274/7274), done.
Checking connectivity... done

uli-octopress$ mv uli-heller.github.com _deploy
{% endcodeblock %}

### Rakefile

Nun noch Anpassungen an Rakefile:

{% codeblock Anpassungen am Rakefile lang:diff %}
diff --git a/Rakefile b/Rakefile
index f3ada93..321c3c5 100644
--- a/Rakefile
+++ b/Rakefile
@@ -9,10 +9,10 @@ ssh_port       = "22"
 document_root  = "~/website.com/"
 rsync_delete   = false
 rsync_args     = ""  # Any extra arguments to pass to rsync
-deploy_default = "rsync"
+deploy_default = "push"
 
 # This will be configured for you when you run config_deploy
-deploy_branch  = "gh-pages"
+deploy_branch  = "master"
 
 ## -- Misc Configs -- ##
{% endcodeblock %}

## Test

{% codeblock Test lang:sh %}
uli-octopress$ rake generate
## Generating Site with Jekyll
identical source/stylesheets/screen.css 
Configuration from /home/uli/git/octopress/_config.yml
Building site: source -> public
...
Successfully generated site: source -> public

uli-octopress$ rake preview
Starting to watch source with Jekyll and Compass. Starting Rack on port 4000
[2013-08-05 07:55:34] INFO  WEBrick 1.3.1
...

uli-octopress$ rake deploy
## Generating Site with Jekyll
identical source/stylesheets/screen.css 
Configuration from /home/uli/git/octopress/_config.yml
Building site: source -> public
...
## Pushing generated _deploy website
Counting objects: 710, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (275/275), done.
Writing objects: 100% (382/382), 95.23 KiB | 0 bytes/s, done.
Total 382 (delta 194), reused 0 (delta 0)
To git@github.com:uli-heller/uli-heller.github.com.git
   4d99436..e7770a8  master -> master

## Github Pages deploy complete
cd -
{% endcodeblock %}
