---
layout: post
author: Uli Heller
published: true
title: "Perl: CPAN ohne Root"
date: 2013-06-10 06:00
#updated: 2013-01-10 07:30
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Perl
---

Manchmal möchte man Perl-Module auf einem Rechner installieren,
ohne dass man Root-Rechte dafür hat - oder umgekehrt: Man
möchte Leuten ermöglichen, auf einem Rechner mit Perl-Modulen
rumzuspielen, für den sie keinen Root-Zugriff haben. Die nachfolgende
Beschreibung bezieht sich auf Ubuntu-12.04.

<!-- more -->

## Vorbereitung: Diverse Pakete installieren

Für diesen Abschnitt wird "root"-Zugriff benötigt!

    sudo apt-get install perl-modules
    sudo apt-get install liblocal-lib-perl
    sudo apt-get install make
    sudo apt-get install build-essential

## Grundeinrichtung von CPAN

Für die Grundeinrichtung von CPAN wird als "normaler" Benutzer
das Kommando `cpan` ausgeführt. Bei der Ersteinrichtung werden
viele Fragen gestellt, die man am besten einfach "Abnickt".
Wenn was schief läuft: `rm -rf ~/.cpan` und erneut starten!

Hier das Konsolen-Log der Grundeinrichtung:

{% codeblock Grundeinrichtung von CPAN %}
Sorry, we have to rerun the configuration dialog for CPAN.pm due to
some missing parameters. Configuration will be written to
 <</home/ubuntu/.cpan/CPAN/MyConfig.pm>>


CPAN.pm requires configuration, but most of it can be done automatically.
If you answer 'no' below, you will enter an interactive dialog for each
configuration option instead.

Would you like to configure as much as possible automatically? [yes] 

 <install_help>

Warning: You do not have write permission for Perl library directories.

To install modules, you need to configure a local Perl library directory or
escalate your privileges.  CPAN can help you by bootstrapping the local::lib
module or by configuring itself to use 'sudo' (if available).  You may also
resolve this problem manually if you need to customize your setup.

What approach do you want?  (Choose 'local::lib', 'sudo' or 'manual')
 [local::lib] 

ALERT: 'make' is an essential tool for building perl Modules.
Please make sure you have 'make' (or some equivalent) working.

Autoconfigured everything but 'urllist'.

Now you need to choose your CPAN mirror sites.  You can let me
pick mirrors for you, you can select them from a list or you
can enter them by hand.

Would you like me to automatically choose some CPAN mirror
sites for you? (This means connecting to the Internet) [yes] 

Trying to fetch a mirror list from the Internet
Fetching with HTTP::Tiny:
http://www.perl.org/CPAN/MIRRORED.BY

Looking for CPAN mirrors near you (please be patient)
.................................. done!

New urllist
  http://httpupdate37.cpanel.net/CPAN/
  http://cpan.mirrors.uk2.net/
  http://ftp.spbu.ru/CPAN/

Autoconfiguration complete.

Attempting to bootstrap local::lib...

Writing /home/ubuntu/.cpan/CPAN/MyConfig.pm for bootstrap...
commit: wrote '/home/ubuntu/.cpan/CPAN/MyConfig.pm'
Fetching with HTTP::Tiny:
http://httpupdate37.cpanel.net/CPAN/authors/01mailrc.txt.gz
Going to read '/home/ubuntu/.cpan/sources/authors/01mailrc.txt.gz'
............................................................................DONE
Fetching with HTTP::Tiny:
http://httpupdate37.cpanel.net/CPAN/modules/02packages.details.txt.gz
Going to read '/home/ubuntu/.cpan/sources/modules/02packages.details.txt.gz'
  Database was generated on Mon, 10 Jun 2013 03:53:02 GMT
  HTTP::Date not available
..............
  New CPAN.pm version (v2.00) available.
  [Currently running version is v1.960001]
  You might want to try
    install CPAN
    reload cpan
  to both upgrade CPAN.pm and run the new version without leaving
  the current session.


..............................................................DONE
Fetching with HTTP::Tiny:
http://httpupdate37.cpanel.net/CPAN/modules/03modlist.data.gz
Going to read '/home/ubuntu/.cpan/sources/modules/03modlist.data.gz'
............................................................................DONE
Going to write /home/ubuntu/.cpan/Metadata
Running make for E/ET/ETHER/local-lib-1.008010.tar.gz
Fetching with HTTP::Tiny:
http://httpupdate37.cpanel.net/CPAN/authors/id/E/ET/ETHER/local-lib-1.008010.tar.gz
Fetching with HTTP::Tiny:
http://httpupdate37.cpanel.net/CPAN/authors/id/E/ET/ETHER/CHECKSUMS
Checksum for /home/ubuntu/.cpan/sources/authors/id/E/ET/ETHER/local-lib-1.008010.tar.gz ok
---- Unsatisfied dependencies detected during ----
----      ETHER/local-lib-1.008010.tar.gz     ----
    ExtUtils::MakeMaker [build_requires]
Running make test
  Make had some problems, won't test
  Delayed until after prerequisites
Running make install
  Make had some problems, won't install
  Delayed until after prerequisites
Tried to deactivate inactive local::lib '/home/ubuntu/perl5'

local::lib is installed. You must now add the following environment variables
to your shell configuration files (or registry, if you are on Windows) and
then restart your command line shell and CPAN before installing modules:

Use of uninitialized value $deactivating in numeric eq (==) at /usr/share/perl5/local/lib.pm line 354.
Use of uninitialized value $deactivating in numeric eq (==) at /usr/share/perl5/local/lib.pm line 356.
Use of uninitialized value $interpolate in numeric eq (==) at /usr/share/perl5/local/lib.pm line 366.
export PERL_LOCAL_LIB_ROOT="/home/ubuntu/perl5";
export PERL_MB_OPT="--install_base /home/ubuntu/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/ubuntu/perl5";
export PERL5LIB="/home/ubuntu/perl5/lib/perl5/i686-linux-gnu-thread-multi-64int:/home/ubuntu/perl5/lib/perl5";
export PATH="/home/ubuntu/perl5/bin:$PATH";

Would you like me to append that to /home/ubuntu/.bashrc now? [yes] 

commit: wrote '/home/ubuntu/.cpan/CPAN/MyConfig.pm'

You can re-run configuration any time with 'o conf init' in the CPAN shell
Terminal does not support AddHistory.

cpan shell -- CPAN exploration and modules installation (v1.960001)
Enter 'h' for help.

cpan[1]> quit
{% endcodeblock %}

## Moose installieren

Nun installiere ich das Perl-Modul Moose via CPAN. Läuft ohne Probleme durch!

{% codeblock Moose installieren mit CPAN lang:sh %}
$ cpan install Moose
...
Installing /home/ubuntu/perl5/man/man3/Moose::Manual::Classes.3pm
Installing /home/ubuntu/perl5/bin/moose-outdated
Appending installation info to /home/ubuntu/perl5/lib/perl5/i686-linux-gnu-thread-multi-64int/perllocal.pod
  ETHER/Moose-2.0802.tar.gz
  /usr/bin/make install  -- OK
{% endcodeblock %}
