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

	property name="timerService"       inject="Timer@cbdebugger";
	property name="interceptorService" inject="coldbox:interceptorService";

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
	 * Get the runtime environment
	 */
	property name="environment" type="struct";

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
		// Runtime
		variables.jvmRuntime     = createObject( "java", "java.lang.Runtime" ).getRuntime();
		variables.Thread         = createObject( "java", "java.lang.Thread" );
		// run modes
		variables.debugMode      = variables.debuggerConfig.debugMode;
		variables.debugPassword  = variables.debuggerConfig.debugPassword;
		// uuid helper
		variables.uuid           = createObject( "java", "java.util.UUID" );

		// Store Environment struct
		variables.environment = {
			"cfmlEngine"          : server.coldfusion.productName,
			"cfmlVersion"         : ( server.keyExists( "lucee" ) ? server.lucee.version : server.coldfusion.productVersion ),
			"javaVersion"         : variables.jvmRuntime.version().toString(),
			"totalMemory"         : variables.jvmRuntime.totalMemory(),
			"maxMemory"           : variables.jvmRuntime.maxMemory(),
			"availableProcessors" : variables.jvmRuntime.availableProcessors(),
			"coldboxName"         : variables.controller.getColdBoxSettings().codename,
			"coldboxVersion"      : variables.controller.getColdBoxSettings().version,
			"coldboxSuffix"       : variables.controller.getColdBoxSettings().suffix,
			"appName"             : variables.controller.getSetting( "appName" ),
			"appPath"             : variables.controller.getSetting( "applicationPath" ),
			"appHash"             : variables.controller.getAppHash()
		};

		// Initialize secret key
		rotateSecretKey();

		return this;
	}

	/**
	 * Get the cache region configured for the debugger
	 */
	private function getCacheRegion(){
		return variables.controller.getCacheBox().getCache( variables.debuggerConfig.requestTracker.cacheName );
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
	 * Create a new request tracking structure
	 *
	 * @event The ColdBox context we will start the tracker on
	 */
	struct function createRequestTracker( required event ){
		// Init the request tracers
		request.tracers    = [];
		// Init the request debugger tracking
		request.cbDebugger = {
			"id"            : variables.uuid.randomUUID(),
			"timestamp"     : now(),
			"ip"            : getRealIP(),
			"threadInfo"    : getCurrentThread().toString(),
			"startCount"    : getTickCount(),
			"executionTime" : 0,
			"fullUrl"       : arguments.event.getFullUrl(),
			"timers"        : [],
			"tracers"       : [],
			"requestData"   : getHTTPRequestData( variables.debuggerConfig.requestTracker.httpRequest.profileHTTPBody ),
			"response"      : { "statusCode" : 0, "contentType" : "" },
			"coldbox"       : {},
			"exception"     : {},
			"userAgent"     : cgi.HTTP_USER_AGENT,
			"queryString"   : cgi.QUERY_STRING,
			"httpHost"      : cgi.HTTP_HOST,
			"httpReferer"   : cgi.HTTP_REFERER,
			"formData"      : serializeJSON( form ?: {} ),
			"inetHost"      : discoverInetHost(),
			"localIp"       : ( isNull( cgi.local_addr ) ? "0.0.0.0" : cgi.local_addr )
		};

		// Event before recording
		variables.interceptorService.announce(
			"onDebuggerRequestTrackerCreation",
			{ requestTracker : request.cbDebugger }
		);

		return request.cbDebugger;
	}

	/**
	 * Get the current request tracker struct
	 */
	struct function getRequestTracker(){
		param request.cbDebugger = {};
		return request.cbDebugger;
	}

	/**
	 * Get the key used in the off heap storage
	 */
	function getStorageKey(){
		return "cbDebugger-#variables.environment.appName.replace( " ", "-", "all" )#";
	}

	/**
	 * Reset the request tracking profilers
	 */
	DebuggerService function resetProfilers(){
		if ( variables.debuggerConfig.requestTracker.storage eq "cachebox" ) {
			getCacheRegion().set( getStorageKey(), [], 0, 0 );
		} else {
			variables.profilers = [];
		}
		return this;
	}

	/**
	 * Get the current profiler for the current request. Basically the first in the stack
	 *
	 * @return The current request profiler or an empty struct if none found.
	 */
	struct function getCurrentProfiler(){
		var profilers = getProfilerStorage();

		if( arrayLen( profilers ) ){
			return profilers[ 1 ];
		}

		return {};
	}

	/**
	 * Get the profiler storage array depending on the storage options
	 */
	array function getProfilerStorage(){
		if ( variables.debuggerConfig.requestTracker.storage eq "cachebox" ) {
			return getCacheRegion().getOrSet(
				getStorageKey(),
				function(){
					return [];
				},
				0
			);
		} else {
			return variables.profilers;
		}
	}

	/**
	 * Record a profiler and it's timers internally
	 *
	 * @event The request context that requested the record
	 * @executionTime The time it took for th request to finish
	 * @exception If there is an exception in the request, track it
	 */
	DebuggerService function recordProfiler(
		required event,
		required executionTime,
		exception = {}
	){
		var targetStorage = getProfilerStorage();

		// size check, if passed, pop one
		if ( arrayLen( targetStorage ) gte variables.debuggerConfig.requestTracker.maxProfilers ) {
			arrayDeleteAt(
				targetStorage,
				arrayLen( targetStorage )
			);
		}

		// Build out the exception data to trace if any?
		var exceptionData = {};
		if ( isObject( arguments.exception ) || !structIsEmpty( arguments.exception ) ) {
			exceptionData = {
				"stackTrace"      : arguments.exception.stacktrace ?: "",
				"type"            : arguments.exception.type ?: "",
				"detail"          : arguments.exception.detail ?: "",
				"tagContext"      : arguments.exception.tagContext ?: [],
				"nativeErrorCode" : arguments.exception.nativeErrorCode ?: "",
				"sqlState"        : arguments.exception.sqlState ?: "",
				"sql"             : arguments.exception.sql ?: "",
				"queryError"      : arguments.exception.queryError ?: "",
				"where"           : arguments.exception.where ?: "",
				"errNumber"       : arguments.exception.errNumber ?: "",
				"missingFileName" : arguments.exception.missingFileName ?: "",
				"lockName"        : arguments.exception.lockName ?: "",
				"lockOperation"   : arguments.exception.lockOperation ?: "",
				"errorCode"       : arguments.exception.errorCode ?: "",
				"extendedInfo"    : arguments.exception.extendedInfo ?: ""
			};
		}

		// Verify we have the tracking struct, we might not have it due to exceptions
		if ( !request.keyExists( "cbDebugger" ) ) {
			createRequestTracker( arguments.event );
		}

		// Close out the profiler
		param request.cbDebugger.startCount = 0;
		request.cbDebugger.append(
			{
				"timers"        : variables.timerService.getSortedTimers(),
				"tracers"       : getTracers(),
				"exception"     : exceptionData,
				"executionTime" : arguments.executionTime - request.cbDebugger.startCount,
				"response"      : {
					"statusCode"  : ( structIsEmpty( exceptionData ) ? getPageContextResponse().getStatus() : 500 ),
					"contentType" : getPageContextResponse().getContentType()
				},
				"coldbox" : {
					"RoutedUrl"        : arguments.event.getCurrentRoutedUrl(),
					"Route"            : arguments.event.getCurrentRoute(),
					"RouteMetadata"    : serializeJSON( arguments.event.getCurrentRouteMeta() ),
					"RouteName"        : arguments.event.getCurrentRouteName(),
					"Event"            : arguments.event.getCurrentEvent(),
					"isEventCacheable" : arguments.event.isEventCacheable(),
					"View"             : arguments.event.getCurrentView(),
					"ViewModule"       : arguments.event.getCurrentViewModule(),
					"Layout"           : arguments.event.getCurrentLayout(),
					"LayoutModule"     : arguments.event.getCurrentLayoutModule()
				}
			},
			true
		);

		// Event before recording
		variables.interceptorService.announce(
			"onDebuggerProfilerRecording",
			{ requestTracker : request.cbDebugger }
		);

		// New Profiler record to store into the singleton stack
		arrayPrepend( targetStorage, request.cbDebugger );

		// Are we using cache storage
		if ( variables.debuggerConfig.requestTracker.storage eq "cachebox" ) {
			// store indefintely using the debugger and app hash
			getCacheRegion().set( getStorageKey(), targetStorage, 0, 0 );
		}

		return this;
	}

	/**
	 * Retrieve the profiler by incoming id
	 *
	 * @id The unique profiler id to get
	 *
	 * @return The profiler requested or an empty struct if not found
	 */
	struct function getProfilerById( required id ){
		return getProfilerStorage()
			.filter( function( thisItem ){
				return arguments.thisItem.id.toString() == id;
			} )
			.reduce( function( results, thisItem ){
				arguments.results = arguments.thisItem;
				return arguments.results;
			}, {} );
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
		// Don't allow if not enabled
		if ( !variables.debuggerConfig.tracers.enabled ) {
			return this;
		}

		// Ensure we have the tracers array for the request
		if ( isNull( request.tracers ) ) {
			request.tracers = [];
		}

		// Push it
		arrayPrepend( request.tracers, arguments );

		return this;
	}

	/**
	 * Reset all tracers back to zero
	 */
	DebuggerService function resetTracers(){
		request.tracers = [];
		return this;
	}

	/**
	 * Get all the request tracers array
	 */
	array function getTracers(){
		return request.tracers ?: [];
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

	/**
	 * This function tries to discover from where a target method was called from
	 * by investigating the call stack
	 *
	 * @targetMethod The target method we are trying to pin point
	 * @templateMatch A string fragment to further narrow down the location, we match this against the template path
	 *
	 * @return Struct of { function, lineNumber, line, template }
	 */
	struct function discoverCallingStack( required targetMethod, templateMatch ){
		var callstack   = callStackGet();
		var targetIndex = callstack
			.map( function( item, index, array ){
				// Do we have template matches or simple function equality?
				if ( !isNull( templateMatch ) ) {
					if (
						arguments.item.function == targetMethod && findNoCase(
							templateMatch,
							arguments.item.template
						)
					) {
						return arguments.index;
					};
				} else {
					if ( arguments.item.function == targetMethod ) {
						return arguments.index;
					};
				}
			} )
			.filter( function( item ){
				return !isNull( arguments.item );
			} );

		// Only return if we have matches, else default return struct
		if ( targetIndex.len() ) {
			var results       = callStack[ targetIndex[ arrayLen( targetIndex ) ] + 1 ];
			results[ "line" ] = results.lineNumber;
			return results;
		}

		return {
			"function"   : "",
			"line"       : 0,
			"lineNumber" : 0,
			"template"   : ""
		};
	}

}
