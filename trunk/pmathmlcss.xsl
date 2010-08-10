<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
   version="1.0"
   xmlns:xd="http://www.pnp-software.com/XSLTdoc"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:x="data:,x"
  exclude-result-prefixes="x h xd"
>
<xd:doc type="stylesheet">
    <xd:short>Presentation MathML Stylesheet</xd:short>
    <xd:detail>This stylesheet transforms Presentation MathML to XHTML + CSS + Javascript, so rendering MathML (to somewhat variable quality) in a standard HTML browser without any extra plugin. In addition to its use as a fall back option in these client side transformations, this stylesheet could be used as a server based transformation to produce something acceptable on browsers without any XSLT or MathML support. <h:del>(Currently the javascript has a Microsoft Bias, but this can hopefully be removed in future versions.)</h:del></xd:detail>
    <xd:author>ibirrer (modified by antonysigma :P)</xd:author>
    <xd:copyright>Copyright David Carlisle 2001, 2002.
<h:br /><h:br />
Use and distribution of this code are permitted under the terms of the <h:a
href="http://www.w3.org/Consortium/Legal/copyright-software-19980720"
>W3C Software Notice and License</h:a>.</xd:copyright>
    <xd:cvsId>$Id: pmathmlcss.xsl,v 1.1 2002/03/20 12:20:57 mf Exp $</xd:cvsId>
  </xd:doc>
  
  <xsl:output method="html" />
  
<!-- *antonysigma* 
integrand operator : currently not supported
<x:x x="&#x222B;" m="0em"  stretch="true" top="F3" middle="F4" extend="F4" bottom="F5">&#xF2;</x:x -->

<x:x x="{" m="0em"  stretch="true" top="EC" middle="ED" extend="EF" bottom="EE">{</x:x>
<x:x x="}" m="0em"  stretch="true" top="FC" middle="FD" extend="FD" bottom="FE">}</x:x>

<x:x x="(" m="0em"  stretch="true" top="E6" middle="E7" extend="E7" bottom="E8">(</x:x>
<x:x x=")" m="0em"  stretch="true" top="F6" middle="F7" extend="F7" bottom="F8">)</x:x>

<x:x x="[" m="0em"  stretch="true" top="E9" middle="EA" extend="EA" bottom="EB">[</x:x>
<x:x x="]" m="0em"  stretch="true" top="F9" middle="FA" extend="FA" bottom="FB">]</x:x>

<x:x x="&#x301A;" m="0em"  stretch="true" top="E9 E9" middle="EA EA" extend="EA EA" bottom="EB EB">[[</x:x>
<x:x x="&#x301B;" m="0em"  stretch="true" top="F9 F9" middle="FA FA" extend="FA FA" bottom="FB FB">]]</x:x>

<x:x x="|" m="0em"  stretch="true" top="BD" middle="BD" extend="BD" bottom="BD">|</x:x>
<x:x x="||" m="0em"  stretch="true" top="BD BD" middle="BD BD" extend="BD BD" bottom="BD BD">||</x:x>

<x:x x="&#x2061;" m="0em">&#xFEFF;</x:x><!--  applyfunction -->
<x:x x="&#x2062;" m="0em">&#xFEFF;</x:x><!--  invisibletimes -->
<x:x x="-">&#x2212;</x:x>
<x:x x="&#x2243;"><span style="position:
relative;  top: +.1em;">&#x2212;</span>&#xFEFF;<span style="position:
relative; left: -.55em; top: -.2em; margin: 0em;">~</span></x:x>
<x:x x="&#xFE38;" m="0em">_v_</x:x>

<!--Remove these for now, as XML parser in IE6 is broken and doesn't
accept plane 1 characters.
<x:x x="&#x1D538;" v="doublestruck">A</x:x>
<x:x x="&#x1D539;" v="doublestruck">B</x:x>
<x:x x="&#x2102;" v="doublestruck">C</x:x>
<x:x x="&#x1D53B;" v="doublestruck">D</x:x>

<x:x x="&#x1D552;" v="doublestruck">a</x:x>
<x:x x="&#x1D553;" v="doublestruck">b</x:x>
<x:x x="&#x1D554;" v="doublestruck">c</x:x>
<x:x x="&#x1D555;" v="doublestruck">d</x:x>

<x:x x="&#x1D504;" v="fraktur">A</x:x>
<x:x x="&#x1D505;" v="fraktur">B</x:x>
<x:x x="&#x212D;" v="fraktur">C</x:x>
<x:x x="&#x1D507;" v="fraktur">D</x:x>

