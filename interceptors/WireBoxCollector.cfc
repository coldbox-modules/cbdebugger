/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This intereceptor collects request information into the appropriate debugger or
 * timing services
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="timer@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";

	/**
	 * Configure
	 */
	function configure(){
	}

	/**
	 * Listen before wirebox objects are created
	 */
	function beforeInstanceCreation( event, interceptData, rc, prc ){
		variables.timerService.start(
			label   : "[Wirebox Creation] #arguments.interceptData.mapping.getName()#",
			metadata: {
				path : "",
				name : arguments.interceptData.mapping.getName(),
				type : arguments.interceptData.mapping.getType(),
				line : 1
			},
			type: "wirebox-creation"
		);
	}

	/**
	 * Listen to after objects are created and DI is done
	 */
	function afterInstanceCreation( event, interceptData, rc, prc ){
		variables.timerService.stop(
			label   : "[Wirebox Creation] #arguments.interceptData.mapping.getName()#",
			metadata: {
				path : arguments.interceptData.mapping.getObjectMetadata()?.path ?: arguments.interceptData.mapping.getPath()
			}
		);
	}

	/************************************** PRIVATE METHODS *********************************************/

}
