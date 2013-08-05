---
layout: post
author: Uli Heller
published: true
title: "Octopress-Installation"
date: 2012-11-24 10:49
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Ruby
- Blog
- Octopress
---

Meine erste Octopress-Installation
==================================

Installation
------------

### Vorbereitungen

* Sicherstellen: Zugang zum Internet besteht
* Größe der /usr-Partition auf 800MB setzen
* Größe der /tmp-Partition auf 300MB setzen
* Größe der /home-Partition auf 250MB setzen
* GCC installieren
* Libs installieren
* Curl installieren

{% codeblock Partition vergrößern und diverse Pakete installieren lang:sh %}
sudo lvextend -L+400M /dev/systemvg/usrlv
sudo resize2fs /dev/systemvg/usrlv
sudo lvextend -L+200M /dev/systemvg/tmplv
sudo resize2fs /dev/systemvg/tmplv
sudo lvextend -L+200M /dev/systemvg/homelv
sudo resize2fs /dev/systemvg/homelv
sudo apt-get install gcc build-essential
sudo apt-get install libyaml-dev libz-dev libssl-dev
sudo apt-get install curl
{% endcodeblock %}

### Basispakete

#### Git

{% codeblock Git installieren lang:sh %}
sudo apt-get install -y git
sudo apt-get clean
{% endcodeblock %}

Für GIT wird die Version 1.8.0-0dp3~precise01 vom DPREPO angezogen.

#### Ruby mittels RVM

{% codeblock Ruby installieren lang:sh %}
curl -L https://get.rvm.io | bash -s stable --ruby
. ./.rvm/scripts/rvm
rvm install 1.9.3 # Zeigt eine Fehlermeldung, weil 1.9.3 bereits installiert ist
rvm use 1.9.3
rvm rubygems latest
ruby --version    # ruby 1.9.3p327 (2012-11-10 revision 37606) [i686-linux]
{% endcodeblock %}

### Octopress

#### Erstinstallation

Die Schritte in diesem Abschnitt werden nur bei der allerersten Installation durchgeführt. Die dabei gemachten Einstellungen werden in einem zentralen Speicherbereich auf GitHub abgelegt und bei nachfolgenden Installationen von dort geladen.

##### Octopress und Pakete

{% codeblock Octropress installieren lang:sh %}
git clone git://github.com/imathis/octopress.git octopress
cd octopress
gem install bundler
bundle install
rake install
{% endcodeblock %}

##### Textile statt Markdown

{% codeblock Textile statt Markdown - Rakefile lang:diff %}
@@ -22,8 +22,8 @@ deploy_dir      = "_deploy"   # deploy directory (for Github p
 stash_dir       = "_stash"    # directory to stash posts for speedy generation
 posts_dir       = "_posts"    # directory for blog files
 themes_dir      = ".themes"   # directory for blog files
-new_post_ext    = "markdown"  # default new post file extension when using the 
-new_page_ext    = "markdown"  # default new page file extension when using the 
+new_post_ext    = "textile"   # default new post file extension when using the 
+new_page_ext    = "textile"   # default new page file extension when using the 
 server_port     = "4000"      # port for preview server eg. localhost:4000
{% endcodeblock %}

##### Autor und Titel

{% codeblock Autor und Tutel - _config.yml lang:diff %}
@@ -2,10 +2,10 @@
 #      Main Configs       #
 # ----------------------- #
 
-url: http://yoursite.com
-title: My Octopress Blog
-subtitle: A blogging framework for hackers.
-author: Your Name
+url: http://uli-heller.github.com
+title: Was ich so treibe...
+subtitle: Linux, Java und Groovy
+author: Uli Heller
 simple_search: http://google.com/search
 description:
{% endcodeblock %}

#### Veröffentlichung auf GitHub

Ziel: Die Octopress-Seiten sollen auf GitHub unter

* http://uli-heller.github.com/

veröffentlicht werden.

##### Vorbereitungen auf GitHub

Auf GitHub muß ein spezielles Repository angelegt werden:

* mein GitHub-Benutzer: "uli-heller"
* neu anzulegendes Repository: "uli-heller.github.com"

In der Liste der eigenen Repositories erscheint dann:

* uli-heller/uli-heller.github.com

Test: Lege in dem Master-Zweig dieses Repositories eine Datei mit Namen

* index.html

an und gib' danach im Browser die URL

* http://uli-heller.github.com

ein. Mit etwas Glück erscheint der Inhalt der "index.html"

