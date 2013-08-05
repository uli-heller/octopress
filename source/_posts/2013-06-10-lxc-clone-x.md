---
layout: post
author: Uli Heller
published: true
title: "LXC: Clonen eines Containers mit Namen 'x'"
date: 2013-06-10 17:40
#updated: 2013-06-10 17:30
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Lxc
---

Seit ich BTRFS-Subvolumes und -Snapshots zum Clonen von
LXC-Containern verwende, erzeuge ich viel mehr dieser
Clones - es geht einfach *sehr* schnell und verbraucht
fast keine Resourcen.

Beim Rum-Clonen bin ich über einen blöden Fehler gestolpert:
Man kann keinen Container clonen, der "x" heißt. Der Vorgang
bricht ab mit der Meldung "ERROR: can't access to '/var/lib/lyc/x'".

<!-- more -->

{% codeblock lang:diff %}
diff -u /usr/bin/lxc-clone~ /usr/bin/lxc-clone
--- lxc-clone~	2013-06-01 16:16:01.000000000 +0200
+++ lxc-clone	2013-06-10 17:46:19.520162107 +0200
@@ -193,7 +193,7 @@
 
 echo "Copying rootfs..."
 oldroot=`grep lxc.rootfs $lxc_path/$lxc_orig/config | awk -F'[= \t]+' '{ print $2 }'`
-rootfs=`echo $oldroot |sed "s/$lxc_orig/$lxc_new/"`
+rootfs=`echo $oldroot |sed "s@$lxc_path/$lxc_orig@$lxc_path/$lxc_new@"`
 
 container_running=True
 lxc-info -n $lxc_orig --state-is RUNNING || container_running=False
{% endcodeblock %}
