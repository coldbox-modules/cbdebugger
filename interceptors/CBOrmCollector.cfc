/**
 * CBOrm Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="Timer@cbdebugger";
	property name="entityService"   inject="entityService";

	/**
	 * Listen before list() operations
	 */
	function beforeCriteriaBuilderList( event, interceptData, rc, prc ){
		arguments.interceptData.criteriaBuilder.getNativeCriteria().setComment( getTickCount() );
	}

	/**
	 * Listen after list() operations
	 */
	function afterCriteriaBuilderList( event, interceptData, rc, prc ){
		logCriteriaQuery(
			arguments.event,
			arguments.interceptData,
			"lists"
		);
	}

	/**
	 * Listen before count() operations
	 */
	function beforeCriteriaBuilderCount( event, interceptData, rc, prc ){
		arguments.interceptData.criteriaBuilder.getNativeCriteria().setComment( getTickCount() );
	}

	/**
	 * Listen after count() operations
	 */
	function afterCriteriaBuilderCount( event, interceptData, rc, prc ){
		logCriteriaQuery(
			arguments.event,
			arguments.interceptData,
			"counts"
		);
	}

	/**
	 * Listen before get() operations
	 */
	function beforeCriteriaBuilderGet( event, interceptData, rc, prc ){
		arguments.interceptData.criteriaBuilder.getNativeCriteria().setComment( getTickCount() );
	}

	/**
	 * Listen after get() operations
	 */
	function afterCriteriaBuilderGet( event, interceptData, rc, prc ){
		logCriteriaQuery(
			arguments.event,
			arguments.interceptData,
			"gets"
		);
	}

	/**
	 * Listen when request tracker is being recorded
	 */
	function onDebuggerProfilerRecording( event, interceptData, rc, prc ){
		// Let's param our tracking variables.
		param arguments.interceptData.requestTracker.cborm        = {};
		param arguments.interceptData.requestTracker.cborm.lists  = [];
		param arguments.interceptData.requestTracker.cborm.gets   = [];
		param arguments.interceptData.requestTracker.cborm.counts = [];

		// Store session stats
		arguments.interceptData.requestTracker.cborm[ "sessionStats" ]         = variables.entityService.getSessionStatistics();
		// Store totals
		arguments.interceptData.requestTracker.cborm[ "totalCriteriaQueries" ] = arguments.interceptData.requestTracker.cborm.lists.len() +
		arguments.interceptData.requestTracker.cborm.gets.len() +
		arguments.interceptData.requestTracker.cborm.counts.len();
		// Total query execution times
		arguments.interceptData.requestTracker.cborm[ "totalListsExecutionTime" ] = arguments.interceptData.requestTracker.cborm.lists.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
		arguments.interceptData.requestTracker.cborm[ "totalGetsExecutionTime" ] = arguments.interceptData.requestTracker.cborm.gets.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
		arguments.interceptData.requestTracker.cborm[ "totalCountsExecutionTime" ] = arguments.interceptData.requestTracker.cborm.counts.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
		// Total of totals
		arguments.interceptData.requestTracker.cborm[ "totalCriteriaQueryExecutionTime" ] = arguments.interceptData.requestTracker.cborm[
			"totalListsExecutionTime"
		] +
		arguments.interceptData.requestTracker.cborm[ "totalGetsExecutionTime" ] +
		arguments.interceptData.requestTracker.cborm[ "totalCountsExecutionTime" ];
	}

	/**
	 * Log the criteria queries
	 */
	private function logCriteriaQuery( event, interceptData, type ){
		// Get the timer
		var startCount    = arguments.interceptData.criteriaBuilder.getNativeCriteria().getComment();
		var executionTime = 0
		if ( len( startCount ) && isNumeric( startCount ) ) {
			executionTime = getTickCount() - startCount;
		}

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
			),
			"executionTime" : executionTime
		} );
	}

}
