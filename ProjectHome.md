# XSL Stylesheets for MathML #
## What is MathML? ##

It is a headache putting math formula into the webpage. To tackle this, people use MS Equation Editor, or LaTeX to generate the image, just like what the Wikimedia guys are doing. But that is too difficult! What about directly typing the formula among the paragraphs, and let the browser to render them for us? Yes, we can - using MathML.

## Why use XSL stylesheets? ##

Why? It is just because not all browsers support MathML. Currently, only Firefox have native support in MathML (but presentation type only!). Other popular browsers like Internet Explorer, Opera, or Google Chome, had not yet implemented anything to help render math formula. That's why XSL stylesheets are needed.

## How to use the XSL stylesheets? ##

### 1. Create the page using XHTML with MathML ###

You should learn how the create XHTML webpages and insert the MathML codes into the main document:
```
<?xml version="1.0"?>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Webpage</title>
  </head>
  <body>
    <h1>Formula 1</h1>
    <math xmlns="http://www.w3.org/1998/Math/MathML">
      <mi>x</mi><mo>+</mo><mn>3</mn>
    </math>
    ...
  </body>
</html>
```

Save it as _mypage.xml_.

### 2.Add a stylesheet processing instruction ###

Download these files and copy them into the same directory of the main document: [mathml.xsl](http://xsl4mathml.googlecode.com/files/mathml.xsl), [mathmlc2p.xsl](http://xsl4mathml.googlecode.com/files/mathmlc2p.xsl) and [pmathmlcss.xsl](http://xsl4mathml.googlecode.com/files/pmathmlcss.xsl).

Then add a stylesheet processing instruction to the beginning of the XHTML file. Just like this:
```
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="mathml.xsl"?>
<html xmlns="http://www.w3.org/1999/xhtml">
...
```

And that's all! Now you can show math formula in web browsers.

## How it is made? ##

Well, I didn't make it from scratch by myself. I just copy scripts and stylesheets that are currently available on the web and assemble them all together:

[XSL for MathML by W3C](http://www.w3.org/Math/XSL/)
> The very original idea of putting math formula on the web.
[jQuery](http://jquery.com/)
> A robust Javascript library that helps me write less, do more.
[MathMLc2p](http://www.lri.fr/~pietriga/mathmlc2p/mathmlc2p.html)
> Help Firefox to render Content MathML

## Which browsers does it support? ##

Currently the stylesheets supports MathML2.0, and is tested in Firefox, Internet Explorer and Google Chrome, but it should support most other modern browsers equipped with XSLT, JavaScript, and CSS. Here is the test result:

|Web Browser |	native support (MathML Content)|native support (MathML Presentation) |	XSL for MathML(Content)|	XSL for MathML(Presentation)|
|:-----------|:-------------------------------|:------------------------------------|:-----------------------|:----------------------------|
|Internet Explorer 6+ |	no 	|no 	|no 	|yes (interactive)|
|Firefox 3.0 	|no |	yes (non-interactive) 	|yes |	yes (non-interactive)|
|Google Chrome 1+ 	|no 	|no |	no 	|yes (interactive)|
|Opera 9.5+ 	|no |	yes (non-interactive) 	|no| 	yes (interactive)|

## Demo! Demo! ##
Here you are:

[psmall.xml](http://xsl4mathml.googlecode.com/svn/trunk/psmall.xml)
> Small presentation MathML example

[csmall.xml](http://xsl4mathml.googlecode.com/svn/trunk/csmall.xml)
> Small content MathML example

## Can I look into the source code of the stylesheet? ##

You may download [xsl.zip](http://xsl4mathml.googlecode.com/files/xsl4mathml.zip) which contain the uncompressed source code and some examples.