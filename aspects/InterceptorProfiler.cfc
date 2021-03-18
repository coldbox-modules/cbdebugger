/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Profiles interception calls so we can profile them
 */
component implements="coldbox.system.aop.MethodInterceptor" accessors="true" {

	// DI
	property name="timerService" inject="Timer@cbdebugger";
	property name="debuggerService" inject="debuggerService@cbdebugger";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * The AOP method invocation
	 */
	any function invokeMethod( required invocation ) output=false{
		var args = arguments.invocation.getArgs();

		var txName = "coldbox/" & arguments.invocation.getTargetName() &
		"/interceptor:" & arguments.invocation.getMethod();

		// state
		if ( structKeyExists( args, "state" ) ) {
			txName &= ":#args.state#";
		} else if ( structKeyExists( args, 1 ) and isSimpleValue( args[ 1 ] ) ) {
			txName &= ":" & args[ 1 ];
		}

		// create FR tx with method name
		var tx = FRTransactionProvider.get().init( txName );

		// Trace interceptData
		if ( structKeyExists( args, "interceptData" ) ) {
			tx.setProperty(
				"interceptData",
				args[ "interceptData" ]
			);
		} else if ( structKeyExists( args, "2" ) ) {
			tx.setProperty( "interceptData", args[ 2 ] );
		}

		// proceed invocation
		var results = arguments.invocation.proceed();
		// close tx
		tx.close();
		// return results
		if ( !isNull( results ) ) {
			return results;
		}
	}

}
