/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * An appender that interfaces with the ColdBox Tracer Panel
 */
component extends="coldbox.system.logging.AbstractAppender" {

	/**
	 * Constructor
	 */
	function init(
		required name,
		struct properties = {},
		layout            = "",
		levelMin          = 0,
		levelMax          = 4
	){
		// Init supertype
		super.init( argumentCollection = arguments );
		return this;
	}

	/**
	 * Called upon registration
	 */
	function onRegistration(){
		variables.debuggerService = getColdBox().getWireBox().getInstance( "debuggerService@cbdebugger" );
		return this;
	}

	/**
	 * Log a message
	 */
	function logMessage( required any logEvent ){
		// send to coldBox debugger
		variables.debuggerService.pushTracer(
			message  : arguments.logEvent.getMessage(),
			severity : severityToString( arguments.logEvent.getseverity() ),
			category : arguments.logEvent.getCategory(),
			timestamp: arguments.logEvent.getTimestamp(),
			extraInfo: arguments.logEvent.getExtraInfo()
		);

		return this;
	}

}
