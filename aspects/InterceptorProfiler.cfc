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
	function init( required excludedInterceptions, required includedInterceptions ){
		variables.excludedInterceptions = arguments.excludedInterceptions;
		variables.includedInterceptions = arguments.includedInterceptions;
		return this;
	}

	/**
	 * The AOP method invocation
	 */
	any function invokeMethod( required invocation ){
		// Quick exit check: If no included interceptions, just bail
		if ( !arrayLen( variables.includedInterceptions ) ) {
			return arguments.invocation.proceed();
		}

		// Start target checks
		var targetArgs = arguments.invocation.getArgs();

		// Get the state either by name or position
		if ( structKeyExists( targetArgs, "state" ) ) {
			var state = targetArgs.state;
		} else {
			var state = targetArgs[ 1 ];
		}

		// Do we need to profile it or not?
		if (
			arrayContainsNoCase( variables.excludedInterceptions, state ) && !arrayContainsNoCase(
				variables.includedInterceptions,
				state
			)
		) {
			return arguments.invocation.proceed();
		}

		// Build Transaction name
		var txName = "[Interception] #state#";

		// Get intercept data by name or position
		if ( structKeyExists( targetArgs, "data" ) ) {
			var data = targetArgs.data;
		} else {
			var data = targetArgs[ 2 ];
		}

		// Is this an entity interception? If so, log it to assist
		if ( data.keyExists( "entity" ) ) {
			txName &= "( #getEntityName( data )# ) @ #getTickCount()#";
		}

		// create FR tx with method name
		variables.timerService.start( label: txName, type: "interceptor" );
		// proceed invocation
		var results = arguments.invocation.proceed();
		// close tx
		variables.timerService.stop( txName );
		// return results
		if ( !isNull( results ) ) {
			return results;
		}
	}

	/**
	 * Try to discover an entity name from the passed intercept data
	 */
	private string function getEntityName( required data ){
		// If passed, just relay it back
		if ( arguments.data.keyExists( "entityName" ) ) {
			return arguments.data.entityName;
		}

		// Check if we have a quick entity
		if ( structKeyExists( arguments.data.entity, "mappingName" ) ) {
			return arguments.data.entity.mappingName();
		}

		// Short-cut discovery via ActiveEntity
		if ( structKeyExists( arguments.data.entity, "getEntityName" ) ) {
			return arguments.data.entity.getEntityName();
		} else {
			// it must be in session.
			return ormGetSession().getEntityName( arguments.data.entity );
		}
	}

}
