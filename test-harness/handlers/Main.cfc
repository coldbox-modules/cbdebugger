/**
 * My Event Handler Hint
 */
component {

	// Index
	any function index( event, rc, prc ){
		getInstance( "TestService" ).testMethod();
		log.info( "in the index event firing" );
	}

	any function noDebugger( event, rc, prc ){
		hideDebugger();
		event.renderData( data = "<h1>Hello</h1>" );
	}

	/**
	 * error
	 */
	function error( event, rc, prc ){
		event.setdddView( "Main/error" );
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
		// var logBox = controller.getLogBox();
		// logBox.registerAppender(
		//	"tracer",
		//	"cbdebugger.appenders.TracerAppender"
		// );
		// var appenders = logBox.getAppendersMap( "tracer" );
		// // Register the appender with the root loggger, and turn the logger on.
		// var root      = logBox.getRootLogger();
		// root.addAppender( appenders[ "tracer" ] );
		// root.setLevelMax( 4 );
		// root.setLevelMin( 0 );
	}

}
