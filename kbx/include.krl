ruleset a1135x38 {
	meta {
		name "test_chrome_kbx"
		description <<
			
		>>
		author "loic devaux"
		logging on
	}

	dispatch {
	 domain ".*"
	}

	global {

	}

	rule first_rule {
		select when pageview ".*" setting ()
		pre {
		    includeJs = <<
            runJs = function(){
                console.log("runJs");
            };
            >>;
		}
        {
            emit <|
                
                var head = $K("head").get(0);  // using jquery
                var script = document.createElement("script");
                script.innerHTML = includeJs;
                head.appendChild(script);
                
                $K('body').prepend('<a href="javascript:void(0);" onclick=\'console.log($K);\' >Hi there</a>');
            |>;
        }
            
		
	}
}
