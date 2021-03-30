/**
 * CBOrm Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="entityService"   inject="entityService";

	/**
	 * Listen after list() operations
	 */
	function afterCriteriaBuilderList( event, interceptData, rc, prc ){
		logCriteriaQuery( event, interceptData, "lists" );
	}

	/**
	 * Listen after count() operations
	 */
	function afterCriteriaBuilderCount( event, interceptData, rc, prc ){
		logCriteriaQuery( event, interceptData, "counts" );
	}

	/**
	 * Listen after get() operations
	 */
	function afterCriteriaBuilderGet( event, interceptData, rc, prc ){
		logCriteriaQuery( event, interceptData, "gets" );
	}

	/**
	 * Listen when request tracker is being recorded
	 */
	function onDebuggerProfilerRecording( event, interceptData, rc, prc ){
		// Let's param our tracking variables.
		param arguments.interceptData.requestTracker.cborm             = {};
		// Store session stats
		arguments.interceptData.requestTracker.cborm[ "sessionStats" ] = variables.entityService.getSessionStatistics();
	}

	/**
	 * Log the criteria queries
	 */
	private function logCriteriaQuery( event, interceptData, type ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();

		// Let's param our tracking variables.
		param requestTracker.cborm        = {};
		param requestTracker.cborm.lists  = [];
		param requestTracker.cborm.gets   = [];
		param requestTracker.cborm.counts = [];

		// Log the sql according to type
		requestTracker.cborm[ arguments.type ].append( {
			"timestamp" : now(),
			"sql"       : arguments.interceptData.criteriaBuilder.getSQL(
				returnExecutableSql: true,
				formatSql          : true
			)
		} );
	}

}
