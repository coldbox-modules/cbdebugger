/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This intereceptor collects request information into the appropriate debugger or
 * timing services
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="timer@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";

	/**
	 * Configure
	 */
	function configure(){
	}

	/**
	 * Listen to request captures
	 */
	function onRequestCapture( event, interceptData, rc, prc ){
		// The timer hashes are stored here for the request and then destroyed
		request.$timerHashes = {};

		// init tracker variables for the request
		variables.debuggerService.createRequestTracker( event );

		// Determine if we are turning the debugger on/off
		if ( structKeyExists( rc, "debugMode" ) AND isBoolean( rc.debugMode ) ) {
			if ( NOT len( variables.debuggerConfig.debugPassword ) ) {
				variables.debuggerService.setDebugMode( rc.debugMode );
			} else if (
				structKeyExists( rc, "debugPassword" ) AND compareNoCase(
					variables.debuggerConfig.debugPassword,
					hash( rc.debugPassword )
				) eq 0
			) {
				variables.debuggerService.setDebugMode( rc.debugMode );
			}
		}

		// Are we in command execute or panel rendering mode?
		if ( variables.debuggerService.getDebugMode() ) {
			// call debug commands
			debuggerCommands( arguments.event );
			// panel rendering
			switch ( event.getValue( "debugPanel", "" ) ) {
				case "cache":
				case "cacheReport":
				case "cacheContentReport":
				case "cacheViewer": {
					event.overrideEvent( "cbdebugger:main.renderCacheMonitor" );
					break;
				}
			}
		}
	}

	/**
	 * Listen to pre process execution
	 */
	public function preProcess( event, interceptData, rc, prc ){
		request.$timerHashes.processHash = variables.timerService.start( "[preProcess to postProcess]" );
	}

	/**
	 * Listen to post processing execution
	 */
	public function postProcess(
		event,
		interceptData,
		rc,
		prc,
		buffer
	){
		// Determine if we are in a debugger call so we can ignore it or not?
		if (
			arguments.event.getCurrentModule() == "cbdebugger" && !variables.debuggerConfig.requestTracker.trackDebuggerEvents
		) {
			return;
		}

		// End the request timer for the request
		variables.timerService.stop(
			isNull( request.$timerHashes.processHash ) ? "" : request.$timerHashes.processHash
		);
		// Record the profiler with the last tickcount
		variables.debuggerService.recordProfiler(
			event        : arguments.event,
			executionTime: getTickCount()
		);

		// Determine if we can render the debugger at the bottom of the request
		if (
			// Is the debug mode turned on
			variables.debuggerService.getDebugMode() AND
			// Has it not been disabled by the user programmatically
			arguments.event.getPrivateValue( "cbox_debugger_show", true ) AND
			// We don't have any render data OR the render data is HTML
			( structIsEmpty( arguments.event.getRenderData() ) || arguments.event.getRenderData().type == "HTML" ) AND
			// Don't render in ajax calls
			!arguments.event.isAjax() AND
			// Don't render in testing mode
			!findNoCase(
				"MockController",
				getMetadata( controller ).name
			)
		) {
			// render out the debugger to the buffer output
			arguments.buffer.append( runEvent( "cbdebugger:main.renderDebugger" ) );
		}
	}

	/**
	 * Listen to exceptions
	 */
	public function onException( event, interceptData, rc, prc ){
		// End the request timer for the request
		variables.timerService.stop(
			isNull( request.$timerHashes.processHash ) ? "" : request.$timerHashes.processHash
		);
		// Record the request and exception
		variables.debuggerService.recordProfiler(
			event        : arguments.event,
			executionTime: getTickCount(),
			exception    : arguments.interceptData.exception
		);
	}

	/**
	 * Listen to start of events
	 */
	public function preEvent( event, interceptData, rc, prc ){
		request.$timerHashes.eventhash = variables.timerService.start(
			"[runEvent] #arguments.interceptData.processedEvent#( #arguments.interceptData.eventArguments.toString()# )"
		);
	}

	/**
	 * Listen to end of events
	 */
	public function postEvent( event, interceptData, rc, prc ){
		variables.timerService.stop( request.$timerHashes.eventhash );
	}

	/**
	 * Listen to beginning of layout rendering
	 */
	public function preLayout( event, interceptData, rc, prc ){
		request.$timerHashes.layoutHash = variables.timerService.start(
			"[preLayout to postLayout rendering] for #arguments.event.getCurrentEvent()#"
		);
	}

	/**
	 * Listen to when the layout is now rendered
	 */
	public function postLayout( event, interceptData, rc, prc ){
		variables.timerService.stop( request.$timerHashes.layoutHash );
	}

	/**
	 * Listen to before rendering process executes
	 */
	public function preRender( event, interceptData, rc, prc ){
		request.$timerHashes.renderHash = variables.timerService.start(
			"[preRender to postRender] for #arguments.event.getCurrentEvent()#"
		);
	}

	/**
	 * Listen to when rendering is complete
	 */
	public function postRender( event, interceptData, rc, prc ){
		variables.timerService.stop( request.$timerHashes.renderHash );
	}

	/**
	 * Listen to when views are about to be rendered
	 */
	public function preViewRender( event, interceptData, rc, prc ){
		request.$timerHashes.renderViewHash = variables.timerService.start(
			"[renderView] #arguments.interceptData.view#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" )
		);
	}

	/**
	 * Listen to when views are done rendering
	 */
	public function postViewRender( event, interceptData, rc, prc ){
		variables.timerService.stop( request.$timerHashes.renderViewHash );
	}

	/**
	 * Listen to when layouts are rendered
	 */
	public function preLayoutRender( event, interceptData, rc, prc ){
		request.$timerHashes.layoutHash = variables.timerService.start(
			"[renderLayout] #arguments.interceptData.layout#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" )
		);
	}

	/**
	 * Listen to when layouts are done rendering
	 */
	public function postLayoutRender( event, interceptData, rc, prc ){
		variables.timerService.stop( request.$timerHashes.layoutHash );
	}

	/**
	 * Listen before wirebox objects are created
	 */
	public function beforeInstanceCreation( event, interceptData, rc, prc ){
		if ( variables.debuggerConfig.requestTracker.profileWireBoxObjectCreation ) {
			request.$timerHashes[ arguments.interceptData.mapping.getName() ] = variables.timerService.start(
				"[Wirebox Creation] #arguments.interceptData.mapping.getName()#"
			);
		}
	}

	/**
	 * Listen to after objects are created and DI is done
	 */
	public function afterInstanceCreation( event, interceptData, rc, prc ){
		// so many checks, due to chicken and the egg problems
		if (
			variables.debuggerConfig.requestTracker.profileWireBoxObjectCreation
			and structKeyExists( request, "cbdebugger" )
			and structKeyExists(
				request.$timerHashes,
				arguments.interceptData.mapping.getName()
			)
		) {
			variables.timerService.stop( request.$timerHashes[ arguments.interceptData.mapping.getName() ] );
		}
	}

	/************************************** PRIVATE METHODS *********************************************/

	/**
	 * Execute Debugger Commands
	 */
	private function debuggerCommands( event ){
		var command = event.getTrimValue( "cbox_command", "" );
		var results = "";

		// Verify command
		if ( NOT len( command ) ) {
			return;
		}

		// Commands
		switch ( command ) {
			// Caching Reporting Commands
			case "expirecache":
			case "reapcache":
			case "delcacheentry":
			case "expirecacheentry":
			case "clearallevents":
			case "clearallviews":
			case "cacheBoxReapAll":
			case "cacheBoxExpireAll":
			case "gc": {
				// Relay this to the cache monitor
				var cache = renderView(
					view         : "main/panels/cacheBoxPanel",
					module       : "cbdebugger",
					args         : { debuggerConfig : variables.debuggerConfig },
					prePostExempt: true
				);
				break;
			}
			// Not a registered command, just ignore
			default:
				return;
		}

		// relocate to correct panel if passed
		if ( event.getValue( "debugPanel", "" ) eq "" ) {
			relocate(
				URL      = "#listLast( cgi.script_name, "/" )#",
				addtoken = false
			);
		} else {
			relocate(
				URL      = "#listLast( cgi.script_name, "/" )#?debugpanel=#event.getValue( "debugPanel", "" )#",
				addtoken = false
			);
		}
	}

}
