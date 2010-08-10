<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
   xmlns:xd="http://www.pnp-software.com/XSLTdoc"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:x="data:,x"
  xmlns:xslAlt="http://localhost/dummy/"
version="2.0">
<xsl:namespace-alias stylesheet-prefix="xslAlt" 
          result-prefix="xsl"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="xsl:stylesheet">
  <xslAlt:stylesheet version="1.0" exclude-result-prefixes="x h xd">
      <xsl:apply-templates/>
    </xslAlt:stylesheet>
  </xsl:template>

  <xsl:template match="xsl:*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    <xsl:template match="x:*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="xd:*" />
  
  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>

