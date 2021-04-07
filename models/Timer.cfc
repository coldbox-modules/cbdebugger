/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This component tracks execution times in our internal request facilities.
 */
component accessors="true" singleton {

	/**
	 * Constructor
	 */
	Timer function init(){
		return this;
	}

	/**
	 * Start a timer with a tracking label
	 *
	 * @label The tracking label to register
	 *
	 * @return A unique tracking hash you must use to stop the timer
	 */
	string function start( required label ){
		// Create Timer Hash
		var labelHash        = hash( getTickCount() & arguments.label );
		// Store the timer record
		request[ labelHash ] = {
			"id"            : labelHash,
			"startedAt"     : now(),
			"startCount"    : getTickCount(),
			"method"        : arguments.label,
			"stoppedAt"     : now(),
			"executionTime" : 0
		};
		return labelHash;
	}

	/**
	 * Stop a code timer with a tracking hash. If the tracking hash is not tracked we ignore it
	 *
	 * @labelHash The timer label hash to stop
	 */
	Timer function stop( required labelHash ){
		// Verify tracking hash
		if ( structKeyExists( request, arguments.labelHash ) ) {
			// Get Timer Info
			var timerInfo           = request[ arguments.labelHash ];
			// Stop the timer
			timerInfo.stoppedAt     = now();
			timerInfo.executionTime = getTickCount() - timerInfo.startCount;
			// Append the timer information
			getTimers().prepend( timerInfo );
			// Cleanup
			structDelete( request, arguments.labelHash );
		}

		return this;
	}

	/**
	 * Time the execution of the passed closure that we will execution for you
	 *
	 * @label The label to use as a timer label
	 * @closure The target to execute and time
	 */
	function timeIt( required label, required closure ){
		var labelhash = this.start( arguments.label );
		var results   = arguments.closure();
		this.stop( labelhash );
		if ( !isNull( results ) ) {
			return results;
		}
	}

	/**
	 * Do we have any timers in request
	 */
	boolean function timersExist(){
		return request.keyExists( "debugTimers" );
	}

	/**
	 * Return the timers from the request. If they don't exist, we initialize them
	 */
	array function getTimers(){
		if ( !request.keyExists( "debugTimers" ) ) {
			request.debugTimers = [];
		}
		return request.debugTimers;
	}

	/**
	 * Get a sorted timers collection. We sort them by execution start
	 */
	array function getSortedTimers(){
		getTimers().sort( function( e1, e2 ){
			return dateCompare( e1.startedAt, e2.startedAt );
		} );
		return getTimers();
	}

}
