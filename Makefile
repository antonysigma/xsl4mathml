scripts = jquery-1.4.1.min.js.new pmathmlscript.js.new pmathmlstyle.css.new
xslts = mathml.xsl.new mathmlc2p.xsl.new pmathmlcss.xsl.new

all: compress xsltdoc

compress:pmathmlcss.min.xsl mathml.xsl.new mathmlc2p.xsl.new

#Generate doc files
xsltdoc: config.xml
	java -jar /usr/share/java/saxon9.jar $< ../xsltdoc/xsl/xsltdoc.xsl > /dev/null

#========================= COMPRESS STAGE 2 =========================
pmathmlcss.min.xsl:xx00 xx01 xx02 xx03 $(scripts)
	#remove useless tags
	sed -e '1,2 d' xx03 > xx03.new

	#combine xsl fragments with style and js
	mv xx00 $@
	echo '<style type="text/css">/*<![CDATA[*/' >> $@
	cat pmathmlstyle.css.new >> $@
	echo '/*]]>*/</style><script type="text/JavaScript">' >> $@
	echo '//<![CDATA[' >> $@
	cat jquery-1.4.1.min.js.new pmathmlscript.js.new >> $@
	echo '//]]>' >> $@
	cat xx03.new >> $@

xx00 xx01 xx02 xx03:pmathmlcss.xsl.new
	#add delimiter and split file
	sed -e 's/pmathmlstyle\.css/@@@@/g' -e 's/\.js/@@@@/g' \
	pmathmlcss.xsl.new > pmathmlcss.xsl.new3
	csplit -k pmathmlcss.xsl.new3 '/@@@@/' '{*}'

#========================= COMPRESS STAGE 1 =========================

#compact and obfuscate scripts
$(scripts):%.new:%
	java -jar /opt/YUI/yuicompressor-2.4.2.jar $< -o $@

#remove xsltdoc and comments from stylesheets, preserve &x****;
$(xslts):%.new:%.new2
	sed -r -e 's/@@([^@]+)@@/\&#\1;/g' $< > $@

$(patsubst %.new,%.new2,$(xslts)):%.new2:%.new1
	java -jar /usr/share/java/saxon9.jar $< removeDoc.xsl > $@

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
