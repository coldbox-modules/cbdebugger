/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Coldbox Debugger Interecptor
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
		// init tracker variables for the request
		request.cbdebugger = {};
		request.fwExecTime = getTickCount();

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
				case "profiler": {
					event.overrideEvent( "cbdebugger:main.renderProfiler" );
					break;
				}
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
		request.cbdebugger.processHash = variables.timerService.start( "[preProcess to postProcess]" );
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
		// If we are in a command or panel rendering, exit
		if (
			arguments.event.getTrimValue( "cbox_command", "" ).len() ||
			arguments.event.getTrimValue( "debugPanel", "" ).len()
		) {
			return;
		}

		// end the request timer
		variables.timerService.stop( isNull( request.cbdebugger.processHash ) ? "" : request.cbdebugger.processHash );
		// End fw execution time
		request.fwExecTime = getTickCount() - request.fwExecTime;
		// record all profilers
		variables.debuggerService.recordProfiler();

		// Determine if we can render the debugger at the bottom of the request
		if (
			// Is the debug mode turned on
			variables.debuggerService.getDebugMode() AND
			// Has it not been disabled by the user programmatically
			isDebuggerRendering() AND
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

	public function preEvent( event, interceptData, rc, prc ){
		request.cbdebugger.eventhash = variables.timerService.start(
			"[runEvent] #arguments.interceptData.processedEvent#( #arguments.interceptData.eventArguments.toString()# )"
		);
	}

	public function postEvent( event, interceptData, rc, prc ){
		variables.timerService.stop( request.cbdebugger.eventhash );
	}

	public function preLayout( event, interceptData, rc, prc ){
		request.cbdebugger.layoutHash = variables.timerService.start(
			"[preLayout to postLayout rendering] for #arguments.event.getCurrentEvent()#"
		);
	}

	public function postLayout( event, interceptData, rc, prc ){
		variables.timerService.stop( request.cbdebugger.layoutHash );
	}

	public function preRender( event, interceptData, rc, prc ){
		request.cbdebugger.renderHash = variables.timerService.start(
			"[preRender to postRender] for #arguments.event.getCurrentEvent()#"
		);
	}

	public function postRender( event, interceptData, rc, prc ){
		variables.timerService.stop( request.cbdebugger.renderHash );
	}

	public function preViewRender( event, interceptData, rc, prc ){
		request.cbdebugger.renderViewHash = variables.timerService.start(
			"[renderView] #arguments.interceptData.view#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" )
		);
	}

	public function postViewRender( event, interceptData, rc, prc ){
		variables.timerService.stop( request.cbdebugger.renderViewHash );
	}

	public function preLayoutRender( event, interceptData, rc, prc ){
		request.cbdebugger.layoutHash = variables.timerService.start(
			"[renderLayout] #arguments.interceptData.layout#" &
			( len( arguments.interceptData.module ) ? "@#arguments.interceptData.module#" : "" )
		);
	}

	public function postLayoutRender( event, interceptData, rc, prc ){
		variables.timerService.stop( request.cbdebugger.layoutHash );
	}

	public function beforeInstanceCreation( event, interceptData, rc, prc ){
		if ( variables.debuggerConfig.wireboxCreationProfiler ) {
			request.cbdebugger[ arguments.interceptData.mapping.getName() ] = variables.timerService.start(
				"[Wirebox Creation] #arguments.interceptData.mapping.getName()#"
			);
		}
	}

	public function afterInstanceCreation( event, interceptData, rc, prc ){
		// so many checks, due to chicken and the egg problems
		if (
			variables.debuggerConfig.wireboxCreationProfiler
			and structKeyExists( request, "cbdebugger" )
			and structKeyExists(
				request.cbdebugger,
				arguments.interceptData.mapping.getName()
			)
		) {
			variables.timerService.stop( request.cbdebugger[ arguments.interceptData.mapping.getName() ] );
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
			// Module Commands
			case "reloadModules": {
				controller.getModuleService().reloadAll();
				break;
			}
			case "unloadModules": {
				controller.getModuleService().unloadAll();
				break;
			}
			case "reloadModule": {
				controller.getModuleService().reload( event.getValue( "module", "" ) );
				break;
			}
			case "unloadModule": {
				controller.getModuleService().unload( event.getValue( "module", "" ) );
				break;
			}
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
				variables.debuggerService.renderCachePanel();
				break;
			}
			default:
				return;
		}

		// relocate to correct panel
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
