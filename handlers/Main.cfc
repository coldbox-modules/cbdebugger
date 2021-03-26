/**
 * Main ColdBox Debugger Visualizer
 */
component extends="coldbox.system.RestHandler" {

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
		// If not enabled, just 404 it
		if ( !variables.debuggerService.getDebugMode() ) {
			event.setHTTPHeader(
				statusCode = 404,
				statusText = "page not found"
			);
			return "Page Not Found";
		}
	}


	/**
	 * Visualize the debugger as an incoming event
	 */
	any function index( event, rc, prc ){
		return "";
	}

	/**
	 * This action renders out the debugger back to the caller as HTML widget
	 */
	function renderDebugger( event, rc, prc ){
		// are we in visualizer mode?
		var isVisualizer = event.getCurrentEvent() eq "cbdebugger:main.index";

		// Return the debugger layout+view
		return renderLayout(
			layout    : isVisualizer ? "Monitor" : "Main",
			module    : "cbdebugger",
			view      : "main/debugger",
			viewModule: "cbdebugger",
			args      : {
				pageTitle        : "ColdBox Debugger",
				currentPanel     : "",
				debugStartTime   : getTickCount(),
				refreshFrequency : rc.frequency,
				urlBase          : event.buildLink( "" ),
				loadedModules    : variables.controller.getModuleService().getLoadedModules(),
				moduleSettings   : getSetting( "modules" ),
				debuggerConfig   : getModuleSettings( "cbdebugger" ),
				debuggerService  : variables.debuggerService,
				environment      : variables.debuggerService.getEnvironment(),
				tracers          : variables.debuggerService.getTracers(),
				profilers        : variables.debuggerService.getProfilers(),
				manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes"
			}
		);
	}

	/**
	 * This action renders out the caching panels
	 */
	function renderCacheMonitor( event, rc, prc ){
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

	/**
	 * Clear the profilers via ajax
	 */
	function clearProfilers( event, rc, prc ){
		variables.debuggerService.resetProfilers();
		event.getResponse().addMessage( "Profilers reset!" );
	}

	/**
	 * Get the profilers via ajax
	 */
	function renderProfilers( event, rc, prc ){
		return renderView(
			view  : "main/partials/profilers",
			module: "cbdebugger",
			args  : {
				environment    : variables.debuggerService.getEnvironment(),
				profilers      : variables.debuggerService.getProfilers(),
				debuggerConfig : getModuleSettings( "cbdebugger" )
			},
			prePostExempt: true
		);
	}

	/**
	 * Get a profiler report via ajax
	 */
	function renderProfilerReport( event, rc, prc ){
		return renderView(
			view  : "main/partials/profilerReport",
			module: "cbdebugger",
			args  : {
				environment    : variables.debuggerService.getEnvironment(),
				profiler       : variables.debuggerService.getProfilerById( rc.id ),
				debuggerConfig : getModuleSettings( "cbdebugger" )
			},
			prePostExempt: true
		);
	}

}
