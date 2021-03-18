/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component {

	// Module Properties
	this.title 				= "ColdBox Debugger";
	this.author 			= "Curt Gratz - Ortus Solutions";
	this.version 			= "@build.version@+@build.number@";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "The ColdBox Debugger Module";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbdebugger";
	// CF Mapping
	this.cfMapping			= "cbdebugger";
	// Model Namespace
	this.modelNamespace		= "cbdebugger";
	// App Helpers
	this.applicationHelper = [
		"helpers/Mixins.cfm"
	];

	/**
	* Module Registration
	*/
	function configure(){

		/**
		 * Settings
		 */
		variables.settings = {
			// Turn the debugger on/off by default
			debugMode = controller.getSetting( name = "environment", defaultValue = "production" ) == "development",
			// The URL password to use to activate it on demand
			debugPassword = "cb:null",
			// Persist request tracking profilers
			persistentRequestProfiler = true,
			// How many tracking profilers to keep in stack: Default is monitor the last 10 requests
			maxPersistentRequestProfilers = 10,
			wireboxCreationProfiler=false,
			// How many rows to dump for object collections if the RC panel is activated
			maxRCPanelQueryRows = 50,
			// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
			slowExecutionThreshold = 200,
			/**
			 * PANEL VISIBILITY SETTINGS
			 */

			// Activate the tracer panel
			showTracerPanel = true,
			// Show the panel expanded by default
			expandedTracerPanel = true,
			// Show the info tracking panel
			showInfoPanel = true,
			// Show the panel expanded by default
			expandedInfoPanel = true,
			// Show the cache report panel
			showCachePanel = true,
			// Show the panel expanded by default
			expandedCachePanel = false,
			// Show the RC/PRC collection panels
			showRCPanel = true,
			// Show the panel expanded by default
			expandedRCPanel = false,
			// Show the modules panel
			showModulesPanel = true,
			// Show the panel expanded by default
			expandedModulesPanel = false,
			// Show the QB Panel
			showQBPanel = true,
			// Show the panel expanded by default
			expandedQBPanel = false
		};

		// Visualizer Route
		router
			.route( "/" ).to( "Main.index" );

		/**
		 * Custom Interception Points
		 */
		variables.interceptorSettings = {
			customInterceptionPoints = [
				"beforeDebuggerPanel",
				"afterDebuggerPanel"
			]
		};

	}

	/**
	* Load the module
	*/
	function onLoad(){
		// default the password to something so we are secure by default
		if( variables.settings.debugPassword eq "cb:null" ){
			variables.settings.debugPassword = hash( getCurrentTemplatePath() );
		} else if ( len( variables.settings.debugPassword ) ) {
			// hash the password into memory
			variables.settings.debugPassword = hash( variables.settings.debugPassword );
		}

		// set debug mode?
		wirebox.getInstance( "debuggerService@cbDebugger" )
			.setDebugMode( variables.settings.debugMode );

		// Register the interceptor, it has to be here due to loading of configuration files.
		controller
			.getInterceptorService()
			.registerInterceptor(
				interceptorClass	= "#moduleMapping#.interceptors.Debugger",
				interceptorName		= "debugger@cbdebugger"
			);

		// Register QB Collector
		if ( variables.settings.showQBPanel && controller.getModuleService().isModuleRegistered( "qb" ) ) {
			controller
				.getInterceptorService()
				.registerInterceptor(
					interceptorClass	= "#moduleMapping#.interceptors.QBCollector",
					interceptorName		= "QBCollector@cbdebugger"
				);
		}

		// Register Quick Collector
		if ( variables.settings.showQBPanel && controller.getModuleService().isModuleRegistered( "quick" ) ) {
			controller
				.getInterceptorService()
				.registerInterceptor(
					interceptorClass	= "#moduleMapping#.interceptors.QuickCollector",
					interceptorName		= "QuickCollector@cbdebugger"
				);
		}
	}

	/**
	 * Unloading
	 */
	function onUnload(){
		// unregister interceptor
		controller.getInterceptorService().unregister( "debugger@cbdebugger" );
	}

	/**
	 * Register our tracer appender
	 */
	function afterConfigurationLoad() {
	    var logBox = controller.getLogBox();
	    logBox.registerAppender( 'tracer', 'cbdebugger.includes.appenders.ColdboxTracerAppender' );
    	var appenders = logBox.getAppendersMap( 'tracer' );
    	// Register the appender with the root loggger, and turn the logger on.
	    var root = logBox.getRootLogger();
	    root.addAppender( appenders[ 'tracer' ] );
	    root.setLevelMax( 4 );
	    root.setLevelMin( 0 );
	}
}
