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
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Global params
		event.paramValue( "frequency", 0 ).paramValue( "isVisualizer", false );

		// Don't show cf debug on ajax calls
		if ( event.isAjax() ) {
			setting showdebugoutput=false;
		}

		// If not enabled, just 404 it
		if ( !variables.debuggerService.getDebugMode() || !variables.debuggerConfig.enabled ) {
			event.overrideEvent( "cbdebugger:main.disabled" );
		}
	}

	/**
	 * Debugger disabled event
	 */
	function disabled( event, rc, prc ){
		event.renderData(
			statusCode = 404,
			statusText = "Not Found",
			type       = "text",
			data       = "Page Not Found"
		);
	}

	/**
	 * Visualize the request tracker
	 */
	any function index( event, rc, prc ){
		paramSorting( rc );
		return renderDebugger( argumentCollection = arguments );
	}

	/**
	 * This action renders out the debugger back to the caller as HTML widget
	 */
	function renderDebugger( event, rc, prc ){
		// are we in visualizer mode?
		var isVisualizer       = event.getCurrentEvent() eq "cbdebugger:main.index";
		setting showdebugoutput=false;
		// Return the debugger layout+view
		// We pass in all the variables needed, to avoid prc/rc conflicts
		return layout(
			layout    : isVisualizer ? "Monitor" : "Main",
			module    : "cbdebugger",
			view      : "main/debugger",
			viewModule: "cbdebugger",
			args      : {
				// Get the current profiler for the current request. Basically the first in the stack
				currentProfiler  : variables.debuggerService.getCurrentProfiler(),
				// Module Config
				debuggerConfig   : variables.debuggerConfig,
				// Service pointer
				debuggerService  : variables.debuggerService,
				// When debugging starts
				debugStartTime   : getTickCount(),
				// Env struct
				environment      : variables.debuggerService.getEnvironment(),
				// Visualizer mode or panel at bottom mode
				isVisualizer     : isVisualizer,
				// Manifest Root
				manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes",
				// Module Root
				moduleRoot       : event.getModuleRoot( "cbDebugger" ),
				// All Module Settings
				moduleSettings   : getSetting( "modules" ),
				// Rendering page title
				pageTitle        : "ColdBox Debugger",
				// Profilers storage to display
				profilers        : variables.debuggerService.getProfilerStorage(),
				// Incoming frequency if in visualizer mode
				refreshFrequency : rc.frequency,
				// Url build base
				urlBase          : event.buildLink( "" )
			}
		);
	}

	/**
	 * This action renders out the caching panel only
	 */
	function renderCacheMonitor( event, rc, prc ){
		return view(
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
		return paramSorting( rc ).view(
			view  : "main/partials/profilers",
			module: "cbdebugger",
			args  : {
				environment    : variables.debuggerService.getEnvironment(),
				profilers      : variables.debuggerService.getProfilers( rc.sortBy, rc.sortOrder ),
				debuggerConfig : variables.debuggerConfig
			},
			prePostExempt: true
		);
	}

	private function paramSorting( rc ){
		param rc.sortBy = "timestamp";
		param rc.sortOrder = "desc";
		if( !len( rc.sortBy ) ){
			rc.sortby = "timestamp";
		}
		if( !len( rc.sortOrder ) ){
			rc.sortOrder = "desc";
		}
		return this;
	}

	/**
	 * Get a profiler report via ajax
	 */
	function renderProfilerReport( event, rc, prc ){
		var profilerReport = variables.debuggerService.getProfilerById( rc.id );

		if ( profilerReport.isEmpty() ) {
			return "<h3 class='cbd-text-red cbd-bg-light-red'>Profiler Id: #encodeForHTML( rc.id )# doesn't exist</h3>";
		}

		return view(
			view  : "main/partials/profilerReport",
			module: "cbdebugger",
			args  : {
				debuggerService : variables.debuggerService,
				environment     : variables.debuggerService.getEnvironment(),
				profiler        : profilerReport,
				debuggerConfig  : variables.debuggerConfig,
				isVisualizer    : rc.isVisualizer
			},
			prePostExempt: true
		);
	}

	/**
	 * Export a profiler report as json
	 */
	function exportProfilerReport( event, rc, prc ){
		return variables.debuggerService.getProfilerById( rc.id );
	}

	/**
	 * Unload a module
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