<x:x x="&#x1D51E;" v="fraktur">a</x:x>
<x:x x="&#x1D51F;" v="fraktur">b</x:x>
<x:x x="&#x1D520;" v="fraktur">c</x:x>
<x:x x="&#x1D521;" v="fraktur">d</x:x>
-->

<xd:doc type="string">
<xd:short>Dictionary</xd:short>

<xd:detail> The following elements in the x: namespace form an
implementation of an "Operator Dictionary" for this MathML
Implementation. In the case of stretch operators, the element
specifies the symbol parts via the latin-1 equivalent character based
on the encoding in the symbol font.  It is a clear "failure to comply
to the spec" that using latin 1 characters (or numeric character
references) in the latin 1 range access glyphs in teh symbol font via
font position, however most of these character parts are not in
Unicode (until 3.2), so there is no standard way to access these characters.</xd:detail>
</xd:doc>
<xsl:variable name="opdict" select="document('')/*/x:x"/>

<xd:doc>
<xd:short>HTML elements</xd:short>
<xd:detail>
XHTML elements get passed straight through, sans namespace prefix.
</xd:detail>
</xd:doc>
<xsl:template mode="css" match="h:*">
<xsl:element name="{local-name(.)}">
<xsl:copy-of select="@*"/>
<xsl:apply-templates mode="css"/>
</xsl:element>
</xsl:template>

<xd:doc>
<xd:short>Head element</xd:short>
<xd:detail>
Template for the head element copies the original content, and in
addition adds a script element and CSS style element that implement
the core of the MathML renderer.
</xd:detail>
</xd:doc>
<xsl:template mode="css" match="h:head">

<xsl:element name="{local-name(.)}">
<xsl:copy-of select="@*"/>
<xsl:apply-templates mode="css"/>

<!-- Inline CSS style block handles all font and size specification for the various MathML operators. -->
<link rel="stylesheet" type="text/css" href="pmathmlstyle.css" />

<!-- jQuery Library to help us write less, do more. -->
<script type="text/javascript" language="JavaScript" src="jquery-1.4.1.min.js">
<xsl:comment />
</script>

<!-- Custom script to render some complicated mathml type -->
<script type="text/javascript" language="JavaScript" src="pmathmlscript.js">
<xsl:comment />
</script>

</xsl:element>
</xsl:template>

<xd:doc>
<xd:short>Unimplemented MathML elements</xd:short>
<xd:detail>Unimplemented MathML elements get copied literally, in red, mainly as
a debugging aid.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="m:*">
<span style="color: red;">&lt;<xsl:value-of select="local-name(.)"/>&gt;</span>
<xsl:apply-templates mode="css"/>
<span style="color: red;">&lt;/<xsl:value-of select="local-name(.)"/>&gt;</span>
</xsl:template>

<xd:doc>
<xd:short>mi</xd:short>
<xd:detail>Set default font based on string length, otherwise behaviour based
on entries in the operator dictionary if one exists, or content is
copied through to the output unchanged.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="m:mi">
<span class="mi">
<xsl:if test="1=string-length(normalize-space(.))">
<xsl:attribute name="class">mi1</xsl:attribute>
</xsl:if>
<xsl:apply-templates mode="css" select="@mathvariant"/>
 <xsl:variable name="x"  select="normalize-space(.)"/>
 <xsl:choose>
  <xsl:when test="$opdict[@x=$x and @v]">
   <xsl:attribute name="class"><xsl:value-of select="$opdict[@x=$x]/@v"/></xsl:attribute>
    <xsl:value-of select="$opdict[@x=$x and @v]"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$x"/>
   </xsl:otherwise>
  </xsl:choose>
</span>
</xsl:template>

<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='bold']">
<xsl:attribute name="style">font-weight: bold; font-style: upright</xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='bold-italic']">
<xsl:attribute name="style">font-style: upright; font-weight: bold; font-style: italic;</xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='italic']">
<xsl:attribute name="style">font-style: italic; </xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='monospace']">
<xsl:attribute name="style">font-family: monospace; </xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='sans-serif']">
<xsl:attribute name="style">font-family: sans-serif; </xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='bold-sans-serif']">
<xsl:attribute name="style">font-family: sans-serif; font-weight: bold; </xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='fraktur']">
<xsl:attribute name="style">font-family: old english text mt</xsl:attribute>
<xsl:attribute name="class"></xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='double-struck']">
<xsl:attribute name="class">doublestruck</xsl:attribute>
</xsl:template>
<xd:doc>
<xd:short>Handling of mathvariant attribute</xd:short>
<xd:detail>The choice of font families here (currently) avoids math-specific
fonts but does use several fionts coming with windows 9.x and/or
office 2000.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="@mathvariant[.='script']">
<xsl:attribute name="style">font-family: brush script mt italic</xsl:attribute>
<xsl:attribute name="class"></xsl:attribute>
</xsl:template>

