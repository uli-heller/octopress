---
layout: post
author: Uli Heller
published: true
title: "Git-Svn: Absturz bei 'dcommit'"
date: 2013-08-08 08:00
#updated: 2013-07-12 07:00
comments: true
categories:
- Linux
- Ubuntu
- Precise
- Subversion
---

Seit der Aktualisierung auf Subversion-1.8.1 gibt es immer wieder
Fehler bei der Ausführung von Git-Svn-Kommandos. Beobachtet habe ich
die Fehler bei

* `git svn dcommit`
* `git svn rebase`
* `git svn clone`

Der Fehler tritt nur beim "Aufräumen" auf, d.h. nachdem das betreffende
Kommando abgearbeitet ist und der Git-Svn-Prozess nur noch beendet werden
muß. Er tritt auch nur auf, wenn Daten über die Leitung geschickt werden,
also wenn:

* das lokale Git-Repo geändert wurde (dcommit)
* das Svn-Repository geändert wurde (rebase)

Wenn man den Fehler einfach ignoriert, kann man "normal" weiterarbeiten.

<!-- more -->

## Reproduzieren des Problems

Am einfachsten läßt sich das Problem reproduzieren, wenn man ein
Subversion-Repository mit Testdaten verfügbar hat. Bei mir hat das den Namen
"sandbox".

Ach ja: Das Subversion-Repository muß via "https://..." angesprochen werden.
Mit einem lokalen Subversion-Repository,
das mittels "file://..." angesprochen wird,
tritt das Problem nicht auf!
 
{% codeblock Clonen des Svn-Repositories lang:sh %}
~/git$ git svn clone --stdlayout https://{servername}/{pfad}/sandbox
Initialisierte leeres Git-Projektarchiv in .../git/sandbox/.git/
r1 = 7ebd17bca2c5e3ead4816e93371d695eb3e19a36 (refs/remotes/trunk)
	A	bug-fix.ticket18
r2 = 77410a5f40f2eaeaf666f9fbda5261a521acb33f (refs/remotes/trunk)
	M	bug-fix.ticket18
...
r81 = 32ebfb3669331a5a5b60d27dbf54e0b6c7a601da (refs/remotes/trunk)
Checked out HEAD:
  https://83.236.132.107/svn/sandbox/trunk r81
creating empty directory: baumkonflikt/dir1
creating empty directory: danyi_tests
error: git-svn died of signal 11
~/git$ cd sandbox
{% endcodeblock %}

Hierbei tritt der Fehler auf. Der Ablauf ist aber verhältnismässig aufwändig,
weil immer das ganze Repository kopiert wird.

{% codeblock Neue Datei git-svn-absturz.txt lang:sh %}
~/git/sandbox$ date >>git-svn-absturz.txt
~/git/sandbox$ git add git-svn-absturz.txt
~/git/sandbox$ git commit -m "Aktualisiert: git-svn-absturz.txt" .
[master b984d2a] Aktualisiert: git-svn-absturz.txt
 1 file changed, 1 insertion(+)
 create mode 100644 git-svn-absturz.txt
~/git/sandbox$ git svn dcommit
Committing to https://83.236.132.107/svn/sandbox/trunk ...
	A	git-svn-absturz.txt
Committed r82
	A	git-svn-absturz.txt
r82 = 610e72f25af787a95e3d2bc6c243bcdef720c40d (refs/remotes/trunk)
No changes between b984d2a7c45c9b7e94fe5edc3b765b84a3b2ed7d and refs/remotes/trunk
Resetting to the latest refs/remotes/trunk
error: git-svn died of signal 11
{% endcodeblock %}

Der Fehler ist erneut aufgetreten. Der Ablauf ist auch ungeeignet, weil ich
nicht für jeden Test eine neue Datei anlegen möchte.

{% codeblock Einfache Reproduktion des Problems lang:sh %}
~/git/sandbox$ date >>git-svn-absturz.txt
~/git/sandbox$ git commit -m "Aktualisiert: git-svn-absturz.txt" .
[master 10629a2] Aktualisiert: git-svn-absturz.txt
 1 file changed, 1 insertion(+)
~/git/sandbox$ git svn dcommit
Committing to https://83.236.132.107/svn/sandbox/trunk ...
	M	git-svn-absturz.txt
Committed r83
	M	git-svn-absturz.txt
r83 = 5260be6684059d7b8416c011dfa644d837f317a9 (refs/remotes/trunk)
No changes between 10629a268ed877ba48fa2a70ed387b04bacd18cb and refs/remotes/trunk
Resetting to the latest refs/remotes/trunk
error: git-svn died of signal 11
{% endcodeblock %}

Der Fehler ist erneut aufgetreten. Der Ablauf ist schnell wiederholt
durchführbar.

Hier nochmal die abzusetzenden Befehle ohne Ausgaben zur einfachen
Wiederholung mit "Ausschneiden und Einfügen":

{% codeblock Einfache Reproduktion - abzusetzende Befehle lang:sh %}
date >>git-svn-absturz.txt
git commit -m "Aktualisiert: git-svn-absturz.txt" .
git svn dcommit
{% endcodeblock %}

## Analyse

### strace

{% codeblock Reproduktion mit 'strace' lang:sh %}
date >>git-svn-absturz.txt
git commit -m "Aktualisiert: git-svn-absturz.txt" .
strace git svn dcommit
{% endcodeblock %}

Diese Ausgaben werden geliefert:

{% codeblock Ausgabe von 'strace git svn' lang:sh %}
...
	M	git-svn-absturz.txt
Committed r84
	M	git-svn-absturz.txt
