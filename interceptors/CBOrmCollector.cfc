/**
 * CBOrm Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="Timer@cbdebugger";
	property name="entityService"   inject="entityService";

	/**
	 * Configure this interceptor
	 */
	function configure(){
		// get formatter for sql string beautification: ACF vs Lucee
		if (
			findNoCase(
				"coldfusion",
				server.coldfusion.productName
			)
		) {
			// Formatter Support
			variables.formatter = createObject(
				"java",
				"org.hibernate.engine.jdbc.internal.BasicFormatterImpl"
			);
		}
		// Old Lucee Hibernate 3
		else {
			variables.formatter = createObject(
				"java",
				"org.hibernate.jdbc.util.BasicFormatterImpl"
			);
		}
	}

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, interceptData, rc, prc ){
		arguments.interceptData.requestTracker[ "cborm" ] = {
			"lists"        : [],
			"gets"         : [],
			"counts"       : [],
			"executeQuery" : []
		};
	}

	/**
	 * Listen before executeQuery() operations
	 */
	function beforeOrmExecuteQuery( event, interceptData, rc, prc ){
		arguments.interceptData.options.startCount = getTickCount();
	}

	/**
	 * Listen after executeQuery() operations
	 */
	function afterOrmExecuteQuery( event, interceptData, rc, prc ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();
		// Log the sql according to type
		requestTracker.cborm[ "executeQuery" ].append( {
			"timestamp"     : now(),
			"sql"           : variables.formatter.format( arguments.interceptData.query ),
			"params"        : serializeJSON( arguments.interceptData.params ),
			"unique"        : arguments.interceptData.unique,
			"options"       : serializeJSON( arguments.interceptData.options ),
			"executionTime" : getTickCount() - arguments.interceptData.options.startCount
		} );
	}

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
		var requestTracker = arguments.interceptData.requestTracker;

		// Store session stats
		requestTracker.cborm[ "sessionStats" ] = variables.entityService.getSessionStatistics();

		// Store total number of queries executed
		requestTracker.cborm[ "totalCriteriaQueries" ] = requestTracker.cborm.lists.len() +
		requestTracker.cborm.gets.len() +
		requestTracker.cborm.counts.len() +
		requestTracker.cborm.executeQuery.len();

		// Total query execution times for each section
		requestTracker.cborm[ "totalListsExecutionTime" ] = requestTracker.cborm.lists.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
		requestTracker.cborm[ "totalGetsExecutionTime" ] = requestTracker.cborm.gets.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
		requestTracker.cborm[ "totalCountsExecutionTime" ] = requestTracker.cborm.counts.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
		requestTracker.cborm[ "totalExecuteQueryExecutionTime" ] = requestTracker.cborm.executeQuery.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );

		// Total of totals
		requestTracker.cborm[ "totalCriteriaQueryExecutionTime" ] = requestTracker.cborm[ "totalListsExecutionTime" ] +
		requestTracker.cborm[ "totalGetsExecutionTime" ] +
		requestTracker.cborm[ "totalCountsExecutionTime" ] +
		requestTracker.cborm[ "totalExecuteQueryExecutionTime" ];
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
