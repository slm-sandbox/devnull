var jsdom  = require('jsdom').jsdom;
var fs     = require('fs');

jsdom.env({
  html: 'http://donjon.bin.sh/scifi/tsg/',
  features: { 
    FetchExternalResources: ["script"],
    ProcessExternalResources: ["script"]
  },
  done: function(errors, window) {

    function after_load() { 
      var $ = window.$;
      window.Event = {
        observe: function() {}
      }
      window.init_form();
      console.log($("system").select("tr")[0].select("td"));
    }

    console.log('hej');
    setTimeout(after_load, 20000);


  }
});
