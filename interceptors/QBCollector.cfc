/**
 * QB Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";

	// Before we capture.
	function postQBExecute( event, interceptData, rc, prc ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();

		// Let's param our tracking variables.
		param requestTracker.qbQueries         = {};
		param requestTracker.qbQueries.grouped = {};
		param requestTracker.qbQueries.all     = [];

		// Collect baby!
		arguments.interceptData.timestamp = now();
		if (
			!structKeyExists(
				requestTracker.qbQueries.grouped,
				arguments.interceptData.sql
			)
		) {
			requestTracker.qbQueries.grouped[ arguments.interceptData.sql ] = [];
		}
		requestTracker.qbQueries.grouped[ arguments.interceptData.sql ].append( arguments.interceptData );
		requestTracker.qbQueries.all.append( arguments.interceptData );
	}

}
