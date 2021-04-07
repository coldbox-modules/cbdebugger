/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This profiler monitors the `profile` annotation on model objects and profiles them to the
 * ColdBox debugger timers
 */
component implements="coldbox.system.aop.MethodInterceptor" accessors="true" {

	// DI
	property name="timerService"    inject="Timer@cbdebugger";
	property name="debuggerService" inject="debuggerService@cbdebugger";

	/**
	 * Constructor
	 */
	function init( Boolean traceResults = false ){
		variables.traceResults = arguments.traceResults;
		return this;
	}

	/**
	 * The AOP method invocation
	 */
	any function invokeMethod( required invocation ) output=false{
		// default tx name
		var txName = "[Object Profiler] #arguments.invocation.getTargetName()#.#arguments.invocation.getMethod()#()";

		// check metadata for tx name if they desire to influence the label
		var methodMD = arguments.invocation.getMethodMetadata();
		if ( structKeyExists( methodMD, "profile" ) and len( methodMD.profile ) ) {
			txName = methodMD.profile;
		}

		// create with method name
		var labelhash = variables.timerService.start( txName );

		// proceed invocation
		var results = arguments.invocation.proceed();

		// Stop the timer
		variables.timerService.stop( labelhash );

		// return results
		if ( !isNull( results ) ) {
			// trace results
			if ( variables.traceResults ) {
				variables.debuggerService.pushTracer(
					message  : "Object [#arguments.invocation.getTargetName()#.#arguments.invocation.getMethod()#()] results",
					severity : "debug",
					category : "cbdebugger.ObjectProfiler",
					extraInfo: results
				);
			}
			return results;
		}
	}

}
