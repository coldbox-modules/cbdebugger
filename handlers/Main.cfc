/**
 * Main ColdBox Debugger Visualizer
 */
component extends="coldbox.system.EventHandler" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="timer@cbdebugger";


	/**
	 * Executes before all handler actions
	 */
	any function preHandler(
		event,
		rc,
		prc,
		action,
		eventArguments
	){
		// Incoming Refresh frequency
		event.paramValue( "frequency", 0 );
		// Don't show cf debug
		cfsetting( showdebugoutput = "false" );
	}


	/**
	 * Visualize the debugger as an incoming event
	 */
	any function index( event, rc, prc ){
		// If not enabled, just 404 it
		if ( !variables.debuggerService.getDebugMode() ) {
			event.setHTTPHeader(
				statusCode = 404,
				statusText = "page not found"
			);
			return "Page Not Found";
		}
		return "";
	}


	/**
	 * This action renders out the debugger back to the caller as HTML widget
	 */
	function renderDebugger( event, rc, prc ){
		// Are we in debug mode or not? If not, just return empty string
		if ( !variables.debuggerService.getDebugMode() ) {
			return "";
		}

		// Return the debugger layout+view
		return renderLayout(
			layout    : "Main",
			module    : "cbdebugger",
			view      : "main/debugger",
			viewModule: "cbdebugger",
			args      : {
				debugStartTime   : getTickCount(),
				refreshFrequency : rc.frequency,
				urlBase          : event.buildLink( "" ),
				inetHost         : variables.debuggerService.getInetHost(),
				loadedModules    : variables.controller.getModuleService().getLoadedModules(),
				moduleSettings   : getSetting( "modules" ),
				debuggerService  : variables.debuggerService,
				debuggerConfig   : getModuleSettings( "cbdebugger" ),
				httpResponse     : variables.debuggerService.getPageContextResponse(),
				debugTimers      : variables.timerService.getSortedTimers(),
				tracers          : variables.debuggerService.getTracers(),
				profilers        : variables.debuggerService.getProfilers(),
				manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes"
			}
		);
	}

	/**
	 * This action renders out the profiler panel back as HTML
	 */
	function renderProfiler( event, rc, prc ){
		// Are we in debug mode or not? If not, just return empty string
		if ( !variables.debuggerService.getDebugMode() ) {
			return "";
		}

		// Return the debugger layout+view
		return renderLayout(
			layout    : "Monitor",
			module    : "cbdebugger",
			view      : "main/profilers",
			viewModule: "cbdebugger",
			args      : {
				currentPanel     : "profiler",
				pageTitle        : "ColdBox Request Tracker",
				refreshFrequency : rc.frequency,
				urlBase          : event.buildLink( "" ),
				profilers        : variables.debuggerService.getProfilers(),
				tracers          : variables.debuggerService.getTracers(),
				debuggerConfig   : getModuleSettings( "cbdebugger" ),
				manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes"
			}
		);
	}

	/**
	 * This action renders out the caching panels
	 */
	function renderCacheMonitor( event, rc, prc ){
		// Are we in debug mode or not? If not, just return empty string
		if ( !variables.debuggerService.getDebugMode() ) {
			return "";
		}

		// Incoming Refresh frequency
		event.paramValue( "frequency", 0 );

		// Return the debugger layout+view
		return renderLayout(
			layout    : "Monitor",
			module    : "cbdebugger",
			view      : "main/cacheMonitor",
			viewModule: "cbdebugger",
			args      : {
				pageTitle    : "ColdBox CacheBox Monitor",
				manifestRoot : event.getModuleRoot( "cbDebugger" ) & "/includes"
			}
		);
	}

}
