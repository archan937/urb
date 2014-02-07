if (typeof(URB) == 'undefined') {

// *
// * URB (Uncompressed)
// *
// * (c) 2014 Paul Engel
// * Except otherwise noted, URB is licensed under
// * http://creativecommons.org/licenses/by/3.0
// *
// * $Date: 2014-02-06 23:30:51 $
// *

URB = (function() {
  var path = '/-/',

  $ = {
    ready: function(f){"\v"=="v"?setTimeout(f,0):$.on(document,'DOMContentLoaded',f);},
    on: function(e,t,f,r){if(e.attachEvent?(r?e.detachEvent('on'+t,e[t+f]):1):(r?e.removeEventListener(t,f,0):e.addEventListener(t,f,0))){e['e'+t+f]=f;e[t+f]=function(){e['e'+t+f](window.event);};e.attachEvent('on'+t,e[t+f]);}},
    hasClass: function(e,c){return $.indexOf(c,e.className.split(" "))>=0;},
    indexOf: function(v,a,i){for(i=a.length;i--&&a[i]!=v;);return i;},
    urlsafe_base64: function(e){var d="0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";e||(e=8);var c="";for(var b=0;b<e;b++){var a=Math.floor(Math.random()*d.length);c+=d.substring(a,a+1);}return c;},
    request: function(d,e,f){f=f||"post";var c=document.createElement("form");c.setAttribute("method",f);c.setAttribute("action",d);for(var b in e){if(e.hasOwnProperty(b)){var a=document.createElement("input");a.setAttribute("type","hidden");a.setAttribute("name",b);a.setAttribute("value",e[b]);c.appendChild(a)}}document.body.appendChild(c);c.submit()}
  },

  init = function() {
    $.on(document, 'click', function(event) {
      var target = event.target || event.srcElement || window.event.target || window.event.srcElement;
      if (target.tagName == 'A' && $.hasClass(target, 'urb')) {
        event.preventDefault();
        open(target.getAttribute('href'));
      }
    });
  },

  open = function(url) {
    $.request(path + $.urlsafe_base64(), {url: url});
  };

  $.ready(init);

  return {
    version: '0.1.0',
    open: open
  };
}());

}