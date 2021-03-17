/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This service powers the ColdBox debugger
 */
component
	accessors="true"
	extends  ="coldbox.system.web.services.BaseService"
	singleton
{

	property name="cookieName";
	property name="secretKey";
	property name="profilers" type="array";
	property name="tracers" type="array";
	property name="maxTracers" type="numeric";
	property name="debuggerConfig";
	property name="debugMode";
	property name="debugPassword";

	/**
	 * Constructor
	 *
	 * @controller The ColdBox controller
	 * @controller.inject coldbox
	 */
	function init( required controller ){
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
		variables.debuggerConfig = controller.getSetting( "debugger" );
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
			hash( variables.controller.getAppHash() & variables.debugPassword & salt, "SHA-256" )
		);
		return this;
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
	 * Start an internal code timer and get a hash of the timer storage
	 *
	 * @label The timer label to record
	 *
	 * @return The tracking hash for the timer series started
	 */
	string function timerStart( required label ){
		// Create Timer Hash
		var labelHash = hash( getTickCount() & arguments.label );
		// Verify Debug Mode
		if ( getDebugMode() ) {
			// Store the timer record
			request[ labelHash ] = {
				"id"            : labelHash,
				"startedAt"     : now(),
				"startCount"    : getTickCount(),
				"method"        : arguments.label,
				"stoppedAt"     : now(),
				"executionTime" : 0
			};
		}
		return labelHash;
	}

	/**
	 * End an internal code timer
	 *
	 * @labelHash The timer label hash to stop
	 *
	 * @return The tracking hash for the timer series started
	 */
	DebuggerService function timerEnd( required labelHash ){
		// Verify Debug Mode and timer label exists, else do nothing.
		if ( getDebugMode() and structKeyExists( request, arguments.labelHash ) ) {
			// Get Timer Info
			var timerInfo = request[ arguments.labelHash ];

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
			cfcookie( name = getCookieName(), value = getSecretKey() );
		} else {
			cfcookie( name = getCookieName(), value = "_disabled_" );
		}
		return this;
	}

	/**
	 * Renders the debug log and and returns it
	 */
	any function renderDebugLog(){
		var renderedDebugging = "";
		if ( getDebugMode() ) {
			var debugStartTime     = getTickCount();
			var event              = variables.controller.getRequestService().getContext();
			var rc                 = event.getCollection();
			var prc                = event.getPrivateCollection();
			var loc                = {};
			var thisCollection     = "";
			var thisCollectionType = "";
			var debugTimers        = getTimers();
			var renderType         = "main";
			var URLBase            = event.getSESBaseURL();
			var loadedModules      = variables.controller.getModuleService().getLoadedModules();
			var moduleSettings     = variables.controller.getSetting( "modules" );

			if ( NOT event.isSES() ) {
				URLBase = listLast( cgi.script_name, "/" );
			}

			savecontent variable="renderedDebugging" {
				writeOutput(
					variables.controller
						.getInterceptorService()
						.processState( "beforeDebuggerPanel" )
				);
				include "/cbdebugger/includes/debug.cfm";
				writeOutput(
					variables.controller
						.getInterceptorService()
						.processState( "afterDebuggerPanel" )
				);
			}

			// Reset Info that's shown now
			resetTracers();
		}
		return renderedDebugging;
	}

	/**
	 * Renders the execution profilers.
	 */
	function renderProfiler(){
		var profilerContents = "";
		var profilers        = variables.profilers;
		var profilersCount   = arrayLen( profilers );
		var x                = 1;
		var refLocal         = structNew();
		var event            = variables.controller.getRequestService().getContext();
		var URLBase          = event.getsesBaseURL();

		if ( NOT event.isSES() ) {
			URLBase = listLast( cgi.script_name, "/" );
		}

		savecontent variable="profilerContents" {
			include "/cbdebugger/includes/panels/profilerPanel.cfm";
		}

		return profilerContents;
	}

	/**
	 * Renders the cache panel
	 */
	function renderCachePanel(){
		savecontent variable="cachepanel" {
			cfmodule(
				template     = "/coldbox/system/cache/report/monitor.cfm",
				cacheFactory = variables.controller.getCacheBox()
			);
		}
		return cachepanel;
	}

	/**
	 * Reset the profilers
	 */
	DebuggerService function resetProfilers(){
		variables.profilers = [];
		return this;
	}

	/**
	 * This method will try to push a profiler record
	 */
	DebuggerService function recordProfiler(){
		if ( getDebugMode() AND timersExist() ) {
			pushProfiler( getTimers() );
		}
		return this;
	}

	/**
	 * Push a profiler record
	 */
	DebuggerService function pushProfiler( required profilerRecord ){
		// are persistent profilers activated
		if ( NOT variables.debuggerConfig.persistentRequestProfiler ) {
			return this;
		}

		// size check, if passed, pop one
		if (
			arrayLen( variables.profilers ) gte variables.debuggerConfig.maxPersistentRequestProfilers
		) {
			popProfiler();
		}

		// New Profiler record
		var newRecord = {
			"dateTime"    : now(),
			"ip"          : getLocalhostIP(),
			"timers"      : arguments.profilerRecord,
			"requestData" : getHTTPRequestData(),
			"statusCode"  : 0,
			"contentType" : ""
		};

		// stupid Adobe CF does not support status and content type from response implementation
		if ( findNoCase( "lucee", server.coldfusion.productname ) ) {
			newRecord.statusCode  = getPageContext().getResponse().getStatus();
			newRecord.contentType = getPageContext().getResponse().getContentType();
		}

		// add it to profilers
		arrayAppend( variables.profilers, newRecord );

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

}
