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
			debugMode = controller.getSetting( name = "environment", defaultValue = "production" ) == "development",
			debugPassword = "cb:null",
			persistentRequestProfiler = true,
			maxPersistentRequestProfilers = 10,
			maxRCPanelQueryRows = 50,
			showTracerPanel = true,
			expandedTracerPanel = true,
			showInfoPanel = true,
			expandedInfoPanel = true,
			showCachePanel = true,
			expandedCachePanel = false,
			showRCPanel = true,
			expandedRCPanel = false,
			showModulesPanel = true,
			expandedModulesPanel = false,
			showQBPanel = true,
			expandedQBPanel = false,
			showRCSnapshots = false,
			wireboxCreationProfiler=false
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
