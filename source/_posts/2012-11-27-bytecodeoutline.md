---
layout: post
author: Uli Heller
published: true
title: "ASM - BytecodeOutline-Plugin in Eclipse installieren"
date: 2012-11-27 08:00
uupdated: 2012-11-27 06:00
comments: true
categories: 
- Java
- Eclipse
---

BytecodeOutline-Plugin für Eclipse
==================================

Zuerst ein paar Angaben zu meiner Systemumgebung:

* Ubuntu-12.04, 64bit
* Eclipse-jee-juno-SR1
* [de.loskutov.BytecodeOutline_2.4.0.jar](http://forge.ow2.org/projects/asm/)

Ich benötige das Plugin nur temporär. Es soll nicht permanent in meiner Eclipse-Umgebung verfügbar sein.

Neue Eclipse-Installation
-------------------------

{% codeblock Neue Eclipse-Installation lang:sh %}
cd /opt
gzip -cd "${HOME}/Downloads/eclipse/eclipse-jee-juno-SR1-linux-gtk-x86_64.tar.gz |sudo tar xf -
sudo chown -R uli.uli eclipse
sudo mv eclipse eclipse-botst
{% endcodeblock %}

Test der neuen Eclipse-Installation
-----------------------------------

{% codeblock Test der Eclipse-Installation lang:sh %}
/opt/eclipse-botst/eclipse &
# Eclipse wird gestartet
# -> wieder stoppen
{% endcodeblock %}

Einspielen des Plugins
----------------------

{% codeblock Einspielen des Plugins lang:sh %}
# Sicherstellen: Eclipse ist gestoppt
cd /opt/eclipse-botst
cp "${HOME}/Downloads/de.loskutov.BytecodeOutline_2.4.0.jar dropins
{% endcodeblock %}

Kurztest des Plugins
--------------------

* Eclipse starten
* Java-Klasse aus einem bestehenden Eclipse-Projekt selektieren
* Window -> Show View -> Other -> Java -> Bytecode

{% img /images/java/eclipse/bytecode-outline.png 'Eclipse mit Bytecode-View' %}
