/**
 * Main ColdBox Debugger Visualizer
 */
component extends="coldbox.system.RestHandler" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="timer@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:modulesettings:cbdebugger";

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
		// Global params
		event.paramValue( "frequency", 0 ).paramValue( "isVisualizer", false );

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
	 * Visualize the request tracker
	 */
	any function index( event, rc, prc ){
		return renderDebugger( argumentCollection = arguments );
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
				isVisualizer     : isVisualizer,
				pageTitle        : "ColdBox Debugger",
				debugStartTime   : getTickCount(),
				refreshFrequency : rc.frequency,
				urlBase          : event.buildLink( "" ),
				moduleSettings   : variables.debuggerConfig.modules.enabled ? getSetting( "modules" ) : {},
				debuggerConfig   : variables.debuggerConfig,
				debuggerService  : variables.debuggerService,
				environment      : variables.debuggerService.getEnvironment(),
				profilers        : variables.debuggerService.getProfilerStorage(),
				currentProfiler  : variables.debuggerService.getCurrentProfiler(),
				manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes"
			}
		);
	}

	/**
	 * This action renders out the caching panel only
	 */
	function renderCacheMonitor( event, rc, prc ){
		return renderView(
			view  : "main/panels/cacheBoxPanel",
			module: "cbdebugger",
			args  : { debuggerConfig : variables.debuggerConfig }
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
		// Sorting: timestamp, executionTime
		event.paramValue( "sortBy", "timestamp" )
			.paramValue( "sortOrder", "desc" );

		// Get the profilers
		var aProfilers = variables.debuggerService.getProfilerStorage();

		// Sorting?
		switch( rc.sortBy ){
			case "executionTime" : {
				arraySort( aProfilers, function( e1, e2 ){
					if( rc.sortOrder == "asc" ){
						return ( arguments.e1.executionTime < arguments.e2.executionTime ? -1 : 1 );
					}
					return ( arguments.e1.executionTime > arguments.e2.executionTime ? -1 : 1 );
				} );
				break;
			}
			default: {
				arraySort( aProfilers, function( e1, e2 ){
					if( rc.sortOrder == "asc" ){
						return dateCompare( arguments.e1.timestamp, arguments.e2.timestamp );
					}
					return dateCompare( arguments.e2.timestamp, arguments.e1.timestamp );
				} );
				break;
			}
		}

		return renderView(
			view  : "main/partials/profilers",
			module: "cbdebugger",
			args  : {
				environment    : variables.debuggerService.getEnvironment(),
				profilers      : aProfilers,
				debuggerConfig : variables.debuggerConfig
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
				debuggerConfig : variables.debuggerConfig,
				isVisualizer   : rc.isVisualizer
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