<xd:doc>
<xd:short>mo</xd:short>
<xd:detail>Generate a unique ID so that a script at the end of any
surrounding mrow may replace the conent by a suitably stretched
operator if need be.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="m:mo">
<span id="{generate-id()}" class="mo">
<xsl:apply-templates mode="css"/>
</span>
</xsl:template>

<xd:doc>
mn: a simple span
</xd:doc>
<xsl:template mode="css" match="m:mn">
<span class="mn">
 <xsl:apply-templates mode="css"/>
</span>
</xsl:template>

<xd:doc>
munder: Currently only supports underline.
</xd:doc>
<xsl:template mode="css" match="m:munder">
 <xsl:choose>
  <xsl:when test="normalize-space(*[2])='&#x332;'">
    <span style="text-decoration:underline"><xsl:apply-templates mode="css" select="*[1]"/></span>
  </xsl:when>
  <xsl:otherwise>
    <span class="munder">
<xsl:apply-templates mode="css" select="*[1]"/><br />
<xsl:apply-templates mode="css" select="*[2]"/>
</span>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xd:doc>
mover: Currently only supports overline.
</xd:doc>
<xsl:template mode="css" match="m:mover">
 <xsl:choose>
  <xsl:when test="normalize-space(*[2])='&#xAF;'">
    <span style="text-decoration:overline"><xsl:apply-templates mode="css" select="*[1]"/></span>
  </xsl:when>
  <xsl:otherwise>
  <span class="mover">
  <xsl:apply-templates mode="css" select="*[2]"/><br />
<xsl:apply-templates mode="css" select="*[1]"/>
</span>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xd:doc>
munderover
</xd:doc>
<xsl:template mode="css" match="m:munderover">
<span class="munderover">
<xsl:apply-templates mode="css" select="*[3]"/>&#xFEFF;<br />
<xsl:apply-templates mode="css" select="*[1]"/><br />
<xsl:apply-templates mode="css" select="*[2]"/>&#xFEFF;
</span>
</xsl:template>

<xd:doc>
mtext: a simple span
</xd:doc>
<xsl:template mode="css" match="m:mtext">
<span class="mtext">
 <xsl:value-of select="normalize-space(.)"/>
</span>
</xsl:template>

<xd:doc>
mstyle: not many attributes currently supported
</xd:doc>
<xsl:template mode="css" match="m:mstyle">
<span>
<xsl:attribute name="style">
 <xsl:if test="@fontfamily">font-family: "<xsl:value-of select="@fontfamily"/>"; </xsl:if>
 <xsl:if test="@mathcolor">color: <xsl:value-of select="@mathcolor"/>; </xsl:if>
 <xsl:if test="@background">background-color: <xsl:value-of select="@background"/>; </xsl:if>
</xsl:attribute>
 <xsl:apply-templates mode="css"/>
</span>
</xsl:template>

<xd:doc>
<xd:short>mglyph</xd:short>
<xd:detail>Uses disable output escaping to construct a numeric
character reference. Uses IE's non conforming behaviour of using this
number to access the font encoding rather than unicode.</xd:detail>
</xd:doc>
<xsl:template mode="css" match="m:mglyph">
<font face="{@fontfamily}"><xsl:value-of
disable-output-escaping="yes" select="'&amp;#'"/>
<xsl:value-of select="@index"/>;
</font>
</xsl:template>

<xd:doc>ms: a simple span with left and right character added to the content.</xd:doc>
<xsl:template mode="css" match="m:ms">
<span class="ms">
  <xsl:value-of select="@lquote"/><xsl:if test="not(@lquote)">"</xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
  <xsl:value-of select="@rquote"/><xsl:if test="not(@rquote)">"</xsl:if>
</span>
</xsl:template>

<xsl:template mode="css" match="m:math">
    <xsl:call-template name="mrow"/>
</xsl:template>

