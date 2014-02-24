/**
ColdBox Debugger Module
*/
component {

	// Module Properties
	this.title 				= "ColdBox Debugger";
	this.author 			= "Curt Gratz";
	this.webURL 			= "http://www.coldbox.org";
	this.description 		= "The ColdBox Debugger Module";
	this.version			= "0.1";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbDebugger";

	function configure(){

		// Custom Declared Interceptors
		interceptors = [
			{class="#moduleMapping#.interceptors.debugger",name="debugger@cbDebugger"}
		];


		binder.map("debuggerService@cbDebugger").to("#moduleMapping#.model.debuggerService");
		binder.map("debuggerConfig@cbDebugger").to("#moduleMapping#.model.debuggerConfig");


	}

}