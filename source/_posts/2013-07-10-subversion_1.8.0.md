---
layout: post
author: Uli Heller
published: true
title: "Subversion 1.8.0 für Ubuntu-12.04"
date: 2013-07-10 10:00
updatee: 2013-07-12 07:00
comments: true
categories:
- Linux
- Ubuntu
- Precise
- Subversion
---

Vor ein paar Tagen wurde Subversion-1.8.0 veröffentlicht.
Hier meine Versuche, ein Paket für Ubuntu-12.04 zu bauen.

Aktuell kann ich die DEB-Pakete zwar erzeugen und installieren,
leider funktionieren sie aber nicht richtig!

<!-- more -->

## Ausgangpunkt: Subversion-1.7.10

Mein Ausgangspunkt sind die Pakete für Subversion-1.7.10.

    $ cd subversion-1.7.10
    $ uupdate -u ../subversion-1.8.0
    $ cd ../subversion-1.8.0
    $ dpkg-buildpackage

## Erste Hürde: Serf-1.2.1

## Zweite Hürde: Sqlite3-3.7.15

Subversion benötigt eine relativ aktuelle Version von Sqlite3. Die
Standard-Version von Ubuntu-12.04 ist zu alt. Ich habe mir so beholfen:

* Quellpakete von sqlite3-3.7.15.2 aus "raring" runtergeladen
* Ein paar kleine Anpassungen an debian/rules vorgenommen, damit
  tcl85 an der richtigen Stelle ausgelesen wird
* Pakete erzeugen mit `dpkg-buildpackage`

## Dritte Hürde: Python-Test bricht ab

Bei der Ausführung von `dpkg-buildpackage` in "subversion-1.8.0"
werden die Tests mit einer Fehlermeldung abgebrochen:

{% codeblock %}
...
Running testsuite - may take a while.  To disable,
use DEB_BUILD_OPTIONS=nocheck or edit debian/rules.

/usr/bin/make -f debian/rules check-swig-py check-swig-pl check-swig-rb
make[1]: Entering directory `/home/ubuntu/build/subversion/subversion-1.8.0'
set -e; for v in 2.7; do rm -f BUILD/subversion/bindings/swig/python; ln -fs python$v BUILD/subversion/bindings/swig/python; pylib=$(python$v -c 'from distutils import sysconfig; print sysconfig.get_python_lib()');  /usr/bin/make -C BUILD check-swig-py PYTHON=python$v PYVER=$v CLEANUP=1 LC_ALL=C; done
make[2]: Entering directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
if [ "LD_LIBRARY_PATH" = "DYLD_LIBRARY_PATH" ]; then for d in ./subversion/bindings/swig/python/libsvn_swig_py ./subversion/bindings/swig/python/../../../libsvn_*; do if [ -n "$DYLD_LIBRARY_PATH" ]; then LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$d/.libs"; else LD_LIBRARY_PATH="$d/.libs"; fi; done; export LD_LIBRARY_PATH; fi; \
	cd ./subversion/bindings/swig/python; \
	  python2.7 /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/python/tests/run_all.py
...........................................................................................................................
----------------------------------------------------------------------
Ran 123 tests in 301.417s

OK
make[2]: Leaving directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
set -e; for v in 2.7; do rm -f BUILD/subversion/bindings/swig/python; ln -fs python$v-dbg BUILD/subversion/bindings/swig/python; pylib=$(python$v -c 'from distutils import sysconfig; print sysconfig.get_python_lib()');  /usr/bin/make -C BUILD check-swig-py PYTHON=python$v-dbg PYVER=${v}_d PYTHON_INCLUDES=-I/usr/include/python${v}_d CLEANUP=1 LC_ALL=C; done
make[2]: Entering directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
if [ "LD_LIBRARY_PATH" = "DYLD_LIBRARY_PATH" ]; then for d in ./subversion/bindings/swig/python/libsvn_swig_py ./subversion/bindings/swig/python/../../../libsvn_*; do if [ -n "$DYLD_LIBRARY_PATH" ]; then LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$d/.libs"; else LD_LIBRARY_PATH="$d/.libs"; fi; done; export LD_LIBRARY_PATH; fi; \
	cd ./subversion/bindings/swig/python; \
	  python2.7-dbg /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/python/tests/run_all.py
........................Fatal Python error: subversion/bindings/swig/python/svn_client.c:23145 object at 0x399b498 has negative ref count -2604246222170760230
/bin/bash: line 2: 16967 Aborted                 (core dumped) python2.7-dbg /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/python/tests/run_all.py
make[2]: *** [check-swig-py] Error 134
make[2]: Leaving directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
make[1]: *** [check-swig-py] Error 2
make[1]: Leaving directory `/home/ubuntu/build/subversion/subversion-1.8.0'
make: *** [debian/stamp-build-arch] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2
{% endcodeblock %}

