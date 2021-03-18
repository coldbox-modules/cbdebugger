/**
 * Main ColdBox Debugger Visualizer
 */
component extends="coldbox.system.EventHandler"{

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";

	/**
	 * Visualize the debugger
	 */
	any function index( event, rc, prc ){
		// If not enabled, just 404 it
		if ( !debuggerService.getDebugMode() ) {
			event.setHTTPHeader( statusCode = 404, statusText = "page not found" );
			return "Page Not Found";
		}

		event.setView( "main/index" );
	}

}
