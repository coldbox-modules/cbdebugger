<cfscript>
	function vite() {
		var viteClient = application.wirebox.getInstance( "Vite@cbdebugger" );
		if ( structCount( arguments ) < 1 ) {
			return viteClient;
		}
		return viteClient.render( arguments[ 1 ] );
	}
</cfscript>
<cfoutput>#vite( [ "resources/assets/js/cbdebug-dock.js", "resources/assets/js/cbdebug-dashboard.js" ] )#</cfoutput>