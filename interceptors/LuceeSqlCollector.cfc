/**
 * Lucee SQL Collector Interecptor
 * Requires debug mode and database activity to be turned on. Just add the following to your .cfconfig.json
 * .
 * <pre>
 * "debuggingDBEnabled":"true",
 * "debuggingEnabled":"true",
 * "debuggingQueryUsageEnabled":"false", // Extra Info
 * </pre>
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, interceptData, rc, prc ){
		// prep collector
		arguments.interceptData.requestTracker[ "cfQueries" ] = {
			"all"                : [],
			"grouped"            : {},
			"totalQueries"       : 0,
			"totalExecutionTime" : 0
		};
	}

	/**
	 * Listen when request tracker is being recorded
	 */
	function onDebuggerProfilerRecording( event, interceptData, rc, prc ){
		var requestTracker = arguments.interceptData.requestTracker;

		// Get the query tracker data
		requestTracker.cfQueries.all = getPageContext()
			.getDebugger()
			.getQueries()
			.map( ( row ) => {
				return {
					"startTime"     : row.getStartTime(),
					"datasource"    : row.getDatasource(),
					"recordCount"   : row.getRecordCount(),
					"executionTime" : row.getExecutionTime(),
					"sql"           : variables.debuggerConfig.luceeSQL.logParams ? row.getSql().toString() : row
						.getSql()
						.getSqlString(),
					"src" : row.getTemplateLine().toString()
				}
			} );

		// Process grouped sql
		requestTracker.cfQueries.all.each( ( row ) => {
			var sqlHash = hash( row.sql );

			if ( !requestTracker.cfQueries.grouped.keyExists( sqlHash ) ) {
				requestTracker.cfQueries.grouped[ sqlHash ] = { "sql" : row.sql, "count" : 0, "records" : [] };
			}

			requestTracker.cfqueries.grouped[ sqlHash ].count++;
			requestTracker.cfqueries.grouped[ sqlHash ].records.append( row );
			variables.debuggerService.pushEvent(
				"transactionId": requestTracker.id,
				"eventType": 'cfquery',
				"timestamp": row.startTime,
				"details": row.sql,
				"executionTimeMillis": row.executionTime,
				"extraInfo": row,
				"caller": row.src
			);
		} );

		// Store total number of queries executed
		requestTracker.cfQueries[ "totalQueries" ]       = requestTracker.cfQueries.all.len();
		requestTracker.cfQueries[ "totalExecutionTime" ] = requestTracker.cfQueries.all.reduce( ( total, q ) => arguments.total + ( arguments.q.executionTime ), 0 );
	}

}
