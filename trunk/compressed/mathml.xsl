<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                xmlns:x="data:,x"
                version="1.0"
                exclude-result-prefixes="x h xd"> 
   <xsl:import href="mathmlc2p.xsl"/>      
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