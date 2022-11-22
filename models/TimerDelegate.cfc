/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This delegate allows objects to be able to time themselves into the debugger
 */
component accessors="true" singleton threadsafe {

	// DI
	property name="timer" inject="Timer@cbdebugger";

	/**
	 * Start a timer with a tracking label
	 *
	 * @label The tracking label to register
	 *
	 * @return A unique tracking hash you must use to stop the timer
	 */
	function startCBTimer( required label ){
		return variables.timer.start( arguments.label );
	}

	/**
	 * End a code timer with a tracking hash. If the tracking hash is not tracked we ignore it
	 *
	 * @labelHash The timer label hash to stop
	 */
	function stopCBTimer( required labelHash ){
		return variables.timer.stop( arguments.labelHash );
	}

	/**
	 * Time the execution of the passed closure that we will execution for you
	 *
	 * @label    The label to use as a timer label
	 * @closure  The target to execute and time
	 * @metadata A struct of metadata to store in the execution timer
	 */
	function cbTimeIt(
		required label,
		required closure,
		struct metadata = {}
	){
		return variables.timer.timeIt( argumentCollection = arguments );
	}

}
