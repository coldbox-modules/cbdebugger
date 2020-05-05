/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component {

	// Module Properties
	this.title 				= "ColdBox Debugger";
	this.author 			= "Curt Gratz - Ortus Solutions";
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
	// Auto Map Models Directory
	this.autoMapModels		= true;
	// App Helpers
	this.applicationHelper = [
		"models/Mixins.cfm"
	];

	/**
	* Module Registration
	*/
	function configure(){

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
		var settings = controller.getConfigSettings();
		// parse parent settings
		parseParentSettings();

		//default the password to something so we are secure by default
		if( settings.debugger.debugPassword eq "cb:null" ){
			settings.debugger.debugPassword = hash( getCurrentTemplatePath() );
		} else if ( len( settings.debugger.debugPassword ) ) {
			// hash the password into memory
			settings.debugger.debugPassword = hash( settings.debugger.debugPassword );
		}

		// set debug mode?
		wirebox.getInstance( "debuggerService@cbDebugger" )
			.setDebugMode( settings.debugger.debugMode );

		// Register the interceptor, it has to be here due to loading of configuration files.
		controller
			.getInterceptorService()
			.registerInterceptor(
				interceptorClass	= "#moduleMapping#.interceptors.Debugger",
				interceptorName		= "debugger@cbdebugger"
			);

		if ( settings.debugger.showQBPanel && controller.getModuleService().isModuleRegistered( "qb" ) ) {
			controller
				.getInterceptorService()
				.registerInterceptor(
					interceptorClass	= "#moduleMapping#.interceptors.QBCollector",
					interceptorName		= "QBCollector@cbdebugger"
				);
		}

		if ( settings.debugger.showQBPanel && controller.getModuleService().isModuleRegistered( "quick" ) ) {
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
		controller.getInterceptorService().unregister( interceptorName="debugger@cbdebugger" );

		// Remove application helper
		var appHelperArray 	= controller.getSetting( "ApplicationHelper" );
		var mixinToRemove 	= "#moduleMapping#/models/Mixins.cfm";
		var mixinIndex 		= arrayFindNoCase( appHelperArray, mixinToRemove );

		// If the mixin is in the array
		if( mixinIndex ) {
			// Remove it
			arrayDeleteAt( appHelperArray, mixinIndex );
			// Arrays passed by value in Adobe CF
			controller.setSetting( "ApplicationHelper", appHelperArray );
		}
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var debuggerDSL 	= oConfig.getPropertyMixin( "debugger", "variables", structnew() );

		//defaults
		configStruct.debugger = {
			debugMode = controller.getSetting( "environment", "production" ) == "development",
			debugPassword = "cb:null",
			enableDumpVar = true,
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

		// incorporate settings
		structAppend( configStruct.debugger, debuggerDSL, true );
	}

	// This appender is part of a module, so we need to register it after the modules have been loaded.
	function afterConfigurationLoad() {
	    var logBox = controller.getLogBox();
	    // Only 4.3
	    if( !findNoCase( "4.3", controller.getSetting( "version", true ) ) ){
	    	return;
	    }
	    logBox.registerAppender( 'tracer', 'cbdebugger.includes.appenders.ColdboxTracerAppender' );
    	var appenders = logBox.getAppendersMap( 'tracer' );
    	// Register the appender with the root loggger, and turn the logger on.
	    var root = logBox.getRootLogger();
	    root.addAppender( appenders[ 'tracer' ] );
	    root.setLevelMax( 4 );
	    root.setLevelMin( 0 );

	}
}
