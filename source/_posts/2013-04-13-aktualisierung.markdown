---
layout: post
title: "Aktualisierung"
date: 2013-04-13 08:05
author: Uli Heller
categories: 
---

Aktualisierung der Arbeitsumgebung
==================================

In diesem Artikel beschreibe ich, wie man seine Arbeitsumgebung auf
den neuesten Stand bringt. Konkret:

* rvm-1.16.20 auf 1.19
* ruby-1.9.3 auf 2.0

<!-- more -->

RVM
---

{% codeblock Aktualisierung von RVM lang:sh %}
rvm get stable
# ... Upgrade of RVM in /home/uli/.rvm/ is complete.
# ... RVM reloaded!
{% endcodeblock %}

Ruby und RubyGems
-----------------

{% codeblock Aktualisierung von Ruby lang:sh %}
cd ~/git/octopress  # bringt eine Warnung bzgl. der Ruby-Version
rvm install ruby-2.0.0p0
bundle install
{% endcodeblock %}