##### Anpassungen im Octopress-Verzeichnis

{% codeblock Octopress für Veröffentlichung vorbereiten lang:sh %}
cd octopress
rake setup_github_pages
# Repository url: git@github.com:uli-heller/uli-heller.github.com
rake generate
rake deploy
{% endcodeblock %}

##### Quellverzeichnis zur Sicherung hinzufügen

{% codeblock Sicherung vorbereiten lang:sh %}
git add source
git commit -m "Quelltexte sichern"
{% endcodeblock %}

##### Neue Artikel sichern

Neue Artikel werden mit diesem Befehl auf GitHub gesichert:

{% codeblock Quellverzeichnis sichern lang:sh %}
cd octopress
git commit -m "Sprechende Nachricht mit Änderungsbeschreibungen"
git push origin source
{% endcodeblock %}

##### Neue Veröffentlichungen

Immer dann, wenn neue Artikel veröffentlicht werden sollen, muß man so vorgehen:

{% codeblock Neue Veröffentlichungen lang:sh %}
cd octopress
rake generate
rake deploy
{% endcodeblock %}

#### Folgeinstallation

{% codeblock Folgeinstallation lang:sh %}
git clone  git@github.com:uli-heller/uli-heller.github.com octopress
cd octopress
git checkout source
gem install bundler
bundle install
rake install['uli']
git remote add octopress git://github.com/imathis/octopress.git
git fetch octopress
# ... nachfolgend nur für GitHub-Veröffentlichungen
rm -rf _deploy
git init _deploy
cd _deploy
git remote add -t master -f origin git@github.com:uli-heller/uli-heller.github.com
git checkout master
cd ..
{% endcodeblock %}

Anpassungen
-----------

### Darstellung

{% codeblock Meinen Darstellungsstil aktivieren lang:sh %}
cd octopress
rake install['uli']
{% endcodeblock %}

Zurück zur Standard-Darstellung geht's so:

{% codeblock Standarddarstellung aktivieren lang:sh %}
cd octopress
rake install
{% endcodeblock %}

Ein erster Blog-Eintrag
-----------------------

{% codeblock Ersten Blog-Eintrag erstellen lang:sh %}
$ rake new_post["Octopress"]
$ mkdir -p source/_posts
Creating new post: source/_posts/2012-11-10-octopress.textile
# Datei source/_posts/2012-11-10-octopress.textile editieren
$ rake generate
$ rake preview
# Sichten mit http://localhost:4000
$ git commit -m "Erster Blog-Eintrag ist fertig"
$ git push origin source
{% endcodeblock %}

Probleme
--------

### Offene Probleme

* Wie markiere ich in Blog-Einträgen am besten nachträgliche Änderungen?
* Wie verwende ich include_code in Verbindung mit Textile?
    * https://github.com/imathis/octopress/issues/500
    * `git branch -a --contains ca47041`

### Erledigte Probleme

#### Farben sind recht duster

Die Beschreibung ist obsolet! Verwende besser: `rake install['uli']`!

{% codeblock Hellere Farben - sass/custom/_colors.scss lang:diff %}
uli@uli-hp:~/git/octopress$ diff -u sass/custom/_colors.scss~ sass/custom/_colors.scss
--- sass/custom/_colors.scss~	2012-11-10 19:45:17.000000000 +0100
+++ sass/custom/_colors.scss	2012-11-18 11:21:14.913856809 +0100
@@ -41,3 +41,61 @@
 //$pre-bg: $base03;
 //$pre-border: darken($base02, 5);
 //$pre-color: $base1;
