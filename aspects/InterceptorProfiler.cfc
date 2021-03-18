/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Profiles interception calls so we can profile them
 */
component implements="coldbox.system.aop.MethodInterceptor" accessors="true" {

	// DI
	property name="timerService"    inject="Timer@cbdebugger";
	property name="debuggerService" inject="debuggerService@cbdebugger";

	/**
	 * Constructor
	 */
	function init(
		required excludedInterceptions,
		required includedInterceptions
	){
		variables.excludedInterceptions = arguments.excludedInterceptions;
		variables.includedInterceptions = arguments.includedInterceptions;
		return this;
	}

	/**
	 * The AOP method invocation
	 */
	any function invokeMethod( required invocation ){
		var targetArgs = arguments.invocation.getArgs();
		var txName     = "[Interception] ";
		var state      = "";

		// state
		if ( structKeyExists( targetArgs, "state" ) ) {
			state = targetArgs.state;
		} else if ( structKeyExists( targetArgs, 1 ) and isSimpleValue( targetArgs[ 1 ] ) ) {
			state = targetArgs[ 1 ];
		}

		// Do we need to profile it or not?
		if (
			arrayContainsNoCase(
				variables.excludedInterceptions,
				state
			) && !arrayContainsNoCase(
				variables.includedInterceptions,
				state
			)
		) {
			return arguments.invocation.proceed();
		}

		// Verify interceptData
		// var data = {};
		// if ( !isNull( targetArgs.data ) ) {
		//	data = targetArgs.data;
		// }

		// create FR tx with method name
		var labelHash = variables.timerService.start( txName & state );

		// proceed invocation
		var results = arguments.invocation.proceed();

		// close tx
		variables.timerService.stop( labelhash );

		// return results
		if ( !isNull( results ) ) {
			return results;
		}
	}

}
