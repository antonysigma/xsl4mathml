/*
function : to convert hex code to valid html character
input : [HEX code] ASCII hex code, seperated by space
output : [String] '&#x' + hex + ';'
*/
function
symbol(code) {
    if (code.match(/^[0-9A-F\x20]+$/i) == null) //return empty text if a is not valid hex code
    return '';
    else return '&#x' + code.replace(/\x20/g, ';&#x') + ';';
}

/*
The mrowStretch function implements stretchy brackets. It is called
repeatedly, once for each mo child,after a span corresponding to an
mrow. The arguments are the id of the span and the characters to use
for the parts of the stretch operator.
*/

/*
function : stretch brackets vertically
input : mrowH = [integer] height of the content
        opid  = [String] (id) the <span> tag containing the operator
        opt   = [HEX code] fragment of the stretched bracket (top)
        ope   = [HEX code] fragment of the stretched bracket (extension)
        opm   = [HEX code] fragment of the stretched bracket (middle)
        opb   = [HEX code] fragment of the stretched bracket (bottom)
output : null
*/

function
mrowStretch(opid, opt, ope, opm, opb) {
    var opObj = $('#' + opid);
    var opH = opObj.outerHeight(true);

    if (mrowH == 0 || opH == 0) return; //fail safe
    var m, es;
    if (mrowH > opH * 2) {
        m = symbol(opm) + '<br />';
        if ((mrowH < opH * 3) && (opm == ope)) m = '';
        es = '';
        for (var i = 3; i * 2 * opH <= mrowH; i++) {
            if (i > 10) break; //fail safe
            es += symbol(ope) + '<br />';
        }
        opObj.html('<span class="lr">' + symbol(opt) + '<br />' + es + m + es + symbol(opb) + '</span>');
    }
}
/*
function : draw horizontal line and align the fraction
input : aid  = [String] id of the numerator
        bid  = [String] id of the denominator
        type = [String] whether to align the fraction
output : null
*/

function
mfrac(aid, bid, type) {
    var aObj = $('#' + aid);
    var bObj = $('#' + bid);
    var aBox = {
        width: aObj.outerWidth(true)
    };
    var bBox = {
        width: bObj.outerWidth(true)
    };
    if (type == 'full') {
        aBox.height = aObj.outerHeight(true);
        bBox.height = bObj.outerHeight(true);
        if (aBox.height > bBox.height) {
            bObj.css('paddingBottom', (aBox.height - bBox.height))
        }
        else {
            aObj.css('paddingTop', (bBox.height - aBox.height))
        }
    }
    if (aBox.width > bBox.width) {
        aObj.css({
            borderStyle: 'solid',
            borderColor: '#000',
            borderWidth: '0 0 1px'
        })
    }
    else {
        bObj.css({
            borderStyle: 'solid',
            borderColor: '#000',
            borderWidth: '1px 0 0'
        });
    }
}

/*
function : shift index downward
input : bsid = [String] id of the base
        pid  = [String] id of the index
output : null
*/

function
msub(bsid, pid) {
    var bsObj = $('#' + bsid);
    var pObj = $('#' + pid);
    pObj.css('bottom', bsObj.outerHeight(true) / (-2));
    bsObj.css('marginBottom', pObj.outerHeight(true) / 2);
}

/*
function : shift index upward
input : bsid = [String] id of the base
        pid  = [String] id of the index
output : null
*/

function
msup(bsid, pid) {
    var bsObj = $('#' + bsid);
    var pObj = $('#' + pid);
    pObj.css('top', bsObj.outerHeight(true) / (-2));
    bsObj.css('marginTop', pObj.outerHeight(true) / 2);
}

/*
function : show alternative texts one by one
input : id = [String] id of the group
output : null
*/

function
toggle(id) {
    var childObj = $('#' + id).children();
    for (var i = 0; i < childObj.length; i++) {
        if (childObj[i].style.display == 'inline-block') {
            childObj[i].style.display = 'none';
            if (i + 1 == childObj.length) {
                childObj[0].style.display = 'inline-block';
            }
            else {
                childObj[i + 1].style.display = 'inline-block';
            }
            break;
        }
    }
}

/*
Object : Queue job managemant
Store rendering jobs and execute them when the html dom is loaded.
*/
var Queue = function () {
    this.queue = new Array();
    this.length = 0;
    this.idx = 0;
    var self = this;
    this.add = function (job) {
        this.queue.push(job);
        this.length++;
    };
    this.runAll = function () {
        if (this.idx >= this.length) {
            window.status = '';
            return;
        }
        else {
            this.queue[this.idx].apply();
            window.status = this.idx + '/' + this.length;
            this.idx++;
            setTimeout(function () {
                self.runAll();
            }, 50);
        }
    }
};
var renderQueue = new Queue();
$(function () {
    renderQueue.runAll();
}

);
