---
layout: post
author: Uli Heller
published: yes
title: "Octopress - Liquid error: can’t convert nil into String"
date: 2013-07-20 07:00
#updated: 2012-11-25 12:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Ruby
- Blog
- Octopress
---

Beim Einbinden von Dateien in einen Octopress-Blog-Eintrag sehe ich immer mal wieder
Fehlermeldungen wie diese:

    Liquid error: can’t convert nil into String

Sie tauchen immer dann auf, wenn ich Dateien ohne Extension mittels `include_code`
einbinde:

    {{ "{% include_code redmine/passenger/passenger" }} %}

<!-- more -->

## Einige Tests

### Wie sieht's mit der Version von Github/master aus?

{% codeblock lang:sh %}
$ git clone https://github.com/imathis/octopress.git
Klone nach 'octopress'...
remote: Counting objects: 10661, done.
remote: Compressing objects: 100% (4588/4588), done.
remote: Total 10661 (delta 5839), reused 9830 (delta 5212)
Empfange Objekte: 100% (10661/10661), 2.30 MiB | 773.00 KiB/s, done.
Löse Unterschiede auf: 100% (5839/5839), done.
Checking connectivity... done

$ cd octopress/
You are using '.rvmrc', it requires trusting, it is slower and it is not compatible with other ruby managers,
you can switch to '.ruby-version' using 'rvm rvmrc to [.]ruby-version'
or ignore this warnings with 'rvm rvmrc warning ignore .../octopress/.rvmrc',
'.rvmrc' will continue to be the default project file in RVM 1 and RVM 2,
to ignore the warning for all files run 'rvm rvmrc warning ignore all.rvmrcs'.

********************************************************************************
* NOTICE                                                                       *
********************************************************************************
* RVM has encountered a new or modified .rvmrc file in the current directory,  *
* this is a shell script and therefore may contain any shell commands.         *
*                                                                              *
* Examine the contents of this file carefully to be sure the contents are      *
* safe before trusting it!                                                     *
* Do you wish to trust '.../octopress/.rvmrc'?                                 *
* Choose v[iew] below to view the contents                                     *
********************************************************************************
y[es], n[o], v[iew], c[ancel]> yes
Using .../.rvm/gems/ruby-1.9.3-p392

$ bundle install
Fetching gem metadata from https://rubygems.org/........
Fetching gem metadata from https://rubygems.org/..
Resolving dependencies...
Using rake (0.9.2.2) 
Using RedCloth (4.2.9) 
Using chunky_png (1.2.5) 
Using fast-stemmer (1.0.1) 
Using classifier (1.3.3) 
Using fssm (0.2.9) 
Installing sass (3.2.9) 
Installing compass (0.12.2) 
Using directory_watcher (1.4.1) 
Installing haml (3.1.7) 
Installing kramdown (0.13.8) 
Using liquid (2.3.0) 
Using syntax (1.0.0) 
Installing maruku (0.6.1) 
Using posix-spawn (0.3.6) 
Installing yajl-ruby (1.1.0) 
Installing pygments.rb (0.3.4) 
Installing jekyll (0.12.0) 
Installing rack (1.5.2) 
Installing rack-protection (1.5.0) 
Using rb-fsevent (0.9.1) 
Installing rdiscount (2.0.7.3) 
Using rubypants (0.2.0) 
Installing sass-globbing (1.0.0) 
Installing tilt (1.3.7) 
Installing sinatra (1.4.2) 
Using stringex (1.4.0) 
Using bundler (1.3.5) 
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.

$ rake install
## Copying classic theme into ./source and ./sass
mkdir -p source
cp -r .themes/classic/source/. source
mkdir -p sass
cp -r .themes/classic/sass/. sass
mkdir -p source/_posts
mkdir -p public

$ rake generate
## Generating Site with Jekyll
directory source/stylesheets/ 
   create source/stylesheets/screen.css 
Configuration from .../octopress/_config.yml
Building site: source -> public
Successfully generated site: source -> public

$ mkdir -p source/downloads/code

$ echo "Uli war da" >source/downloads/code/mytest

$ mkdir -p source/downloads/code/redmine/passenger

$ cp .../source/downloads/code/redmine/passenger/passenger source/downloads/code/redmine/passenger/.

{% endcodeblock %}

Jetzt noch ein Testdokument anlegen:

{% codeblock .../source/_posts/2013-07-20-octopress.md lang:text %}
---
layout: post
author: Uli Heller
published: yes
title: "Octopress-Test"
date: 2013-07-20 07:00
comments: true
---

Test:

{{ "{% include_code mytest" }} %}

Test2:

{{ "{% include_code redmine/passenger/passenger" }} %}
{% endcodeblock %}

Sichten mit

* `rake preview`
* Browser: <http://localhost:4000>

Sieht absolut OK aus, der Fehler tritt nicht auf!

### Wie sieht's mit der Version von Github/site-2.1 aus?

Mit der Version von Github/site-2.1 tritt der Fehler genauso auf wie bei mir.
Er ist dort also nicht korrigiert.

### Wie sieht's mit der Version von Github/3.0 aus?

Scheint komplett andersartig zu funktionieren - komme damit momentan nicht klar.

### Wie sieht's mit der Version von Github/source-2.1 aus?

Der Zweig "source-2.1" existiert auf Github nicht mehr!

## Weiteres Vorgehen

Für mich sieht's so aus, als wäre das Aufsetzen auf "source-2.1" eine echt blöde
Entscheidung gewesen. Werde mein Octopress wohl in nächster Zeit umstellen müssen
auf "master".
