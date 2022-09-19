/**
 * QB Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, interceptData, rc, prc ){
		arguments.interceptData.requestTracker[ "qbQueries" ] = { "grouped" : {}, "all" : [] };
	}

	/**
	 * Listen when request tracker is being recorded
	 */
	function onDebuggerProfilerRecording( event, interceptData, rc, prc ){
		var requestTracker = arguments.interceptData.requestTracker;

		// Store total number of queries executed
		requestTracker.qbQueries[ "totalQueries" ]       = requestTracker.qbQueries.all.len();
		requestTracker.qbQueries[ "totalExecutionTime" ] = requestTracker.qbQueries.all.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
	}

	// Before we capture.
	function postQBExecute( event, interceptData, rc, prc ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();
		var sqlHash        = hash( arguments.interceptData.sql );

		// Collect baby!
		arguments.interceptData.timestamp = now();
		if ( !structKeyExists( requestTracker.qbQueries.grouped, sqlHash ) ) {
			requestTracker.qbQueries.grouped[ sqlHash ] = {
				"sql"     : arguments.interceptData.sql,
				"count"   : 0,
				"records" : []
			};
		}

		// Prepare log struct
		var logData = {
			"timestamp"     : arguments.interceptData.timestamp,
			"sql"           : arguments.interceptData.sql,
			"params"        : variables.debuggerConfig.qb.logParams ? arguments.interceptData.bindings : [],
			"options"       : arguments.interceptData.options,
			"executionTime" : arguments.interceptData.executionTime,
			"caller"        : variables.debuggerService.discoverCallingStack( "get", "(QueryBuilder|QuickBuilder)" )
		};

		// Log by Group
		requestTracker.qbQueries.grouped[ sqlHash ].count++;
		requestTracker.qbQueries.grouped[ sqlHash ].records.append( logData );

		// Log by timeline
		requestTracker.qbQueries.all.append( logData );
	}

}