Quercheck: subversion-1.8.0.tar.bz2 entpacken und dort dann

* `./configure`
* `make` ... keine Probleme
* `make test` ... "nothing to be done"
* `make check` ... "All tests successful."

      XFAIL: wc_tests.py 6: add file with not-parent symlink
      Summary of test results:
       1909 tests PASSED
       55 tests SKIPPED
       28 tests XFAILED (1 WORK-IN-PROGRESS)
      SUMMARY: All tests successful.

* `make check-swig-py` ... keine Probleme

Ich editiere debian/rules und deaktiviere "call allpydbg" in "check-swig-py".

## Vierte Hürde: Ruby-Tests brechen ab

{% codeblock %}
...
/usr/bin/make -C BUILD check-swig-rb CLEANUP=1 LC_ALL=C
make[2]: Entering directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
if [ "LD_LIBRARY_PATH" = "DYLD_LIBRARY_PATH" ]; then for d in ./subversion/bindings/swig/python/libsvn_swig_rb ./subversion/bindings/swig/python/../../../libsvn_*; do if [ -n "$DYLD_LIBRARY_PATH" ]; then LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$d/.libs"; else LD_LIBRARY_PATH="$d/.libs"; fi; done; export LD_LIBRARY_PATH; fi; \
	cd ./subversion/bindings/swig/ruby; \
          if [ "1" -eq 1 -a "8" -lt 9 ] ; then \
            /usr/bin/ruby1.8 -I /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby \
              /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby/test/run-test.rb \
	      --verbose=normal; \
          else \
	    /usr/bin/ruby1.8 -I /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby \
	      /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby/test/run-test.rb; \
          fi
/home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby/test/util.rb:22:in `require': no such file to load -- ./svn/util (LoadError)
	from /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby/test/util.rb:22
	from /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby/test/run-test.rb:37:in `require'
	from /home/ubuntu/build/subversion/subversion-1.8.0/subversion/bindings/swig/ruby/test/run-test.rb:37
make[2]: *** [check-swig-rb] Error 1
make[2]: Leaving directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
make[1]: *** [check-swig-rb] Error 2
make[1]: Leaving directory `/home/ubuntu/build/subversion/subversion-1.8.0'
make: *** [debian/stamp-build-arch] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2
{% endcodeblock %}

Das habe ich korrigiert durch Änderungen an ./subversion/bindings/swig/ruby/test/run-test.rb:

{% codeblock run-test.rb lang:diff %}
--- subversion/bindings/swig/ruby/test/util.rb~	2013-05-29 04:00:11.000000000 +0000
+++ subversion/bindings/swig/ruby/test/util.rb	2013-07-10 09:22:24.845441319 +0000
@@ -19,7 +19,7 @@
 
 require "fileutils"
 require "pathname"
-require "./svn/util"
+require "svn/util"
 require "tmpdir"
 
 require "my-assertions"
{% endcodeblock %}

## Fünfte Hürde: Verpacken bricht ab wegen fehlenjder Dateien

{% codeblock %}
...
make[1]: Leaving directory `/home/ubuntu/build/subversion/subversion-1.8.0/BUILD'
find debian/tmp/usr/lib/ruby \( -name \*.a -o -name \*.la \) -exec rm -f {} +
cd debian/tmp//usr/lib/x86_64-linux-gnu; for lib in ra fs auth swig; do \
	    rm -f libsvn_${lib}_*.so libsvn_${lib}_*.la; \
	done
