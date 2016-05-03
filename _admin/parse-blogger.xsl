<?xml version="1.0"?>
<!-- This stylesheet parses the Atom XML file that Blogger exports as a backup
  and generates a plain text file with the processed contents.

  In the plain text file, there are markers to indicate where each post and
  draft start.  Within these sections, there is Front Matter with the post
  metadata and then the raw content as exported by Blogger.

  Use the import-blogger.sh script to invoke this and deal with the output. -->
<xsl:stylesheet version="1.0"
                xmlns:app="http://purl.org/atom/app#"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>
  <xsl:preserve-space elements="atom:content" />

  <xsl:template match="atom:entry[atom:category[@scheme='http://schemas.google.com/g/2005#kind' and @term='http://schemas.google.com/blogger/2008/kind#post']]">

    <xsl:param name="title">
      <!-- Hack to workaround quoting issues below-->
      <xsl:variable name="apos">&apos;</xsl:variable>
      <xsl:variable name="quot">&quot;</xsl:variable>

      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="atom:title" />
        <xsl:with-param name="replace" select="$quot" />
        <xsl:with-param name="by" select="$apos" />
      </xsl:call-template>
    </xsl:param>

    <xsl:param name="draft" select="app:control/app:draft"/>

    <xsl:param name="year" select="substring(atom:published, 1, 4)"/>
    <xsl:param name="month" select="substring(atom:published, 6, 2)"/>
    <xsl:param name="day" select="substring(atom:published, 9, 2)"/>
    <xsl:param name="hour" select="substring(atom:published, 12, 2)"/>
    <xsl:param name="minute" select="substring(atom:published, 15, 2)"/>
    <xsl:param name="second" select="substring(atom:published, 18, 2)"/>
    <xsl:param name="micros" select="substring(atom:published, 21, 3)"/>
    <xsl:param name="tz" select="concat(substring(atom:published, 24, 3), substring(atom:published, 28, 2))"/>

    <xsl:param name="url" select="atom:link[@rel='alternate' and @type='text/html']/@href"/>
    <xsl:param name="relurl" select="substring($url, 28)"/>
    <xsl:param name="name" select="substring($url, 36, string-length($url) - 40)"/>

    <xsl:param name="date" select="concat($year, '-', $month, '-', $day, ' ', $hour, ':', $minute, ':', $second, ' ', $tz)"/>

    <xsl:param name="output">
      <xsl:if test="not($draft = 'yes')">
        <xsl:value-of select="concat($year, '-', $month, '-', $day, '-', $name, '.html')"/>
      </xsl:if>
      <xsl:if test="$draft = 'yes'">
        <xsl:value-of select="concat($year, '-', $month, '-', $day, '-', $hour, '-', $minute, '-', $second, '-', $micros, '.html')"/>
      </xsl:if>
    </xsl:param>

    <xsl:param name="tags">
      <xsl:for-each select="atom:category[@scheme='http://www.blogger.com/atom/ns#']">
        <xsl:sort select="@term"/>
        <xsl:if test="position() &gt; 1"><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="@term"/>
      </xsl:for-each>
    </xsl:param>

<!-- Now, dump the post.  All these lines must start on the first column. -->
<xsl:text></xsl:text>
<xsl:if test="not($draft = 'yes')">
__BEGIN_POST__ <xsl:value-of select="$output"/>
</xsl:if>
<xsl:if test="$draft = 'yes'">
__BEGIN_DRAFT__ <xsl:value-of select="$output"/>
</xsl:if>
---
layout: post
title: "<xsl:value-of select="$title"/>"
date: <xsl:value-of select="$date"/>
categories: <xsl:value-of select="$tags"/>
julipedia: <xsl:value-of select="$relurl"/>
excerpt: Post imported from The Julipedia; excerpt not available.
---
<xsl:value-of select="atom:content/text()" disable-output-escaping="yes"/>
__END__

<xsl:text></xsl:text>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <!-- From: http://geekswithblogs.net/Erik/archive/2008/04/01/120915.aspx -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
