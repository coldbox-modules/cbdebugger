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
				debugStartTime   : getTickCount(),
				refreshFrequency : rc.frequency,
				urlBase          : event.buildLink( "" ),
				loadedModules    : variables.controller.getModuleService().getLoadedModules(),
				moduleSettings   : getSetting( "modules" ),
				debuggerConfig   : getModuleSettings( "cbdebugger" ),
				debuggerService  : variables.debuggerService,
				environment      : variables.debuggerService.getEnvironment(),
				profilers        : variables.debuggerService.getProfilers(),
				manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes"
			}
		);
	}

	/**
	 * This action renders out the caching panel only
	 */
	function renderCacheMonitor( event, rc, prc ){
		// Return the debugger layout+view
		return renderView(
			view  : "main/cacheMonitor",
			module: "cbdebugger"
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

	/**
	 * Reload all modules
	 */
	function reloadAllModules( event, rc, prc ){
		variables.controller.getModuleService().reloadAll();
		event.getResponse().addMessage( "Modules Reloaded!" );
	}

	/**
	 * Unload a modules
	 */
	function unloadModule( event, rc, prc ){
		event.paramValue( "module", "" );
		// variables.controller.getModuleService().unload( rc.module );
		event.getResponse().addMessage( "Module #rc.module# Unloaded!" );
	}

	/**
	 * Reload a modules
	 */
	function reloadModule( event, rc, prc ){
		event.paramValue( "module", "" );
		variables.controller.getModuleService().reload( rc.module );
		event.getResponse().addMessage( "Module #rc.module# reloaded!" );
	}

	/**
	 * Get runtime environment
	 */
	function environment( event, rc, prc ){
		event.getResponse().setData( variables.debuggerService.getEnvironment() );
	}

}
