---
layout: post
author: Uli Heller
published: true
title: "Markdown nach PDF wandeln"
date: 2013-05-17 21:00
#updated: 2013-05-12 19:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Markdown
- PDF
---


Hier kurz eine Beschreibung, wie man Markdown nach PDF
konvertieren kann auf Basis von

* Kramdown
* Gimli
* Context
* Pandoc

<!-- more -->

Kramdown
--------

* RVM muß installiert sein
* Ruby-2.0 muß verfügbar sein
* `apt-get install texlive-latex-recommended texlive-latex-extra`

Danach kann "kramdown" mit `gem install kramdown` installiert werden.
Die Erzeugung einer PDF-Datei geht dann so:

    kramdown --template document -o latex README-markdown.md  >README-markdown.tex
    pdftex README-markdown.tex

Tabellen scheinen von "kramdown" richtig in LaTeX-Tabellen umgesetzt
zu werden.

Probleme gibt's manchmal noch bei der Einbindung von Bildern.
Diese werden viel zu breit dargestellt. Abhilfe schafft ein eigenes
LaTeX-Template:

    cp ~/.rvm/gems/ruby-2.0.0-p0/gems/kramdown-1.0.1/data/kramdown/document.latex .
    # Einfügen von
    # \setkeys{Gin}{width=\textwidth} % Alle Bilder auf Seitenbreite skalieren
    # direkt vor \begin{document}
    mv document.latex ulidoc.latex
    kramdown --template ulidoc -o latex README-markdown.md  >README-markdown.tex
    pdftex README-markdown.tex

Nun werden die Bilder schön auf Seitenbreite skaliert.

Außerdem kann man mit diesen Änderungen am LaTeX-Template noch ein
Inhaltsverzeichnis erzeugen:

* Unmittelbar vor "\usepackage[T1]{fontenc}" folgende Zeile einfügen:

    \usepackage[ngerman]{babel}

* Die Zeile "\usepackage{hyperref}" ersetzen durch

    \usepackage[bookmarks=true,bookmarksnumbered=true]{hyperref}

* (Optional) Unmittelbar nach "\begin{document}" diese Zeile einfügen:

    \tableofcontents

  Damit wird dann auch im "Haupttext" ein Inhaltsverzeichnis erzeugt.

Gimli
-----

* RVM muß installiert sein
* Ruby-2.0 muß verfügbar sein
* `apt-get install wkhtmltopdf`
* `apt-get install libxml2-dev`
* `apt-get install libxslt-dev`

Danach kann Gimli mit `gem install gimli` installiert werden.
Die Erzeugung einer PDF-Datei geht dann so:

    gimli -f README-markdown.md

Oder mittels "bin/md2pdf-gimli.sh" so:

    ./bin/md2pdf-gimli.sh README-markdown.md

Leider kommt Gimli nicht mit Markdown-Tabellen zurecht!

Pandoc
------

Zunächst muß das Programme "pandoc" installiert
werden:

    sudo apt-get install pandoc

Nun benötigt man noch das Skript "bin/md2pdf-pandoc.sh" und ein
Markdown-Dokument, beispielsweise  "README-markdown.md".

Eine PDF-Datei erzeugt man dann mit

    ./bin/md2pdf-pandoc.sh README-markdown.md

Die PDF-Datei hat den Namen "README-markdown.pdf".

Leider kommt Pandoc in der Version 1.9 nicht mit Markdown-Tabellen zurecht,
die Version 1.11 soll dies können!

Context
-------

Zunächst müssen die Programme "context" und "pandoc" installiert
werden:

    sudo apt-get install context
    sudo apt-get install pandoc

Nun benötigt man noch das Skript "bin/md2pdf-context.sh" und ein
Markdown-Dokument, beispielsweise  "README-markdown.md".

Eine PDF-Datei erzeugt man dann mit

    ./bin/md2pdf-context.sh README-markdown.md

Die PDF-Datei hat den Namen "README-markdown.pdf".

Context erzeugt ein hübsches PDF-Inhalts-Verzeichnis.
Leider kommt Context nicht mit Markdown-Tabellen zurecht!
