/**
* QB Collector Interecptor
*/
component extends="coldbox.system.Interceptor"{

	// Before we capture.
	function postQBExecute( event, interceptData, rc, prc ) {
		param request.cbdebugger = {};
		param request.cbdebugger.qbQueries = {};
		param request.cbdebugger.qbQueries.grouped = {};
		param request.cbdebugger.qbQueries.all = [];
		arguments.interceptData.timestamp = now();
		if ( !structKeyExists( request.cbdebugger.qbQueries.grouped, arguments.interceptData.sql ) ) {
			request.cbdebugger.qbQueries.grouped[ arguments.interceptData.sql ] = [];
		}
		request.cbdebugger.qbQueries.grouped[ arguments.interceptData.sql ].append( arguments.interceptData );
		request.cbdebugger.qbQueries.all.append( arguments.interceptData );
	}

}
