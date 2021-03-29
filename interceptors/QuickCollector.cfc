/**
 * QB Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";

	// Before we capture.
	function quickPostLoad( event, interceptData, rc, prc ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();

		// Let's param our tracking variables.
		param requestTracker.quick           = {};
		param requestTracker.quick.total     = 0;
		param requestTracker.quick.byMapping = {};

		// Collect baby!
		if ( !requestTracker.quick.byMapping.keyExists( arguments.interceptData.entity.mappingName() ) ) {
			requestTracker.quick.byMapping[ arguments.interceptData.entity.mappingName() ] = 0;
		}
		requestTracker.quick.byMapping[ arguments.interceptData.entity.mappingName() ] += 1;
		requestTracker.quick.total += 1;
	}

}
