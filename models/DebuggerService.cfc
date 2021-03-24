/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This service powers the ColdBox debugger
 */
component
	accessors="true"
	extends  ="coldbox.system.web.services.BaseService"
	singleton
{

	/**
	 * --------------------------------------------------------------------------
	 * DI
	 * --------------------------------------------------------------------------
	 */

	property name="timerService" inject="Timer@cbdebugger";

	/**
	 * --------------------------------------------------------------------------
	 * Tracking Properties
	 * --------------------------------------------------------------------------
	 */

	property name="cookieName";
	property name="secretKey";
	property name="profilers"  type="array";
	property name="tracers"    type="array";
	property name="maxTracers" type="numeric";
	property name="debuggerConfig";
	property name="debugMode";
	property name="debugPassword";

	/**
	 * Constructor
	 *
	 * @controller The ColdBox controller
	 * @controller.inject coldbox
	 * @settings Module Settings
	 * @settings.inject coldbox:modulesettings:cbdebugger
	 */
	function init(
		required controller,
		required settings
	){
		// setup controller
		variables.controller     = arguments.controller;
		// Set the unique cookie name per ColdBox application
		variables.cookieName     = "coldbox_debugmode_#arguments.controller.getAppHash()#";
		// This will store the secret key
		variables.secretKey      = "";
		// Create persistent profilers
		variables.profilers      = arrayNew( 1 );
		// Create persistent tracers
		variables.tracers        = arrayNew( 1 );
		// Set a maximum tracers possible
		variables.maxTracers     = 75;
		// Runtime
		variables.jvmRuntime     = createObject( "java", "java.lang.Runtime" );
		// config
		variables.debuggerConfig = arguments.settings;
		// run modes
		variables.debugMode      = variables.debuggerConfig.debugMode;
		variables.debugPassword  = variables.debuggerConfig.debugPassword;

		// Initialize secret key
		rotateSecretKey();

		return this;
	}

	/**
	 * I generate a secret key value for the cookie which enables debug mode
	 */
	function rotateSecretKey(){
		/*
			This secret key is what the value of the user's cookie must equal to enable debug mode.
			This key will be different every time it is generated.  It is unique based on the application,
			current debugPassword and a random salt.  The salt also protects against someone being able to
			reverse engineer the orignal password from an intercepted cookie value.
		*/
		var salt = createUUID();
		setSecretKey(
			hash(
				variables.controller.getAppHash() & variables.debugPassword & salt,
				"SHA-256"
			)
		);
		return this;
	}

	/**
	 * Get the debug mode marker
	 */
	boolean function getDebugMode(){
		var secretKey = getSecretKey();

		// If no secretKey has been set, don't allow debug mode
		if ( not ( len( secretKey ) ) ) {
			return false;
		}

		// If Cookie exists, it's value is used.
		if ( isDebugCookieValid() ) {
			// Must be equal to the current secret key
			if ( cookie[ variables.cookieName ] == secretKey ) {
				return true;
			} else {
				return false;
			}
		}

		// If there is no cookie, then use default to app setting
		return variables.debugMode;
	}

	/**
	 * Checks if the debug cookie is a valid cookie. Boolean
	 */
	boolean function isDebugCookieValid(){
		return structKeyExists( cookie, variables.cookieName );
	}

	/**
	 * I set the current user's debugmode
	 */
	DebuggerService function setDebugMode( required boolean mode ){
		if ( arguments.mode ) {
			cfcookie(
				name  = getCookieName(),
				value = getSecretKey()
			);
		} else {
			cfcookie(
				name  = getCookieName(),
				value = "_disabled_"
			);
		}
		return this;
	}

	/**
	 * Reset the request tracking profilers
	 */
	DebuggerService function resetProfilers(){
		variables.profilers = [];
		return this;
	}

	/**
	 * Record a profiler and it's timers internally
	 */
	DebuggerService function recordProfiler(){
		return pushProfiler( variables.timerService.getTimers() );
	}

	/**
	 * Push a profiler record (timers) into the tracking facilities
	 */
	DebuggerService function pushProfiler( required profilerRecord ){
		// are persistent profilers activated
		if ( NOT variables.debuggerConfig.persistentRequestProfiler ) {
			return this;
		}

		// size check, if passed, pop one
		if ( arrayLen( variables.profilers ) gte variables.debuggerConfig.maxPersistentRequestProfilers ) {
			popProfiler();
		}

		// New Profiler record to store
		arrayAppend(
			variables.profilers,
			{
				"dateTime"    : now(),
				"ip"          : getLocalhostIP(),
				"timers"      : arguments.profilerRecord,
				"requestData" : getHTTPRequestData(),
				"statusCode"  : getPageContextResponse().getStatus(),
				"contentType" : getPageContextResponse().getContentType()
			}
		);

		return this;
	}

	/**
	 * Pop a profiler record
	 */
	DebuggerService function popProfiler(){
		arrayDeleteAt( variables.profilers, 1 );
		return this;
	}

	/**
	 * Push a new tracer
	 *
	 * @message The message to trace
	 * @extraInfo Extra info to store in the tracer
	 */
	DebuggerService function pushTracer( required message, extraInfo = "" ){
		// Max Check
		if ( arrayLen( variables.tracers ) gte variables.maxTracers ) {
			resetTracers();
		}

		arrayAppend(
			variables.tracers,
			{
				"message"   : arguments.message,
				"extraInfo" : arguments.extraInfo
			}
		);

		return this;
	}

	/**
	 * Reset all tracers
	 */
	DebuggerService function resetTracers(){
		variables.tracers = [];

		return this;
	}

	/**
	 * Get the hostname of the executing machine.
	 */
	function getInetHost(){
		try {
			return createObject( "java", "java.net.InetAddress" ).getLocalHost().getHostName();
		} catch ( any e ) {
			return cgi.SERVER_NAME;
		}
	}

	/**
	 * Helper method to deal with ACF2016's overload of the page context response, come on Adobe, get your act together!
	 */
	function getPageContextResponse(){
		var response = getPageContext().getResponse();
		try {
			response.getStatus();
			return response;
		} catch ( any e ) {
			return response.getResponse();
		}
	}

}
