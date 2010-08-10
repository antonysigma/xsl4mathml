JQUERY_VERSION = 1.4.2
PATH_TO_SAXON9=/usr/share/java/openoffice/saxon9.jar
PATH_TO_YUICOMPRESSOR = /usr/share/java/yuicompressor-2.4.2.jar

scripts = jquery-$(JQUERY_VERSION).min.js.new pmathmlscript.js.new pmathmlstyle.css.new
xslts = mathml.xsl.new mathmlc2p.xsl.new pmathmlcss.xsl.new

help:
	@echo "make {all|documentation|install}"

all: xsltdoc pmathmlcss.min.xsl mathml.xsl.new mathmlc2p.xsl.new

#Generate doc files
documentation: config.xml
	java -jar $(PATH_TO_SAXON9) $< xsltdoc/xsl/xsltdoc.xsl > /dev/null

#========================= COMPRESS STAGE 2 =========================
pmathmlcss.min.xsl:xx0.csp xx1.csp xx2.csp xx3.csp $(scripts)
	#remove useless tags
	sed -e '1,2 d' xx3.csp > xx3.new

	#combine xsl fragments with style and js
	mv xx0.csp $@
	echo '<style type="text/css">/*<![CDATA[*/' >> $@
	cat pmathmlstyle.css.new >> $@
	echo '/*]]>*/</style><script type="text/JavaScript">' >> $@
	echo '//<![CDATA[' >> $@
	cat jquery-$(JQUERY_VERSION).min.js.new pmathmlscript.js.new >> $@
	echo '//]]>' >> $@
	cat xx3.new >> $@

xx0.csp xx1.csp xx2.csp xx3.csp:pmathmlcss.xsl.new
	#add delimiter and split file
	sed -e 's/pmathmlstyle\.css/@@@@/g' -e 's/\.js/@@@@/g' \
	pmathmlcss.xsl.new > pmathmlcss.xsl.new3
	csplit -b '%01d.csp' -k pmathmlcss.xsl.new3 '/@@@@/' '{*}'

#========================= COMPRESS STAGE 1 =========================

#compact and obfuscate scripts
$(scripts):%.new:%
	java -jar $(PATH_TO_YUICOMPRESSOR) $< -o $@

#remove xsltdoc and comments from stylesheets, preserve &x****;
$(xslts):%.new:%.new2
	sed -r -e 's/@@([^@]+)@@/\&#\1;/g' $< > $@

$(patsubst %.new,%.new2,$(xslts)):%.new2:%.new1
	java -jar $(PATH_TO_SAXON9) $< removeDocTag.xsl > $@

$(patsubst %.new,%.new1,$(xslts)):%.new1:%
	tr -t '\n' ' ' < $< |\
	sed -r -e 's/&#([^;]+);/@@\1@@/g' -e 's/\r//g' > $@

.PHONY: clean install

install:
	mv mathml.xsl.new compressed/mathml.xsl
	mv pmathmlcss.min.xsl compressed/pmathmlcss.xsl
	mv mathmlc2p.xsl.new compressed/mathmlc2p.xsl

clean:
	rm -f *.new* xx*
