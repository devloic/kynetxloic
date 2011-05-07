ruleset a1135x43 {
	meta {
		name "json_js"
		description <<
			include js files on the fly
		>>
		author "loic devaux"
		logging on
	}

	dispatch {
		domain ".*"
	}

	global {
        datasource myjs_json <-  '' cachable for 42 years;
       
        getMyJs = function(json_js_url){
          myjs_json = datasource:myjs_json(json_js_url);
          myjs = myjs_json.pick('$.myjs') ;
          myjs
            
        };
        emit <|
        var injectJs = function(someJs){
            var anewscript;
            anewscript = document.createElement("script");
            anewscript.type = 'text/javascript';
            anewscript.innerHTML=someJs;
            document.getElementsByTagName("head")[0].appendChild(anewscript);
        };
        |>;
	}

	rule first_rule {
		select when pageview ".*" setting ()
		pre {
            myjs= getMyJs("http://lolo.asia/kynetx_restyler_kbx_debug/js/myjs.json?");
		}
		
         emit <|
             console.log(myjs);
             injectJs(myjs);
             eval(myjs);
            |>;
       
	}
}