+
+// 2012-11-18
+// http://aijazansari.com/2012/08/27/how-to-customize-octopress-theme/
+// ////////////////////////////////////////
+// change the background colors
+//
+html {
+  background: #fff !important;
+}
+body {
+  > div {
+    background: #fff !important;
+    > div {
+      background: #fff !important;
+      }
+  }
+}
+$main-bg: #ffffff !default;
+$page-bg: #ffffff !default;
+
+// ////////////////////////////////////////
+// change the header colors
+//
+$header-bg: #fff;
+$title-color: #000000 !default;
+$text-color: #333 !default;
+$text-color-light: #777 !default;
+$subtitle-color: darken($header-bg, 58);
+
+// ////////////////////////////////////////
+// change the nav bar
+//
+$nav-bg: #fff;
+$nav-bg-front: #fff;
+$nav-bg-back: #fff;
+$nav-color: darken($nav-bg, 78) !default;
+$nav-color-hover: darken($nav-color, 25) !default;
+$nav-border: darken($nav-bg, 50) !default;
+$nav-border-top: darken($nav-bg, 33) !default;
+$nav-border-bottom: darken($nav-bg, 33) !default;
+$nav-border-left: darken($nav-bg, 11) !default;
+$nav-border-right: lighten($nav-bg, 7) !default;
+
+
+// ////////////////////////////////////////
+// change the footer
+//
+$footer-color: #888 !default;
+$footer-bg: #fff !default;
+$footer-bg-front: #fff !default;
+$footer-bg-back: #fff !default;
+$footer-color: darken($footer-bg, 38) !default;
+$footer-color-hover: darken($footer-color, 10) !default;
+$footer-border-top: lighten($footer-bg, 15) !default;
+$footer-border-bottom: darken($footer-bg, 15) !default;
+$footer-link-color: darken($footer-bg, 38) !default;
+$footer-link-color-hover: darken($footer-color, 25) !default;
+$page-border-bottom: darken($footer-bg, 5) !default;
{% endcodeblock %}

#### Listen sind nicht eingerückt

Die Beschreibung ist obsolet! Verwende besser: `rake install['uli']`!

Die Darstellung von Listen ist unschön. Der Fehler betrifft Listen wie diese:

* Erster Listeneintrag
* Zweiter Listeneintrag

Die Listeneinträge werden zu weit links angeziegt, so dass die "Punkte" links außerhalb des Textbereichs erscheinen.

Korrektur: Editiere sass/custom/_layout.scss wie folgt:

{% codeblock Eingerückte Listen - sass/custom/_layout.scss lang:diff %}
diff -u sass/custom/_layout.scss~  sass/custom/_layout.scss
--- sass/custom/_layout.scss~	2012-11-10 19:45:17.000000000 +0100
+++ sass/custom/_layout.scss	2012-11-18 11:05:43.661813157 +0100
@@ -6,7 +6,7 @@
 //$header-padding-bottom: 1.5em;
 
 //$max-width: 1350px;
-//$indented-lists: true;
+$indented-lists: true;
 
 // Padding used for layout margins
 //$pad-min: 18px;
{% endcodeblock %}

#### Ruby mittels RBENV

Funktioniert nicht, wir verwenden stattdessen RVM!

##### RBENV

{% codeblock RBENV lang:sh %}
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bash_profile
{% endcodeblock %}

##### RUBY

{% codeblock RUBY lang:sh %}
rbenv install 1.9.3-p0
rbenv rehash
{% endcodeblock %}

Danach sollte dann `ruby --version` irgendwas mit 1.9.3 anzeigen, funktioniert aber nicht!

#### YAML und zlib

{% codeblock Fehlermeldung yaml und zlib lang:sh %}
$ gem install bundler
/home/uli/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/yaml.rb:56:in `<top (required)>':
It seems your ruby installation is missing psych (for YAML output).
To eliminate this warning, please install libyaml and reinstall your ruby.
ERROR:  Loading command: install (LoadError)
    cannot load such file -- zlib
ERROR:  While executing gem ... (NameError)
    uninitialized constant Gem::Commands::InstallCommand
{% endcodeblock %}

Lösungsversuch mit libyaml-dev und libz-dev:

{% codeblock yaml und zlib installieren lang:sh %}
sudo apt-get install libyaml-dev libz-dev
rvm reinstall 1.9.3
cd octopress
gem install bundler
{% endcodeblock %}

... funktioniert.

#### OpenSSL

{% codeblock Fehlermeldung OpenSSL lang:sh %}
uli@ubuntu1204:~/octopress$ rake generate
## Generating Site with Jekyll
directory source/stylesheets/ 
   create source/stylesheets/screen.css 
/home/uli/.rvm/gems/ruby-1.9.3-p327/gems/maruku-0.6.0/lib/maruku/input/parse_doc.rb:22:in `<top (required)>': iconv will be deprecated in the future, use String#encode instead.
Configuration from /home/uli/octopress/_config.yml
/home/uli/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/net/https.rb:22:in `require': cannot load such file -- openssl (LoadError)
	from /home/uli/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/1.9.1/net/https.rb:22:in `<top (required)>'
{% endcodeblock %}

Lösungsversuch mit libssl-dev:

{% codeblock libssl-dev installieren lang:sh %}
sudo apt-get install libssl-dev
rvm reinstall 1.9.3
cd octopress
rake generate
{% endcodeblock %}

... funktioniert.
