---
layout: post
author: Russ Cox
published: true
title: "UTF-8: Bits, Bytes, and Benefits"
date: 2010-03-05 00:00
updated: 2013-01-02 00:00
comments: true
---

UTF-8: Bits, Bytes, and Benefits
================================

copied from <http://research.swtch.com/utf8> where it has been posted on Friday, March 5, 2010.  

UTF-8 is a way to encode Unicode code points—integer values from 0 through 10FFFF—into a byte stream, and it is far simpler than many people realize. The easiest way to make it confusing or complicated is to treat it as a black box, never looking inside. So let's start by looking inside. Here it is:

<table>
  <tr>
   <th>Unicode code points</th>
   <th>UTF-8 encoding (binary)</th>
  </tr>
  <tr>
   <td>00-7F	(7 bits)</td>
   <td>0tuvwxyz</td>
  </tr>
  <tr>
    <td>0080-07FF (11 bits)</td>
    <td>110pqrst 10uvwxyz</td>
  </tr>
  <tr>
    <td>0800-FFFF (16 bits)</td>
    <td>1110jklm 10npqrst 10uvwxyz</td>
  </tr>
  <tr>
    <td>010000-10FFFF (21 bits)</td>
    <td>11110efg 10hijklm 10npqrst 10uvwxyz</td>
  </tr>
</table>

The convenient properties of UTF-8 are all consequences of the choice of encoding.

1. All ASCII files are already UTF-8 files.
   The first 128 Unicode code points are the 7-bit ASCII character set, and UTF-8 preserves their one-byte encoding.
2. ASCII bytes always represent themselves in UTF-8 files. They never appear as part of other UTF-8 sequences.
   All the non-ASCII UTF-8 sequences consist of bytes with the high bit set, so if you see the byte 0x7A in a UTF-8 file, you can be sure it represents the character z.
   ASCII bytes are always represented as themselves in UTF-8 files. They cannot be hidden inside multibyte UTF-8 sequences.
3. The ASCII z 01111010 cannot be encoded as a two-byte UTF-8 sequence 11000001 10111010. Code points must be encoded using the shortest possible sequence. A corollary is that decoders must detect long-winded sequences as invalid. In practice, it is useful for a decoder to use the Unicode replacement character, code point FFFD, as the decoding of an invalid UTF-8 sequence rather than stop processing the text.
4. UTF-8 is self-synchronizing.
  Let's call a byte of the form 10xxxxxx a continuation byte. Every UTF-8 sequence is a byte that is not a continuation byte followed by zero or more continuation bytes. If you start processing a UTF-8 file at an arbitrary point, you might not be at the beginning of a UTF-8 encoding, but you can easily find one: skip over continuation bytes until you find a non-continuation byte. (The same applies to scanning backward.)
5. Substring search is just byte string search.
  Properties 2, 3, and 4 imply that given a string of correctly encoded UTF-8, the only way those bytes can appear in a larger UTF-8 text is when they represent the same code points. So you can use any 8-bit safe byte at a time search function, like strchr or strstr, to run the search.
6. Most programs that handle 8-bit files safely can handle UTF-8 safely.
  This also follows from Properties 2, 3, and 4. I say “most” programs, because programs that take apart a byte sequence expecting one character per byte will not behave correctly, but very few programs do that. It is far more common to split input at newline characters, or split whitespace-separated fields, or do other similar parsing around specific ASCII characters. For example, Unix tools like cat, cmp, cp, diff, echo, head, tail, and tee can process UTF-8 files as if they were plain ASCII files. Most operating system kernels should also be able to handle UTF-8 file names without any special arrangement, since the only operations done on file names are comparisons and splitting at /. In contrast, tools like grep, sed, and wc, which inspect arbitrary individual characters, do need modification.
7. UTF-8 sequences sort in code point order.
  You can verify this by inspecting the encodings in the table above. This means that Unix tools like join, ls, and sort (without options) don't need to handle UTF-8 specially.
8. UTF-8 has no “byte order.”
  UTF-8 is a byte encoding. It is not little endian or big endian. Unicode defines a byte order mark (BOM) code point FFFE, which are used to determine the byte order of a stream of raw 16-bit values, like UCS-2 or UTF-16. It has no place in a UTF-8 file. Some programs like to write a UTF-8-encoded BOM at the beginning of UTF-8 files, but this is unnecessary (and annoying to programs that don't expect it).

UTF-8 does give up the ability to do random access using code point indices. Programs that need to jump to the nth Unicode code point in a file or on a line—text editors are the canonical example—will typically convert incoming UTF-8 to an internal representation like an array of code points and then convert back to UTF-8 for output, but most programs are simpler when written to manipulate UTF-8 directly.

Programs that make UTF-8 more complicated than it needs to be are typically trying to be too general, not wanting to make assumptions that might not be true of other encodings. But there are good tools to convert other encodings to UTF-8, and it is slowly becoming the standard encoding: even the fraction of web pages written in UTF-8 is [nearing 50%](http://googleblog.blogspot.com/2010/01/unicode-nearing-50-of-web.html). UTF-8 was explicitly designed to have these nice properties. Take advantage of them.

For more on UTF-8, see [“Hello World or Καλημέρα κόσμε or こんにちは 世界,”](http://plan9.bell-labs.com/sys/doc/utf.html) by Rob Pike and Ken Thompson, and also this [history](http://www.cl.cam.ac.uk/~mgk25/ucs/utf-8-history.txt).

