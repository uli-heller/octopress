---
layout: post
title: "Octopress-Fehler: Liquid Exception: undefined method `sort!' for nil:NilClass in post"
date: 2013-08-04 19:00
#updated: 2013-05-04 10:00
comments: false
author: Uli Heller
toc: true
categories: 
- Octopress
---

Beim Ausführen von `rake generate` erscheint die Fehlermeldung:

    Liquid Exception: undefined method `sort!' for nil:NilClass in post
    .../octopress/plugins/category_generator.rb:157:in `category_links'

<!-- more -->

Die Korrektur erfolgt bspw. durch diese Änderung:

{% codeblock Änderung an ../pligins/category_generator.rb lang:diff %}
diff --git a/plugins/category_generator.rb b/plugins/category_generator.rb
index a49c429..63dbf97 100644
--- a/plugins/category_generator.rb
+++ b/plugins/category_generator.rb
@@ -153,6 +153,7 @@ ERR
     # Returns string
     #
     def category_links(categories)
+     if categories != nil
       categories = categories.sort!.map { |c| category_link c }
 
       case categories.length
@@ -163,6 +164,7 @@ ERR
       else
         "#{categories[0...-1].join(', ')}, #{categories[-1]}"
       end
+     end
     end
 
     # Outputs a single category as an <a> link.
{% endcodeblock %}
