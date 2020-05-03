/**
* QB Collector Interecptor
*/
component extends="coldbox.system.Interceptor"{

	// Before we capture.
	function postQBExecute( event, interceptData, rc, prc ) {
		param request.cbdebugger = {};
		param request.cbdebugger.qbQueries = {};
		if ( !structKeyExists( request.cbdebugger.qbQueries, arguments.interceptData.sql ) ) {
			request.cbdebugger.qbQueries[ arguments.interceptData.sql ] = [];
		}
		arguments.interceptData.timestamp = now();
		request.cbdebugger.qbQueries[ arguments.interceptData.sql ].append( arguments.interceptData )
	}

}
