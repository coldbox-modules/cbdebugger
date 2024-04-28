/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This interceptor collects information from hyper
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="timer@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:moduleSettings:cbdebugger";

	/**
	 * Configure
	 */
	function configure(){
	}

	/**
	 * Listen to when the tracker gets created
	 */
	function onDebuggerRequestTrackerCreation( event, data, rc, prc ){
		arguments.data.requestTracker[ "hyper" ] = { "grouped" : {}, "all" : structNew( "ordered" ) };
	}

	/**
	 * Listen when request tracker is being recorded
	 */
	function onDebuggerProfilerRecording( event, data, rc, prc ){
		var requestTracker                           = arguments.data.requestTracker;
		//dump( requestTracker.hyper.all); abort;
		requestTracker.hyper[ "totalRequests" ]      = requestTracker.hyper.all.len();
		requestTracker.hyper[ "totalExecutionTime" ] = requestTracker.hyper.all.reduce( ( total, k, v ) => {
			return arguments.total + arguments.v.executionTime
		}, 0 );
	}

	/**
	 * Listen before the request is processed
	 */
	function onHyperRequest( event, data, rc, prc ){
		// Get the request tracker so we can add our timing goodness!
		var requestTracker = variables.debuggerService.getRequestTracker();

		// Params just in case
		param requestTracker.hyper         = {};
		param requestTracker.hyper.grouped = {};
		param requestTracker.hyper.all     = structNew( "ordered" );

		// Store the request as started, to track cases where
		// the request doesn't finish
		requestTracker.hyper.all[ data.request.getRequestId() ] = {
			"timestamp"     : now(),
			"executionTime" : 0,
			"status"        : "started",
			"requestId"     : data.request.getRequestId(),
			"url"           : data.request.getFullUrl(),
			"request"       : data.request
				.getMemento()
				.filter( ( key, value ) => key == "body" && debuggerConfig.hyper.logRequestBody || key != "body" ),
			"response" : {},
			"caller"   : variables.debuggerService.discoverCallingStack( "send" )
		};
	}

	/**
	 * Listen after the request is processed
	 */
	function onHyperResponse( event, data, rc, prc ){
		var requestTracker = variables.debuggerService.getRequestTracker();
		var thisRequest    = arguments.data.response.getRequest();

		var logData = {
			"status"        : "finished",
			"executionTime" : data.response.getExecutionTime(),
			"response"      : data.response
				.getMemento()
				.filter( ( key, value ) => key == "data" && debuggerConfig.hyper.logResponseData || key != "data" )
		}

		// Store the request as finished
		requestTracker.hyper.all[ thisRequest.getRequestId() ].append(logData );


		// Grouping
		var requestHash = hash(
			thisRequest
				.getMemento()
				.filter( ( key, value ) => key != "requestID" )
				.toString()
		);
		if ( !structKeyExists( requestTracker.hyper.grouped, requestHash ) ) {
			requestTracker.hyper.grouped[ requestHash ] = {
				"url"     : thisRequest.getFullUrl(),
				"method"  : thisRequest.getMethod(),
				"count"   : 0,
				"records" : []
			};
		}
		requestTracker.hyper.grouped[ requestHash ].count++;
		requestTracker.hyper.grouped[ requestHash ].records.append( thisRequest.getRequestId() );

		// Store execution timer
		variables.timerService.add(
			label        : "[Hyper Request] #data.response.getStatusCode()# <#thisRequest.getMethod()#>#thisRequest.getFullUrl()#",
			executionTime: data.response.getExecutionTime(),
			startedAt    : data.response.getTimestamp(),
			metadata     : {
				statusCode : data.response.getStatusCode(),
				statusText : data.response.getStatusText(),
				path       : requestTracker.hyper.all[ thisRequest.getRequestId() ].caller.template,
				line       : requestTracker.hyper.all[ thisRequest.getRequestId() ].caller.line
			},
			type: "hyper"
		);

		var hyperInfo  = requestTracker.hyper.all[ thisRequest.getRequestId() ];
		variables.debuggerService.pushEvent(
			"transactionId": requestTracker.id,
			"eventType": 'hyper',
			"timestamp": hyperInfo.timestamp,
			"details": hyperInfo.url,
			"executionTimeMillis": hyperInfo.executionTime,
			"extraInfo": hyperInfo,
			"caller": hyperInfo.caller
		);

	}

	/************************************** PRIVATE METHODS *********************************************/

}