cd debian/tmp//usr/lib/x86_64-linux-gnu; rm -f libsvn_swig*.a libsvnjavahl.a libsvnjavahl.la
# Intermediate hack, until we can remove the rest of the .la files.
sed -i  "/dependency_libs/s/=.*/=''/" debian/tmp//usr/lib/x86_64-linux-gnu/*.la
dh_install -s
dh_install: libapache2-svn missing files (debian/tmp/usr/lib/apache2/modules/*.so), aborting
make: *** [debian/stamp-install-arch] Error 2
dpkg-buildpackage: error: fakeroot debian/rules binary gave error exit status 2
{% endcodeblock %}

Das habe ich korrigiert durch Änderungen an ./debian/libapache2-svn.install:

{% codeblock libapache2-svn.install lang:diff %}
ubuntu@ubuntu1204-64-build:~/build/subversion/subversion-1.8.0$ diff -u debian/libapache2-svn.install~ debian/libapache2-svn.install
--- debian/libapache2-svn.install~	2013-07-06 06:31:05.000000000 +0000
+++ debian/libapache2-svn.install	2013-07-10 11:08:06.525738591 +0000
@@ -1,4 +1,4 @@
-debian/tmp/usr/lib/apache2/modules/*.so		usr/lib/apache2/modules
+debian/tmp/usr/libexec/*.so			usr/lib/apache2/modules
 debian/dav_svn.conf                             etc/apache2/mods-available
 debian/dav_svn.load                             etc/apache2/mods-available
 debian/authz_svn.load                           etc/apache2/mods-available
{% endcodeblock %}

Danach kann dann mit `fakeroot debian/rules binary` die Verpackung ohne erneute Kompilierung getestet werden.

## Nochmals komplett: Paketerzeugung läuft durch

Nach den vorigen Änderungen kann die Paketerzeugung mit

{% codeblock %}
dpkg-buildpackage
{% endcodeblock %}

komplett erfolgreich durchgezogen werden!

## Kurztests: Installation und Funktionsweise

{% codeblock %}
$ sudo dpkg -i subversion_1.8.0-3dp12~precise1_amd64.deb libsvn1_1.8.0-3dp12~precise1_amd64.deb libserf1_1.2.1-0dp01~precise1_amd64.deb
$ sudo dpkg -i sqlite3_3.7.15.2-1dp01~precise1_amd64.deb libsqlite3-0_3.7.15.2-1dp01~precise1_amd64.deb
$ svn --version
svn, Version 1.8.0 (r1490375)
   übersetzt am Jul 10 2013, um 11:15:47 auf x86_64-pc-linux-gnu

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
is too old (format 29) to work with client version '1.8.0 (r1490375)' (expects format 31). You need to upgrade the working copy first.
$ svn upgrade
$ svn status
$ svn update
svn: E175009: XML parsing failed: (411 Length Required)
$ svn checkout https://.....
svn: E235000: In file '/home/ubuntu/build/subversion/subversion-1.8.0/subversion/libsvn_client/ra.c' line 647: assertion failed (peg_revnum != SVN_INVALID_REVNUM)
Aborted (core dumped)
{% endcodeblock %}

Also: Leider funktioniert's nicht.

## Zurück zur alten Version

Auf dem Rechner, den ich zum Testen verwendet habe, geht's
so zurück zu den alten Versionen:

{% codeblock %}
$ sudo apt-get install libsqlite3-0=3.7.9* sqlite3=3.7.9*
$ sudo apt-get install subversion=1.7.10* libsvn1=1.7.10*
$ sudo apt-get install libserf1=1.0*
{% endcodeblock %}

Auf dem Rechner, den ich zum Bauen verwendet habe, geht's
so zurück zu den alten Versionen:

{% codeblock %}
$ sudo apt-get install libsqlite3-0=3.7.9* sqlite3=3.7.9*
$ sudo apt-get install libserf1=1.0*
{% endcodeblock %}
