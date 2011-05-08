ruleset a1135x43 {
  meta {
    name "inject_js"
    description << include js files on the fly >> author "loic devaux"
    logging on
  }
  dispatch {
    domain ".*"
  }
  global {
    datasource myjs <- '' cachable for 42 years;
    
    getMyJs = function (js_url) {
      myjs = datasource: myjs(js_url);
      myjs
    };
    
    emit <|
        var injectJs = function (someJs) {
          var anewscript;
          anewscript = document.createElement("script");
          anewscript.type = 'text/javascript';
          anewscript.innerHTML = someJs;
          document.getElementsByTagName("head")[0].appendChild(anewscript);
        }; 
    |> ;
  }
  
  rule first_rule {
    select when pageview ".*"
    setting()
    pre {
      myjs = getMyJs("http://lolo.asia/kynetx_kbx_debug/js/myjs.js");
    }
    emit <| 
        console.log("myjs");
        console.log(myjs);
        injectJs(myjs); // => $K won't be available inside the included js code when running inside KBX 
        eval(myjs); // => $K will be available inside the included js code when running inside KBX 
    |> ;
  }
  
}