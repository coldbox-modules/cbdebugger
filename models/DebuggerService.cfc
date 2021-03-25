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

	/**
	 * The cookie name used for tracking the debug mode
	 */
	property name="cookieName";

	/**
	 * The collection of request profilers we track in the debugger
	 */
	property name="profilers" type="array";

	/**
	 * The collection of tracers we track in the debugger
	 */
	property name="tracers" type="array";

	/**
	 * The debugger configuration struct
	 */
	property name="debuggerConfig" type="struct";

	/**
	 * The controlling debug mode flag
	 */
	property name="debugMode" type="boolean";

	/**
	 * The debugging password we track for activation/deactivation
	 */
	property name="debugPassword";

	/**
	 * The running host we are tracking on
	 */
	property name="inetHost";

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
		// config
		variables.debuggerConfig = arguments.settings;
		// Set the unique cookie name per ColdBox application
		variables.cookieName     = "coldbox_debugmode_#arguments.controller.getAppHash()#";
		// This will store the secret key
		variables.secretKey      = "";
		// Create persistent profilers
		variables.profilers      = [];
		// Create persistent tracers
		variables.tracers        = [];
		// Runtime
		variables.jvmRuntime     = createObject( "java", "java.lang.Runtime" );
		variables.Thread         = createObject( "java", "java.lang.Thread" );
		// run modes
		variables.debugMode      = variables.debuggerConfig.debugMode;
		variables.debugPassword  = variables.debuggerConfig.debugPassword;
		// uuid helper
		variables.uuid           = createObject( "java", "java.util.UUID" );
		// Store the host we are on
		variables.inetHost       = discoverInetHost();

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
		var salt            = createUUID();
		variables.secretKey =
		hash(
			variables.controller.getAppHash() & variables.debugPassword & salt,
			"SHA-256"
		);
		return this;
	}

	/**
	 * Get the debug mode marker
	 */
	boolean function getDebugMode(){
		// If no secretKey has been set, don't allow debug mode
		if ( not ( len( variables.secretKey ) ) ) {
			return false;
		}

		// If Cookie exists, it's value is used.
		if ( isDebugCookieValid() ) {
			// Must be equal to the current secret key
			if ( cookie[ variables.cookieName ] == variables.secretKey ) {
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
				value = variables.secretKey
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
	 *
	 * @event The request context that requested the record
	 * @executionTime The time it took for th request to finish
	 */
	DebuggerService function recordProfiler(
		required event,
		required executionTime
	){
		return pushProfiler(
			variables.timerService.getTimers(),
			arguments.event,
			arguments.executionTime
		);
	}

	/**
	 * Push a profiler record (timers) into the tracking facilities
	 *
	 * @profilerRecord The array of timers to store
	 * @event The request contex that requested the record
	 * @executionTime The time it took for th request to finish
	 */
	DebuggerService function pushProfiler(
		required profilerRecord,
		required event,
		required executionTime
	){
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
				"id"                 : variables.uuid.randomUUID(),
				"timestamp"          : now(),
				"ip"                 : getRealIP(),
				"inetHost"           : variables.inetHost,
				"threadName"         : getThreadName(),
				"executionTime"      : arguments.executionTime,
				"timers"             : arguments.profilerRecord,
				"requestData"        : getHTTPRequestData( variables.debuggerConfig.profileHTTPBody ),
				"statusCode"         : getPageContextResponse().getStatus(),
				"contentType"        : getPageContextResponse().getContentType(),
				"currentRoutedUrl"   : arguments.event.getCurrentRoutedUrl(),
				"currentRoute"       : arguments.event.getCurrentRoute(),
				"currentRouteRecord" : arguments.event.getCurrentRouteRecord(),
				"currentRouteName"   : arguments.event.getCurrentRouteName(),
				"currentEvent"       : arguments.event.getCurrentEvent(),
				"currentView"        : arguments.event.getCurrentView(),
				"currentLayout"      : arguments.event.getCurrentLayout(),
				"fullUrl"            : arguments.event.getFullUrl()
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
	 * Push a new tracer into the debugger. This comes from LogBox, so we follow
	 * the same patterns
	 *
	 * @message The message to trace
	 * @severity The severity of the message
	 * @category The tracking category the message came from
	 * @timestamp The timestamp of the message
	 * @extraInfo Extra info to store in the tracer
	 */
	DebuggerService function pushTracer(
		required message,
		severity  = "info",
		category  = "",
		timestamp = now(),
		extraInfo = ""
	){
		// Max Check
		if ( arrayLen( variables.tracers ) gte variables.debuggerConfig.maxPersistentRequestTracers ) {
			resetTracers();
		}

		// Push it
		lock name="cbdebugger-tracers" type="readonly" timeout="10" throwOnTimeout="true" {
			arrayPrepend( variables.tracers, arguments );
		}

		return this;
	}

	/**
	 * Reset all tracers back to zero
	 */
	DebuggerService function resetTracers(){
		lock name="cbdebugger-tracers" type="exclusive" timeout="10" throwOnTimeout="true" {
			variables.tracers = [];
		}
		return this;
	}

	/**
	 * Get the hostname of the executing machine.
	 */
	function discoverInetHost(){
		try {
			return createObject( "java", "java.net.InetAddress" ).getLocalHost().getHostName();
		} catch ( any e ) {
			return cgi.SERVER_NAME;
		}
	}

	/**
	 * Get Real IP, by looking at clustered, proxy headers and locally.
	 */
	function getRealIP(){
		var headers = getHTTPRequestData().headers;

		// Very balanced headers
		if ( structKeyExists( headers, "x-cluster-client-ip" ) ) {
			return headers[ "x-cluster-client-ip" ];
		}
		if ( structKeyExists( headers, "X-Forwarded-For" ) ) {
			return headers[ "X-Forwarded-For" ];
		}

		return len( CGI.REMOTE_ADDR ) ? trim( listFirst( CGI.REMOTE_ADDR ) ) : "127.0.0.1";
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

	/**
	 * Get the current thread java object
	 */
	function getCurrentThread(){
		return variables.Thread.currentThread();
	}

	/**
	 * Get the current thread name
	 */
	function getThreadName(){
		return getCurrentThread().getName();
	}

}