<xsl:template mode="css" match="m:mfenced">
<xsl:variable name="l">
 <xsl:choose>
  <xsl:when test="@open"><xsl:value-of select="@open"/></xsl:when>
  <xsl:otherwise>(</xsl:otherwise>
 </xsl:choose>
</xsl:variable>
<xsl:variable name="r">
 <xsl:choose>
  <xsl:when test="@close"><xsl:value-of select="@close"/></xsl:when>
  <xsl:otherwise>)</xsl:otherwise>
 </xsl:choose>
</xsl:variable>
<xsl:variable name="s">
 <xsl:choose>
  <xsl:when test="@sep">
    <xsl:call-template name="text">
       <xsl:with-param name="x" select="@sep"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>,</xsl:otherwise>
 </xsl:choose>
</xsl:variable>
<span id="{generate-id()}L"><xsl:value-of select="$l"/></span>
<span id="{generate-id()}M">
<xsl:for-each select="*">
<xsl:apply-templates mode="css" select="."/>
<xsl:if test="position() != last()"><span id="{generate-id()}X{position()}"><xsl:value-of select="$s"/></span></xsl:if>
</xsl:for-each>
</span>
<span id="{generate-id()}R"><xsl:value-of select="$r"/></span>
<script>
renderQueue.add( function (){
<xsl:if test="$s=$opdict[@stretch='true']/@x">
<xsl:for-each select="*[position()&lt;last()]">
<xsl:variable name="opdictentry" select="$opdict[@x=$s]"/>
mrowStretch("<xsl:value-of select="concat(generate-id(),'X',position())"/>" ,"<xsl:value-of
select="$opdictentry/@top"/>","<xsl:value-of
select="$opdictentry/@extend"/>","<xsl:value-of
select="$opdictentry/@middle"/>","<xsl:value-of
select="$opdictentry/@bottom"/>");</xsl:for-each>
</xsl:if>
<xsl:if test="$l=$opdict[@stretch='true']/@x">
<xsl:variable name="opdictentry" select="$opdict[@x=$l]"/>
mrowH = $("#<xsl:value-of select="generate-id()"/>M").outerHeight(true);
mrowStretch("<xsl:value-of select="generate-id()"/>L","<xsl:value-of
select="$opdictentry/@top"/>","<xsl:value-of
select="$opdictentry/@extend"/>","<xsl:value-of
select="$opdictentry/@middle"/>","<xsl:value-of
select="$opdictentry/@bottom"/>");
</xsl:if>
<xsl:if test="$r=$opdict[@stretch='true']/@x">
<xsl:variable name="opdictentry2" select="$opdict[@x=$r]"/>
mrowStretch("<xsl:value-of select="generate-id()"/>R","<xsl:value-of
select="$opdictentry2/@top"/>","<xsl:value-of
select="$opdictentry2/@extend"/>","<xsl:value-of
select="$opdictentry2/@middle"/>","<xsl:value-of
select="$opdictentry2/@bottom"/>");
</xsl:if>
});
</script>
</xsl:template>


<xsl:template mode="css" match="m:mmultiscripts">
<table style="display:inline; vertical-align: middle;">
<tr>
<xsl:for-each select="*[preceding-sibling::m:mprescripts and position() mod 2 = 0]">
<td><xsl:apply-templates mode="css" select="."/></td>
</xsl:for-each>
<td rowspan="2"><xsl:apply-templates mode="css" select="*[1]"/></td>
<xsl:for-each select="*[not(preceding-sibling::m:mprescripts) and position() !=1 and position() mod 2 = 1]">
<td><xsl:apply-templates mode="css" select="."/></td>
</xsl:for-each>
</tr>
<tr>
<xsl:for-each select="*[preceding-sibling::m:mprescripts and position() mod 2 = 1]">
<td><xsl:apply-templates mode="css" select="."/></td>
</xsl:for-each>
<xsl:for-each select="*[not(preceding-sibling::m:mprescripts) and
not(self::m:mprescripts) and position() mod 2 = 0]">
<td><xsl:apply-templates mode="css" select="."/></td>
</xsl:for-each>
</tr>
</table>
</xsl:template>

<xd:doc>
Display nothing.
</xd:doc>
<xsl:template mode="css" match="m:none">&#xFEFF;</xsl:template>

<xd:doc>
display items one by one when clicked.
</xd:doc>
<xsl:template mode="css" match="m:merror">
<span class="merror"><xsl:call-template name="mrow"/></span>
</xsl:template>

<xsl:template mode="css" match="m:mphantom">
<span class="mphantom"><xsl:apply-templates mode="css"/></span>
</xsl:template>

<xsl:template mode="css" match="m:maction[@actiontype='tooltip']">
<span title="{normalize-space(*[2])}"><xsl:apply-templates mode="css" select="*[1]"/></span>
</xsl:template>

<xsl:template mode="css" match="m:maction[@actiontype='toggle']">
<span  id="{generate-id()}">
<span style="display:inline-block;"><xsl:apply-templates mode="css" select="*[1]"/></span>
<xsl:for-each select="*[position() &gt; 1]">
<span style="display:none;"><xsl:apply-templates mode="css" select="."/></span>
</xsl:for-each>
</span>
<script>
renderQueue.add(function (){
$('#<xsl:value-of select="generate-id()"/>').click(function (){
toggle('<xsl:value-of select="generate-id()"/>');
});
});
</script>
</xsl:template>

<xd:doc>
Display comment in the status line when mouseover.
</xd:doc>
<xsl:template mode="css" match="m:maction[@actiontype='statusline']">
<span id="{generate-id()}" title="{normalize-space(*[2])}"><xsl:apply-templates mode="css" select="*[1]"/></span>
<script>
renderQueue.add(function (){
$('#<xsl:value-of select="generate-id()"/>').hover(
function (e) {window.status='<xsl:value-of select="normalize-space(*[2])"/>';},
function () {window.status='';}
);
});
</script>
</xsl:template>

<xd:doc>
yellow background when moveover, restore when mouseout.
</xd:doc>
<xsl:template mode="css" match="m:maction[@actiontype='highlight']">
<span id="{generate-id()}"><xsl:apply-templates mode="css"/></span>
<script>
renderQueue.add(function (){
$('#<xsl:value-of select="generate-id()"/>').hover(
function (e) {$('#<xsl:value-of select="generate-id()"/>').css('backgroundColor','yellow');},
function (e) {$('#<xsl:value-of select="generate-id()"/>').css('backgroundColor','transparent');}
);
});
</script>
</xsl:template>

<xd:doc>
Simple span, changed to mfenced if contain brackets.
</xd:doc>
<xsl:template mode="css" match="m:mrow" name="mrow">
<span id="{generate-id()}" class="mrow">
 <xsl:apply-templates mode="css" select="*"/>
</span>
<xsl:if test="m:mo[@stretch='true' or normalize-space(.)=$opdict[@stretch='true']/@x]">
<script>
renderQueue.add( function (){
mrowH = $("#<xsl:value-of select="generate-id()"/>").outerHeight(true);
<xsl:for-each select="m:mo[@stretch='true' or
                  normalize-space(.)=$opdict[@stretch='true']/@x]">
<xsl:variable name="o" select="normalize-space(.)"/>
<xsl:variable name="opdictentry" select="$opdict[@x=$o]"/>
mrowStretch("<xsl:value-of select="generate-id()"/>","<xsl:value-of
select="$opdictentry/@top"/>","<xsl:value-of
select="$opdictentry/@extend"/>","<xsl:value-of
select="$opdictentry/@middle"/>","<xsl:value-of
select="$opdictentry/@bottom"/>","<xsl:value-of
select="$opdictentry/@font"/>");</xsl:for-each>
});
</script>
</xsl:if>
</xsl:template>


<xsl:template mode="css" match="m:msubsup">
<span class="munderover">
<span style="vertical-align:middle"><xsl:apply-templates mode="css" select="*[1]"/></span>
<span class="msubsup"><xsl:apply-templates mode="css"
select="*[3]"/><br />
<xsl:apply-templates mode="css" select="*[2]"/></span>
</span>
</xsl:template>

<xd:doc>
Use JavaScript to shift index upwards.
</xd:doc>
<xsl:template mode="css" match="m:msup">
<span id="{generate-id()}">
<xsl:apply-templates mode="css" select="*[1]"/>
</span><span id="{generate-id()}p" class="msub"><xsl:apply-templates mode="css"
select="*[2]"/></span>
<script>
renderQueue.add( function (){
msup("<xsl:value-of select="generate-id()"/>","<xsl:value-of select="generate-id()"/>p");
});
</script>
</xsl:template>

<xd:doc>
Use JavaScript to shift index downwards.
</xd:doc>
<xsl:template mode="css" match="m:msub">
<span id="{generate-id()}">
<xsl:apply-templates mode="css" select="*[1]"/>
</span
><span id="{generate-id()}p" class="msub"><xsl:apply-templates mode="css"
select="*[2]"/></span>
<script>
renderQueue.add( function (){
msub("<xsl:value-of select="generate-id()"/>","<xsl:value-of select="generate-id()"/>p");
});
</script>
</xsl:template>

<xsl:template mode="css" match="m:*/text()" name="text">
<xsl:param name="x" select="normalize-space(.)"/>
<xsl:variable name="mo"  select="document('')/*/x:x[@x=$x]"/>
<xsl:choose>
  <xsl:when test="$mo"><xsl:copy-of select="$mo/node()"/></xsl:when>
  <xsl:otherwise><xsl:copy-of select="$x"/></xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template mode="css" match="m:msqrt">
<span class="mroot_whole">
<span class="msqrtx">\</span>
<span  class="msqrt"><xsl:apply-templates mode="css"/></span>
</span>
</xsl:template>

<xsl:template mode="css" match="m:menclose[@notation='radical']">
<span class="mroot_whole">
<span class="msqrtx">\</span>
<span  class="msqrt"><xsl:apply-templates mode="css"/></span>
</span>
</xsl:template>

<xsl:template mode="css" match="m:menclose[@notation='actuarial']">
<span class="actuarial">
<xsl:apply-templates mode="css"/>
</span>
</xsl:template>

<xsl:template mode="css" match="m:menclose">
<span class="msqrt">
<xsl:apply-templates mode="css"/>
</span>
</xsl:template>

<xsl:template mode="css" match="m:mroot">
<span class="mroot_whole">
<span class="mroot_index" ><xsl:apply-templates mode="css" select="*[2]"/></span>
<span class="msqrtx" >\</span>
<span class="msqrt" ><xsl:apply-templates mode="css" select="*[1]"/></span>
</span>
</xsl:template>


<xsl:template mode="css" match="m:mfrac">
<xsl:param name="full" select="not(ancestor::m:mfrac)"/>
<span class="mfrac">
<xsl:if test="$full">
  <xsl:attribute name="style">font-size: 80% ;</xsl:attribute>
</xsl:if>
<span id="a{generate-id()}" class="mfraca">
<xsl:apply-templates mode="css" select="*[1]"/>
</span><br />
<span id="b{generate-id()}" class="mfracb">
<xsl:apply-templates mode="css" select="*[2]"/>
</span>
</span><script>
renderQueue.add( function (){
mfrac('a<xsl:value-of select="generate-id()"/>','b<xsl:value-of select="generate-id()"/>'
<xsl:if test="$full">,'full'</xsl:if>
);
});
</script>
</xsl:template>

<xsl:template mode="css" match="m:padded">
<span>
<xsl:attribute name="display">
</xsl:attribute>
<xsl:apply-templates mode="css"/>
</span>
</xsl:template>


<xsl:template mode="css" match="m:mspace">
<span style="padding-left: {@width};"></span>
</xsl:template>

<xsl:template mode="css" match="m:mtable">
<table class="mtable">
<xsl:apply-templates mode="css"/>
</table>
<!-- script>
renderQueue.add( function (){
<xsl:variable name="t" select="."/>
<xsl:for-each select="m:mtr[1]/m:mtd">
<xsl:variable name="c" select="position()"/>

malign(
<xsl:for-each select="descendant::m:maligngroup">
<xsl:variable name="g" select="position()"/>
['<xsl:for-each
select="$t/m:mtr/m:mtd[$c]/descendant::m:maligngroup[$g]">
 <xsl:value-of select="generate-id()"/>
 <xsl:if test="position()&lt;last()">','</xsl:if>
</xsl:for-each>']);</xsl:for-each>
</xsl:for-each>
});
</script -->
</xsl:template>

<xsl:template mode="css" match="m:mtr">
<tr align="right">
<xsl:apply-templates mode="css"/>
</tr>
</xsl:template>


<xsl:template mode="css" match="m:mtd">
<td>
<xsl:apply-templates mode="css"/>
</td>
</xsl:template>

<xsl:template mode="css" match="m:maligngroup">
<xsl:variable name="g">
<xsl:choose>
<xsl:when test="@groupalign">
</xsl:when>
<xsl:when test="ancestor::td/@groupalign">
</xsl:when>
<xsl:when test="ancestor::tr/@groupalign">
</xsl:when>
<xsl:when test="ancestor::table/@groupalign">
</xsl:when>

<xsl:otherwise>left</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<span id="{generate-id()}">&#xFEFF;</span>
</xsl:template>

<xsl:template mode="css" match="h:body">
<body>
<xsl:apply-templates mode="css"/>

</body>
</xsl:template>
</xsl:stylesheet>
