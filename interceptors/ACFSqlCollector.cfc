/**
 * Adobe ColdFusion SQL Collector Interecptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";

	/**
	 * Ensure the ACF Debugger is online and scoped
	 */
	private function ensureACFDebugger(){
		variables.acfDebuggingService = createObject( "Java", "coldfusion.server.ServiceFactory" ).getDebuggingService();
		// If disabled, turn it on
		if ( !variables.acfDebuggingService.isEnabled() ) {
			variables.acfDebuggingService.setEnabled( javacast( "boolean", true ) );
		}
		// Get the debugger but verify it, since if it is recently enabled it might be null
		variables.acfDebugger = variables.acfDebuggingService.getDebugger();
		if ( isNull( variables.acfDebugger ) ) {
			variables.acfDebuggingService.reset( javacast( "int", 1 ) );
			variables.acfDebugger = variables.acfDebuggingService.getDebugger();
		}
	}

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, interceptData, rc, prc ){
		// Ensure debugger is on
		ensureACFDebugger();
		// prep collector
		arguments.interceptData.requestTracker[ "cfQueries" ] = {
			"all"                : queryNew( "" ),
			"grouped"            : {},
			"totalQueries"       : 0,
			"totalExecutionTime" : 0
		};
	}

	/**
	 * Listen when request tracker is being recorded
	 */
	function onDebuggerProfilerRecording( event, interceptData, rc, prc ){
		var requestTracker           = arguments.interceptData.requestTracker;
		// Get the query tracker data
		requestTracker.cfQueries.all = variables.acfDebugger
			.getData()
			// Store only sql query items
			.filter( function( row ){
				return arguments.row.type == "SqlQuery";
			} )
			// Remove results, we don't want those stored
			.map( function( row ){
				row.delete( "Result" );
				return row;
			} );
		// Process grouped sql
		requestTracker.cfQueries.all.each( function( row ){
			var sqlHash = hash( row.body );
			if ( !requestTracker.cfQueries.grouped.keyExists( sqlHash ) ) {
				requestTracker.cfQueries.grouped[ sqlHash ] = { "sql" : row.body, "count" : 0, "records" : [] };
			}
			requestTracker.cfqueries.grouped[ sqlHash ].count++;
			requestTracker.cfqueries.grouped[ sqlHash ].records.append( row );
		} );

		// Store total number of queries executed
		requestTracker.cfQueries[ "totalQueries" ]       = requestTracker.cfQueries.all.len();
		requestTracker.cfQueries[ "totalExecutionTime" ] = requestTracker.cfQueries.all.reduce( function( total, q ){
			return arguments.total + ( arguments.q.endTime - arguments.q.startTime );
		}, 0 );
	}

}
