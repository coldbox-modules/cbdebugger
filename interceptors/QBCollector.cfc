/**
 * QB Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, interceptData, rc, prc ){
		arguments.interceptData.requestTracker[ "qbQueries" ] = { "grouped" : {}, "all" : [] };
	}

	// Before we capture.
	function postQBExecute( event, interceptData, rc, prc ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();

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
