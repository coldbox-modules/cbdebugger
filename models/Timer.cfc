/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This component tracks execution times in our internal request facilities.
 * Each timer is created with a label to uniquely track it.
 */
component accessors="true" singleton threadsafe {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";

	/**
	 * Constructor
	 */
	Timer function init(){
		variables.TIMERS_KEY = "cbDebuggerTimerStack";
		return this;
	}

	/**
	 * Start a timer with a tracking label
	 *
	 * @label    The unique tracking label to register
	 * @metadata A struct of metadata to store on the timer
	 * @type     The type of execution timed: request, view-render, layout-render, event, renderer
	 * @parent   An optional parent label
	 *
	 * @return A unique tracking id of the execution timer registered
	 */
	string function start(
		required label,
		struct metadata = {},
		type            = "timer",
		parent          = ""
	){
		var timerId = variables.debuggerService.randomUUID();
		getTimers().insert(
			arguments.label,
			{
				"id"            : timerId,
				"startedAt"     : now(),
				"startCount"    : getTickCount(),
				"method"        : arguments.label,
				"stoppedAt"     : "",
				"executionTime" : 0,
				"metadata"      : arguments.metadata,
				"parent"        : arguments.parent,
				"type"          : arguments.type,
				"times"         : 1
			},
			true
		);
		return timerId;
	}

	/**
	 * Stop the timer for the incoming label
	 *
	 * @label    The label to stop
	 * @metadata The metadata to store as well after the stopping of the timer
	 */
	Timer function stop( required label, struct metadata = {} ){
		if ( timerExists( arguments.label ) ) {
			var timer           = getTimer( arguments.label );
			timer.stoppedAt     = now();
			timer.executionTime = getTickCount() - timer.startCount;
			timer.metadata.append( arguments.metadata );
		}
		return this;
	}

	/**
	 * Time the execution of the passed closure that we will execution for you
	 *
	 * @label    The label to use as a timer label
	 * @closure  The target to execute and time
	 * @metadata A struct of metadata to store in the execution timer
	 */
	function timeIt(
		required label,
		required closure,
		struct metadata = {}
	){
		start( arguments.label, arguments.metadata );
		var results = arguments.closure();
		stop( arguments.label );
		if ( !isNull( results ) ) {
			return results;
		}
	}

	/**
	 * Get a specific timer from the timers stack
	 *
	 * @label The label to get
	 *
	 * @throws KeyNotFoundException - If the requested label doesn't exist
	 */
	struct function getTimer( required label ){
		return getTimers().find( arguments.label );
	}

	/**
	 * Verifies if the timer for the label exists or not
	 */
	boolean function timerExists( required label ){
		return getTimers().keyExists( arguments.label );
	}

	/**
	 * Do we have any timers at all
	 */
	boolean function timersExist(){
		return request.keyExists( TIMERS_KEY );
	}

	/**
	 * Reset the timers and return yourself
	 */
	Timer function resetTimers(){
		getTimers().clear();
		return this;
	}

	/**
	 * Return the timers from the request. If they don't exist, we initialize them
	 */
	struct function getTimers(){
		param name="request.#TIMERS_KEY#" default="#structNew( "ordered" )#";
		return request[ TIMERS_KEY ];
	}

}
