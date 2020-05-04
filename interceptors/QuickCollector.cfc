/**
* QB Collector Interecptor
*/
component extends="coldbox.system.Interceptor"{

	// Before we capture.
	function quickPostLoad( event, interceptData, rc, prc ) {
		param request.cbdebugger = {};
		param request.cbdebugger.quick = {};
		param request.cbdebugger.quick.total = 0;
		param request.cbdebugger.quick.byMapping = {};
		if ( !request.cbdebugger.quick.byMapping.keyExists( arguments.interceptData.entity.mappingName() ) ) {
			request.cbdebugger.quick.byMapping[ arguments.interceptData.entity.mappingName() ] = 0;
		}
		request.cbdebugger.quick.byMapping[ arguments.interceptData.entity.mappingName() ] += 1;
		request.cbdebugger.quick.total += 1;
	}

}