r84 = af8102dc59c40c47b56a404b5ceffa7c5892bc06 (refs/remotes/trunk)
No changes between 191f43c2a02d86825f946de62f6fd8f56b5aa74b and refs/remotes/trunk
Resetting to the latest refs/remotes/trunk
[{WIFSIGNALED(s) && WTERMSIG(s) == SIGSEGV && WCOREDUMP(s)}], 0, NULL) = 14979
--- SIGCHLD (Child exited) @ 0 (0) ---
write(2, "error: git-svn died of signal 11"..., 33error: git-svn died of signal 11
) = 33
exit_group(139)                         = ?
{% endcodeblock %}

Dieser Trace hat wenig Aussagekraft, weil einfach nur ein Unterprozess
anstürzt. Nun könnte man den Test nochmals laufen lassen mit 'strace -F'
oder wir füttern 'strace' direkt mit 'git-svn':

{% codeblock Reproduktion mit 'strace' und 'git-svn' lang:sh %}
date >>git-svn-absturz.txt
git commit -m "Aktualisiert: git-svn-absturz.txt" .
strace /usr/lib/git-core/git-svn dcommit
{% endcodeblock %}

Dies führt zu folgender Ausgabe:

{% codeblock Ausgabe von 'strace git-svn' lang:sh %}
execve("/usr/lib/git-core/git-svn", ["/usr/lib/git-core/git-svn", "dcommit"], [/* 59 vars */]) = 0
brk(0)                                  = 0x25fd000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
...
chmod(".git/Git_zUlsP8", 0600)          = 0
unlink(".git/Git_zUlsP8")               = 0
close(14)                               = 0
close(4294967295)                       = -1 EBADF (Bad file descriptor)
close(13)                               = 0
munmap(0x7f03f9fc3000, 2113912)         = 0
munmap(0x7f03fb641000, 2105608)         = 0
...
munmap(0x7f0402cd6000, 8192)            = 0
munmap(0x7f0402cf3000, 8192)            = 0
munmap(0x7f0402d03000, 8192)            = 0
munmap(0x7f0402cef000, 8192)            = 0
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV (core dumped) +++
{% endcodeblock %}

### Devel:Trace

#### Perl-Modul Devel::Trace installieren

`sudo apt-get install libdevel-trace-perl`

#### Test

{% codeblock Reproduktion mit 'Devel::Trace' und 'git-svn' lang:sh %}
date >>git-svn-absturz.txt
git commit -m "Aktualisiert: git-svn-absturz.txt" .
perl -d::Trace -f /usr/lib/git-core/git-svn dcommit
{% endcodeblock %}

Dabei wird diese Ausgabe geliefert:

{% codeblock Ausgabe mit 'Devel::Trace' lang:sh %}
...
>> /usr/share/perl5/Git/SVN.pm:1659: 	unmemoize_svn_mergeinfo_functions();
>> /usr/share/perl5/Git/SVN.pm:1626: 		return if not $memoized;
>> /usr/share/perl5/Git/SVN.pm:85: 	unlink keys %LOCKFILES if %LOCKFILES;
>> /usr/share/perl5/Git/SVN.pm:86: 	unlink keys %INDEX_FILES if %INDEX_FILES;
>> /usr/lib/perl5/SVN/Core.pm:390:     $globaldestroy = 1;
>> /usr/lib/perl5/SVN/Core.pm:58:     SVN::_Core::apr_terminate();
Speicherzugriffsfehler (Speicherabzug geschrieben)
{% endcodeblock %}

Richtig "weiter" kommen wir damit nicht - "apr_terminate()" ist
eine C-Funktion, die per SWIG in Perl eingebunden ist.

## Korrekturversuche

### Neueste Version von serf-1.2.1

{% codeblock Patch erzeugen lang:sh %}
$ git svn clone --stdlayout http://serf.googlecode.com/svn
...
r2111 = 6e0d690806e4796d2d698e5fd6a33b91832b9fd3 (refs/remotes/trunk)
	M	auth/auth_spnego.c
	M	outgoing.c
r2112 = 40194aec74ce32ba844aafc0a5dbdda334f2abfb (refs/remotes/trunk)
Checked out HEAD:
  http://serf.googlecode.com/svn/trunk r2112
$ mv svn serf
$ cd serf
$ git diff remotes/tags/1.2.1 remotes/1.2.x >serf-1.2.1-r2112.patch
{% endcodeblock %}

Den dabei erzeugten Patch habe ich in die Patch-Serie von
SERF aufgenommen und ein neues SERF-Paket erzeugt und dieses
dann installiert mit

* `sudo dpkg -i libserf1_1.2.1-0dp04~precise1_amd64.deb` 

Ein Nachtest ergibt: Keine Besserung.

### Neueste Version von apr-1.4.8

Der übliche Ablauf mittels

    * `uupdate -u ../apr-1.4.8.tar.gz`
    * `cd ../apr-1.4.8`
    * `dpkg-buildpackage`

funktioniert nicht - es werden viele fehlende Funktionen angemeckert von 
`dh_makeshlibs`/`dpkg-gensymbols`:

{% codeblock Fehlende Funktionen %}
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA384_Data@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA384_End@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA384_Final@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA384_Init@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA384_Update@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_Data@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_End@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_Final@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_Init@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_Last@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_Transform@Base 1.2.7
+#MISSING: 1.4.8-0dp01~precise1# apr__SHA512_Update@Base 1.2.7
{% endcodeblock %}

Nach Anpassung von .../debian/symbols.common funktioniert's. Klar, die neue
Version ist nicht so richtig kompatibel zur alten Version. Muß ich im
Hinterkopf behalten.

Ein Nachtest ergibt: Keine Besserung, `git-svn` stürzt noch immer ab.
Also: Wieder die alte Version installieren: `sudo apt-get install libapr1=1.4.6\*`.
