---
layout: post
author: Uli Heller
published: true
title: "Markdowneditor in Eclipse"
date: 2013-07-03 08:00
comments: true
categories:
- Eclipse
- Kepler
- Markdown
---

Gemäß <https://bugs.eclipse.org/bugs/show_bug.cgi?id=329528>
sollte Markdown von Eclipse unterstützt werden. Leider gibt's
in Eclipse-4.3 (Kepler) keine Spur davon...

<!-- more -->

Ich verwende die meiste Zeit die "Eclipse IDE for Java EE Developers".
Da sind die Wiki-Edit-Tools gleich mit enthalten. Eine Datei im
.textile-Format kann problemlos editiert werden, leider aber keine
im .markdown-Format.

Abhilfe schafft die Installation der "Mylyn Docs" von
<http://download.eclipse.org/mylyn/snapshots/nightly/docs/>.
Ich habe einfach alle "Mylyn Docs Features" installiert, Eclipse neu
gestartet und danach wird bei "Rechts-Klick" in "Markup Language"
auch Markdown angezeigt.
