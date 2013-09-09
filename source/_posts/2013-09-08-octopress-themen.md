---
layout: post
author: Uli Heller
published: true
title: "Themenwolke für Octopress"
date: 2013-09-08 10:00
comments: true
categories:
- Linux
- Octopress
---

Gestern bin ich über <http://www.ewal.net/2012/09/08/octopress-customizations/>
gestolpert. Darin wird beschrieben, wie man eine Themenwolke in Octopress
einbindet. Eine Themenwolke sieht in etwa so aus:

![Themenwolke](/images/octopress/themenwolke3.png)

In diesem Artikel beschreibe ich, wie ich die Themenwolke eingerichtet habe.

<!-- more -->

## octopress-category-list-master-20130907.zip

Herunterladen von [GitHub](https://github.com/alswl/octopress-category-list)
- [ZIP-Datei](https://github.com/alswl/octopress-category-list/archive/master.zip), meine Kopie liegt [hier](/downloads/code/category-list/octopress-category-list-master-20130907.zip).

{% codeblock Einspielen von octopress-category-list %}
$ unzip -qqd /tmp octopress-category-list-master-20130907.zip
$ cp /tmp/octopress-category-list-master/source/_includes/custom/asides/category* source/_includes/custom/asides/
$ cp /tmp/octopress-category-list-master/plugins/category* plugins/
{% endcodeblock %}

## _config.yml

In der Konfigurationsdatei von Octopress müssen diese Änderungen
durchgeführt werden:

* default_asides: Erweitern um "custom/asides/category_cloud.html"
* category_title_prefix: Setzen auf 'Thema: '

{% codeblock _config.yml lang:diff %}
diff --git a/_config.yml b/_config.yml
index 7371444..47760b3 100644
--- a/_config.yml
+++ b/_config.yml
@@ -52,7 +52,7 @@ titlecase: false       # Converts page and post titles to titlecase
 
 # list each of the sidebar modules you want to include, in the order you want them to appear.
 # To add custom asides, create files in /source/_includes/custom/asides/ and add them to the list like 'custom/asides/custom_aside_name.html'
-default_asides: [asides/recent_posts.html, asides/github.html, asides/delicious.html, asides/pinboard.html, asides/googleplus.html]
+default_asides: [asides/recent_posts.html, custom/asides/category_cloud.html, asides/github.html, asides/delicious.html, asides/pinboard.html, asides/googleplus.html]
 
 # Each layout uses the default asides, but they can have their own asides instead. Simply uncomment the lines below
 # and add an array with the asides you want to use.
@@ -100,3 +100,7 @@ google_analytics_tracking_id:
 
 # Facebook Like
 facebook_like: false
+
+# Category plugin
+category_title_prefix: 'Thema: '
+
{% endcodeblock %}

## source/categories/index.html

Die Datei "source/categories/index.html" wird angelegt, um eine separate
Seite mit allen Themen zur Verfügung zu haben. Bei meiner Variante wird oben
die Themenwolke angezeigt, unten eine alphabetisch sortierte Themenliste.

{% codeblock source/categories/index.html %}
---
layout: page
title: Themen
footer: true
body_id: categories
date: 2013-09-07 09:15
---

<div>
  <ul id="tag-cloud">{% category_cloud %}</ul>
  <ul id="category-list">{% category_list counter:true %}</ul>
</div>
{% endcodeblock %}

## source/_includes/custom/navigation.html

Die Themenseite wird durch Änderung an "source/_includes/custom/navigation.html"
in die Navigation eingebunden:

{% codeblock Änderungen an source/_includes/custom/navigation.html lang:diff %}
diff --git a/source/_includes/custom/navigation.html b/source/_includes/custom/n
index 0ec1963..a7592a0 100644
--- a/source/_includes/custom/navigation.html
+++ b/source/_includes/custom/navigation.html
@@ -1,6 +1,7 @@
 <ul class="main-navigation">
   <li><a href="{{ root_url }}/">Blog</a></li>
   <li><a href="{{ root_url }}/archives/">Archiv</a></li>
+  <li><a href="{{ root_url }}/categories/">Themen</a></li>
   <li><a href="{{ root_url }}/about/">Über mich</a></li>
   <li><a href="{{ root_url }}/impressum/">Impressum</a></li>
{% endcodeblock %}
