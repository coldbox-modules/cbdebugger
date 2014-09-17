/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component {

	// Module Properties
	this.title 				= "ColdBox Debugger";
	this.author 			= "Curt Gratz";
	this.webURL 			= "http://www.coldbox.org";
	this.description 		= "The ColdBox Debugger Module";
	this.version			= "1.0.0.@build.number@";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbdebugger";
	// CF Mapping
	this.cfMapping			= "cbdebugger";

	function configure(){

		// Custom Declared Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.Debugger", name="debugger@cbdebugger" }
		];

		//default debugmode to false
		if( controller.getSetting( 'debugMode' ,false, '' ) == '' ){
			parentSettings.debugMode = false;
		}

		//default the password to something so we are secure by default
		if( controller.getSetting( 'debugPassword' ,false, '' ) == '' ){
			parentSettings.debugPassword = hash( getCurrentTemplatePath() );
		}

		//default debugging settings
		parentSettings.debuggerSettings = {
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
			showRCSnapshots = false
		};
		structAppend(parentSettings.debuggerSettings, controller.getConfigSettings().coldboxConfig.getPropertyMixin("debugger","variables",structnew()), true);

		//map our models
		binder.map( "debuggerService@cbDebugger" )
			.to( "#moduleMapping#.models.DebuggerService" );
		binder.map( "debuggerConfig@cbDebugger" )
			.to( "#moduleMapping#.models.DebuggerConfig" );

	}
}