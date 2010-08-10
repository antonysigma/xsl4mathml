<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="xd">
<xsl:import href="mathmlc2p.xsl"/>
  <xd:doc type="stylesheet">
    <xd:short>The main stylesheet for Content or Presentation MathML</xd:short>
    <xd:detail>
Currently this is largely a copy of pmathmlcss.xsl, it may be that future versions of this distribution will be able to merge these files. It acts identically to pmathmlcss.xsl unless running with transformiix (mozilla or netscape) in which case a pre-transformation of Content MathML to Presentation MathML is performed before rendering the Presentation MathML.
</xd:detail>
  </xd:doc>
  <xsl:include href="pmathmlcss.xsl"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="system-property('xsl:vendor')='Transformiix'">
        <xsl:apply-imports/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="css"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

