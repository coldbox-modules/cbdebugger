/**
 * CBOrm Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";
	property name="entityService"   inject="entityService";

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, interceptData, rc, prc ){
		arguments.interceptData.requestTracker[ "cborm" ] = { "grouped" : {}, "all" : [] };
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
		var requestTracker                 = variables.debuggerService.getRequestTracker();
		param requestTracker.cborm         = {};
		param requestTracker.cborm.grouped = {};
		param requestTracker.cborm.all     = [];
		// Hash the incoming sql, this is our key lookup
		var sqlHash                        = hash( arguments.interceptData.query );

		// Do grouping check by hash
		if (
			!structKeyExists(
				requestTracker.cborm.grouped,
				sqlHash
			)
		) {
			requestTracker.cborm.grouped[ sqlHash ] = {
				"sql"     : arguments.interceptData.query,
				"count"   : 0,
				"records" : []
			};
		}

		// Prepare log struct
		var logData = {
			"timestamp"     : now(),
			"type"          : "executeQuery",
			"sql"           : arguments.interceptData.query,
			"params"        : variables.debuggerConfig.cborm.logParams ? serializeJSON( arguments.interceptData.params ) : {},
			"unique"        : arguments.interceptData.unique,
			"options"       : serializeJSON( arguments.interceptData.options ),
			"executionTime" : getTickCount() - arguments.interceptData.options.startCount,
			"caller"        : variables.debuggerService.discoverCallingStack( "executeQuery" )
		};

		// Log by Group
		requestTracker.cborm.grouped[ sqlHash ].count++;
		requestTracker.cborm.grouped[ sqlHash ].records.append( logData );

		// Log by timeline
		requestTracker.cborm.all.append( logData );
	}

	/**
	 * Listen before list() operations
	 */
	function beforeCriteriaBuilderList( event, interceptData, rc, prc ){
		arguments.interceptData.criteriaBuilder._cbdStartCount = getTickCount();
	}

	/**
	 * Listen after list() operations
	 */
	function afterCriteriaBuilderList( event, interceptData, rc, prc ){
		logCriteriaQuery(
			arguments.event,
			arguments.interceptData,
			"list"
		);
	}

	/**
	 * Listen before count() operations
	 */
	function beforeCriteriaBuilderCount( event, interceptData, rc, prc ){
		arguments.interceptData.criteriaBuilder._cbdStartCount = getTickCount();
	}

	/**
	 * Listen after count() operations
	 */
	function afterCriteriaBuilderCount( event, interceptData, rc, prc ){
		logCriteriaQuery(
			arguments.event,
			arguments.interceptData,
			"count"
		);
	}

	/**
	 * Listen before get() operations
	 */
	function beforeCriteriaBuilderGet( event, interceptData, rc, prc ){
		arguments.interceptData.criteriaBuilder._cbdStartCount = getTickCount();
	}

	/**
	 * Listen after get() operations
	 */
	function afterCriteriaBuilderGet( event, interceptData, rc, prc ){
		logCriteriaQuery(
			arguments.event,
			arguments.interceptData,
			"get"
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
		requestTracker.cborm[ "totalQueries" ]       = requestTracker.cborm.all.len();
		requestTracker.cborm[ "totalExecutionTime" ] = requestTracker.cborm.all.reduce( function( total, q ){
			return arguments.total + arguments.q.executionTime;
		}, 0 );
	}

	/**
	 * Log the criteria queries
	 */
	private function logCriteriaQuery( event, interceptData, type ){
		// Get the timer start count
		var startCount    = arguments.interceptData.criteriaBuilder._cbdStartCount;
		var executionTime = 0;
		if ( len( startCount ) && isNumeric( startCount ) ) {
			executionTime = getTickCount() - startCount;
		}
		// Get the request tracker so we can add our timing goodness!
		var requestTracker                 = variables.debuggerService.getRequestTracker();
		param requestTracker.cborm         = {};
		param requestTracker.cborm.grouped = {};
		param requestTracker.cborm.all     = [];
		// Hash the incoming sql, this is our key lookup
		var sql                            = arguments.interceptData.criteriaBuilder.getSQL(
			returnExecutableSql: false,
			formatSql          : false
		);
		var sqlHash = hash( sql );

		// Do grouping check by hash
		if (
			!structKeyExists(
				requestTracker.cborm.grouped,
				sqlHash
			)
		) {
			requestTracker.cborm.grouped[ sqlHash ] = {
				"sql"     : sql,
				"count"   : 0,
				"records" : []
			};
		}

		// Prepare log struct
		var logData = {
			"timestamp" : now(),
			"type"      : arguments.type,
			"sql"       : sql,
			"params"    : variables.debuggerConfig.cborm.logParams ? arguments.interceptData.criteriaBuilder
				.getSqlHelper()
				.getPositionalSQLParameters() : [],
			"unique"        : arguments.type eq "list" ? false : true,
			"options"       : {},
			"executionTime" : executionTime,
			"caller"        : variables.debuggerService.discoverCallingStack( arguments.type, "CriteriaBuilder" )
		};

		// Log by Group
		requestTracker.cborm.grouped[ sqlHash ].count++;
		requestTracker.cborm.grouped[ sqlHash ].records.append( logData );

		// Log by timeline
		requestTracker.cborm.all.append( logData );
	}

}
