---
layout: post
author: Uli Heller
published: true
title: "Quilt für mein Debian-Paket von Git"
date: 2013-04-14 12:00
#updated: 2013-02-16 08:00
comments: true
categories: 
- Linux
- Ubuntu
- Packaging
- Quilt
- Git
---

Quilt: Umstellung der Patchverwaltung meines Git-Debian-Paketes auf Quilt
=========================================================================

Mein Git-Debian-Paket verwendet bislang keine vernünftige Patchverwaltung.
Stattdessen werden bei der Erzeugung des Paketes einfach alle Patches
unterhalb von debian/diff der Reihe nach angewandt. Blöderweise fallen so
gescheiterte Patchanwendungen nicht auf, außerdem werden im Source-Paket
teilweise Original-Dateien modifiziert - vermutlich weil einige Patches
nicht sauber zurückgerollt werden.

Also: Ich will Quilt haben!

<!-- more -->

Sichtung des Debian-Paketes von Subversion
------------------------------------------

* Patches liegen unter debian/patches und nicht unter debian/diff
* Es gibt eine Datei namens debian/patches/series, die alle Patches auflistet
* In debian/rules sind einige Änderungen vorzunehmen

Die ersten beiden Punkte sind schnell erledigt:

* `mv debian/diff debian/patches`
* `cd debian/patches; (ls|grep -v series) >series`

Bleibt noch die Anpassung von debian/rules!

Anpassungen an "debian/rules"
-----------------------------

An der Datei "debian/rules" müssen qualitativ diese Änderungen vorgenommen
werden:

* Einbinden der Datei /usr/share/quilt/quilt.make
* Ziele "patch" und "patch-stamp" entfernen
* Ziele "debian/stamp-autogen" und "debian/stamp-configure" neu aufnehmen
  Bei "debian/stamp-configure" wird ein Verweis auf "patches" angelegt
* Verweise auf "patch-stamp" ersetzen durch "$(QUILT_STAMPFN)"
* Im Ziel "clean" diese Änderungen vornehmen:
    * Neue Abhängigkeit zu "unpatch" festlegen
    * Neuer Aufruf: dh_testdir
    * Neuer Aufruf: dh_clean
    * Verweis auf "patches" löschen
    * Manuelle Logik zum Zurücknehmen der Patches entfernen

Die Änderungen sind im nachfolgenden DIFF zusammengefasst.

{% codeblock Anpassungen an debian/rules lang:diff %}
--- ../git-1.8.2.1_ok/debian/rules	2013-04-13 19:55:00.061153212 +0200
+++ debian/rules	2013-04-14 09:36:24.782564149 +0200
@@ -37,19 +37,30 @@
 TMP =$(shell pwd)/tmp
 GIT =$(shell pwd)/debian/git
 
-patch: deb-checkdir patch-stamp
-patch-stamp:
-	cp gitk-git/gitk gitk-git/gitk.uli.orig
-	for i in `ls -1 debian/diff/*.diff debian/diff/*.patch \
-	    2>/dev/null || :`; do \
-	  patch -p1 -N -r- <$$i || test $$? = 1 || exit 1; \
-	done
-	touch patch-stamp
+include /usr/share/quilt/quilt.make
+
+debian/stamp-autogen:	$(QUILT_STAMPFN)
+	$(DONT_BE_ROOT)
+	./autogen.sh
+	touch $@
+
+debian/stamp-configure:	$(QUILT_STAMPFN) debian/stamp-autogen
+	dh_testdir
+	test -e patches || ln -s debian/patches patches
+
+#patch: deb-checkdir patch-stamp
+#patch-stamp:
+#	cp gitk-git/gitk gitk-git/gitk.uli.orig
+#	for i in `ls -1 debian/diff/*.diff debian/diff/*.patch \
+#	    2>/dev/null || :`; do \
+#	  patch -p1 -N -r- <$$i || test $$? = 1 || exit 1; \
+#	done
+#	touch patch-stamp
 
 build: build-arch build-indep
 
 build-arch: deb-checkdir build-arch-stamp
-build-arch-stamp: patch-stamp
+build-arch-stamp: $(QUILT_STAMPFN)
 	-$(CC) -v
 	DESTDIR='$(GIT)' $(MAKE) all $(OPTS)
 	cd contrib/subtree; DESTDIR='$(GIT)' $(MAKE) all $(OPTS)
@@ -66,7 +77,7 @@
 	touch build-arch-stamp
 
 build-indep: deb-checkdir build-indep-stamp
-build-indep-stamp: patch-stamp build-arch-stamp
+build-indep-stamp: $(QUILT_STAMPFN) build-arch-stamp
 	: 'Work around bug #478524'
 	set -e; if test '$(BUILD_DOCS)' = 1; \
 	then \
@@ -74,14 +85,17 @@
 	fi
 	touch build-indep-stamp
 
-clean: deb-checkdir
+clean: deb-checkdir unpatch
+	dh_testdir
+	dh_clean
+	$(RM) patches	
 	$(MAKE) clean $(OPTS)
 	cd contrib/subtree; $(MAKE) clean $(OPTS)
-	! test -e patch-stamp || \
-	  for i in `ls -1r debian/diff/*.diff debian/diff/*.patch \
-	      2>/dev/null || :`; do \
-	    patch -p1 -NR -r- <$$i || test $$? = 1 || exit 1; \
-	  done
+#	! test -e patch-stamp || \
+#	  for i in `ls -1r debian/diff/*.diff debian/diff/*.patch \
+#	      2>/dev/null || :`; do \
+#	    patch -p1 -NR -r- <$$i || test $$? = 1 || exit 1; \
+#	  done
 	rm -rf '$(TMP)'
 	rm -f patch-stamp build-arch-stamp build-indep-stamp
 	rm -rf '$(GIT)' '$(GIT)'-doc '$(GIT)'-arch '$(GIT)'-cvs
{% endcodeblock %}

Neuerzeugung des Paketes
------------------------

Nun kann versucht werden, das Paket neu zu erzeugen mit `dpkg-buildpackage`.
Erwartungsgemäß scheitert die Erzeugung, weil einige Patches nicht sauber
durchlaufen. Korrigiert habe ich das so:

* In "debian/patches/series" folgende Patches deaktiviert:
    * 0005-gitk-use-symbolic-font-names-sans-and-monospace-when-.diff
    * 0006-gitk-Skip-over-AUTHOR-COMMIT_DATE-when-searching-all-.diff
* Bei allen übrigen Patches:
    * `quilt push -f`
    * `quilt refresh`
    * `dpkg-buildpackage`
    * ... so oft wiederholen, bis es durchläuft
