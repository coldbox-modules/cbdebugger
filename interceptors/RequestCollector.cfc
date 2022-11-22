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
	 * Listen to when the debugger loads for the first time, usually app starts or reinits
	 */
	function onDebuggerLoad( event, interceptData, rc, prc ){
		initRequestTracker( event );
	}

	/**
	 * Listen to when the request is first captured by ColdBox
	 */
	function onRequestCapture( event, interceptData, rc, prc ){
		initRequestTracker( event );

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
	 * Listen to when the request is received by ColdBox
	 */
	function preProcess( event, interceptData, rc, prc ){
	}

	/**
	 * Listen to when the request is finalized by ColdBox
	 */
	function postProcess( event, interceptData, rc, prc, buffer ){
		// Determine if we are in a debugger call so we can ignore it or not?
		if (
			arguments.event.getCurrentModule() == "cbdebugger" && !variables.debuggerConfig.requestTracker.trackDebuggerEvents
		) {
			return;
		}

		// Record the profiler with the last tickcount
		variables.debuggerService.recordProfiler( event: arguments.event, executionTime: getTickCount() );

		// Determine if we can render the debugger at the bottom of the request
		if (
			// Is the debugger turned on
			variables.debuggerService.getDebugMode() AND
			// Can we show the end of request dock
			variables.debuggerConfig.requestPanelDock AND
			// Has it not been disabled by the user programmatically
			arguments.event.getPrivateValue( "cbox_debugger_show", true ) AND
			// Don't render in ajax calls
			!arguments.event.isAjax() AND
			// Only show on HTML content types
			findNoCase( "html", variables.debuggerService.getPageContextResponse().getContentType() ) AND
			// We don't have any render data OR the render data is HTML
			(
				structIsEmpty( arguments.event.getRenderData() ) || arguments.event.getRenderData().contentType == "text/html"
			) AND
			// Don't render in testing modes
			!findNoCase( "MockController", getMetadata( controller ).name )
		) {
			// render out the debugger to the buffer output
			arguments.buffer.append( runEvent( "cbdebugger:main.renderDebugger" ) );
		}
	}

	/**
	 * Listen to exceptions and log them
	 */
	function onException( event, interceptData, rc, prc ){
		// End the request timer for the request
		variables.timerService.stop( "[preprocess]" );

		// Record the request and exception
		variables.debuggerService.recordProfiler(
			event        : arguments.event,
			executionTime: getTickCount(),
			exception    : arguments.interceptData.exception
		);
	}

	/**
	 * Listen to start of any ColdBox events
	 */
	function preEvent( event, interceptData, rc, prc ){
		variables.timerService.start(
			label   : "[runEvent] #arguments.interceptData.processedEvent#",
			metadata: {
				event          : arguments.interceptData.processedEvent,
				eventArguments : arguments.interceptData.eventArguments.toString()
			},
			type: "event"
		);
	}

	/**
	 * Listen to end of ColdBox events
	 */
	function postEvent( event, interceptData, rc, prc ){
		// new coldbox tracking of events
		if ( arguments.interceptData.keyExists( "ehBean" ) ) {
			var handlerMD = interceptData.ehBean.getHandlerMetadata();

			// params in case it's an invalid event
			param handlerMD.functions = [];
			param handlerMD.path      = "";

			var position = handlerMD.functions
				.filter( function( thisItem ){
					return thisItem.name == interceptData.ehBean.getMethod();
				} )
				.reduce( function( result, thisItem ){
					return thisItem.keyExists( "position" ) ? thisItem.position.start : result;
				}, 1 );

			// stop timer
			variables.timerService.stop(
				label   : "[runEvent] #arguments.interceptData.processedEvent#",
				metadata: { path : handlerMD.path, line : position }
			);
		} else {
			variables.timerService.stop(
				label   : "[runEvent] #arguments.interceptData.processedEvent#",
				metadata: { path : "", line : 1 }
			);
		}
	}

	/**
	 * Listen to before rendering process executes
	 */
	function preRender( event, interceptData, rc, prc ){
		variables.timerService.start( label: "[preRender to postRender]", type: "renderer" );
	}

	/**
	 * Listen to when rendering is complete
	 */
	function postRender( event, interceptData, rc, prc ){
		variables.timerService.stop( "[preRender to postRender]" );
	}

	/**
	 * Listen to when views are about to be rendered
	 */
	function preViewRender( event, interceptData, rc, prc ){
		variables.timerService.start(
			label: "[renderView] #arguments.interceptData.view#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" ),
			metadata: {
				"view"                   : arguments.interceptData.view,
				"module"                 : arguments.interceptData.module,
				"cache"                  : arguments.interceptData.cache,
				"cacheTimeout"           : arguments.interceptData.cacheTimeout,
				"cacheLastAccessTimeout" : arguments.interceptData.cacheLastAccessTimeout,
				"cacheSuffix"            : arguments.interceptData.cacheSuffix,
				"cacheProvider"          : arguments.interceptData.cacheProvider,
				"path"                   : "",
				"line"                   : 1
			},
			type: "view-render"
		);
	}

	/**
	 * Listen to when views are done rendering
	 */
	function postViewRender( event, interceptData, rc, prc ){
		var viewPath = arguments.interceptData.keyExists( "viewPath" ) ? expandPath(
			arguments.interceptData.viewPath
		) & ".cfm" : "";
		variables.timerService.stop(
			label: "[renderView] #arguments.interceptData.view#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" ),
			metadata: { path : viewPath }
		);
	}

	/**
	 * Listen to when layouts are rendered
	 */
	function preLayoutRender( event, interceptData, rc, prc ){
		variables.timerService.start(
			label: "[renderLayout] #arguments.interceptData.layout#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" ),
			metadata: {
				"layout"     : arguments.interceptData.layout,
				"module"     : arguments.interceptData.module,
				"view"       : arguments.interceptData.view,
				"viewModule" : arguments.interceptData.viewModule,
				"path"       : "",
				"line"       : 1
			},
			type: "layout-render"
		);
	}

	/**
	 * Listen to when layouts are done rendering
	 */
	function postLayoutRender( event, interceptData, rc, prc ){
		var viewPath = arguments.interceptData.keyExists( "viewPath" ) ? expandPath(
			arguments.interceptData.viewPath
		) & ".cfm" : "";

		variables.timerService.stop(
			label: "[renderLayout] #arguments.interceptData.layout#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" ),
			metadata: { path : viewPath }
		);
	}

	/************************************** PRIVATE METHODS *********************************************/

	/**
	 * Init the request tracking constructs
	 */
	private function initRequestTracker( event ){
		if ( isNull( request.cbRequestCollectorStarted ) ) {
			// init tracker variables for the request
			variables.debuggerService.createRequestTracker( event );
			// Mark as inited
			request.cbRequestCollectorStarted = true;
		}
	}

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
				var cache = view(
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
			relocate( URL = "#listLast( cgi.script_name, "/" )#", addtoken = false );
		} else {
			relocate(
				URL      = "#listLast( cgi.script_name, "/" )#?debugpanel=#event.getValue( "debugPanel", "" )#",
				addtoken = false
			);
		}
	}

}
