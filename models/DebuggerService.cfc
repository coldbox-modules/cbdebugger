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
	threadsafe
{

	/**
	 * --------------------------------------------------------------------------
	 * DI
	 * --------------------------------------------------------------------------
	 */

	property name="asyncManager"       inject="coldbox:asyncManager";
	property name="interceptorService" inject="coldbox:interceptorService";
	property name="timerService"       inject="provider:Timer@cbdebugger";
	property name="jsonFormatter"      inject="provider:JSONPrettyPrint@JSONPrettyPrint";
	property name="sqlFormatter"       inject="provider:Formatter@sqlformatter";

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
	 * @controller        The ColdBox controller
	 * @controller.inject coldbox
	 * @settings          Module Settings
	 * @settings.inject   coldbox:modulesettings:cbdebugger
	 */
	function init( required controller, required settings ){
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
			"javaVersion"         : createObject( "java", "java.lang.System" ).getProperty( "java.version" ),
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

		// default the password to something so we are secure by default
		if ( variables.debugPassword eq "cb:null" ) {
			variables.debugPassword = hash( variables.environment.appHash & now() );
		} else if ( len( variables.debugPassword ) ) {
			// hash the password into memory
			variables.debugPassword = hash( variables.debugPassword );
		}

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
		var salt            = randomUUID();
		variables.secretKey =
		hash( variables.controller.getAppHash() & variables.debugPassword & salt, "SHA-256" );
		return this;
	}

	/**
	 * Generate a new java random id
	 */
	string function randomUUID(){
		return variables.uuid.randomUUID().toString();
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
			cfcookie( name = getCookieName(), value = variables.secretKey );
		} else {
			cfcookie( name = getCookieName(), value = "_disabled_" );
		}
		return this;
	}

	/**
	 * Create a new request tracking structure. Called by the Request collector when it's ready
	 * to start tracking
	 *
	 * @event The ColdBox context we will start the tracker on
	 */
	struct function createRequestTracker( required event ){
		// Init the request debugger tracking
		param request.cbDebugger = {
			"coldbox"       : {},
			"exception"     : {},
			"executionTime" : 0,
			"endFreeMemory" : 0,
			"formData"      : serializeJSON( form ?: {} ),
			"fullUrl"       : arguments.event.getFullUrl(),
			"httpHost"      : cgi.HTTP_HOST,
			"httpReferer"   : cgi.HTTP_REFERER,
			"id"            : variables.uuid.randomUUID().toString(),
			"inetHost"      : discoverInetHost(),
			"ip"            : getRealIP(),
			"localIp"       : getServerIp(),
			"queryString"   : cgi.QUERY_STRING,
			"requestData"   : getHTTPRequestData(
				variables.debuggerConfig.requestTracker.httpRequest.profileHTTPBody
			),
			"response"        : { "statusCode" : 0, "contentType" : "" },
			"startCount"      : getTickCount(),
			"startFreeMemory" : variables.jvmRuntime.freeMemory(),
			"threadInfo"      : getCurrentThread().toString(),
			"timers"          : [],
			"timestamp"       : now(),
			"tracers"         : [],
			"userAgent"       : cgi.HTTP_USER_AGENT
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

		if ( arrayLen( profilers ) ) {
			return profilers[ 1 ];
		}

		return {};
	}

	/**
	 * Get the current profilers using a sorting algorithm
	 *
	 * @sortBy The sort by key: timestamp, executionTime, etc
	 * @sortOrder Asc/Desc
	 */
	array function getProfilers( string sortBy, string sortOrder = "desc" ){
		var aProfilers = getProfilerStorage();

		// Sorting?
		switch ( arguments.sortBy ) {
			case "event": {
				arraySort( aProfilers, function( e1, e2 ){
					var results = compareNoCase( arguments.e1.coldbox.event, arguments.e2.coldbox.event );
					return ( sortOrder == "asc" ? results : results * -1 );
				} );
				break;
			}

			case "inethost": {
				arraySort( aProfilers, function( e1, e2 ){
					var results = compareNoCase( arguments.e1.inethost, arguments.e2.inethost );
					return ( sortOrder == "asc" ? results : results * -1 );
				} );
				break;
			}

			case "memoryDiff": {
				arraySort( aProfilers, function( e1, e2 ){
					var diff1 = arguments.e1.endFreeMemory - arguments.e1.startFreeMemory;
					var diff2 = arguments.e2.endFreeMemory - arguments.e2.startFreeMemory;
					var results = diff1 < diff2 ? -1 : 1;
					return ( sortOrder == "asc" ? results : results * -1 );
				} );
				break;
			}

			case "statusCode": {
				arraySort( aProfilers, function( e1, e2 ){
					var results = arguments.e1.response.statusCode < arguments.e2.response.statusCode ? -1 : 1;
					return ( sortOrder == "asc" ? results : results * -1 );
				} );
				break;
			}

			case "executionTime": {
				arraySort( aProfilers, function( e1, e2 ){
					var results = arguments.e1.executionTime < arguments.e2.executionTime ? -1 : 1;
					return ( sortOrder == "asc" ? results : results * -1 );
				} );
				break;
			}

			// timestamp
			default: {
				arraySort( aProfilers, function( e1, e2 ){
					var results = dateCompare( arguments.e1.timestamp, arguments.e2.timestamp );
					return ( sortOrder == "asc" ? results : results * -1 );
				} );
				break;
			}
		}

		return aProfilers;
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
	 * @event         The request context that requested the record
	 * @executionTime The time it took for th request to finish
	 * @exception     If there is an exception in the request, track it
	 */
	DebuggerService function recordProfiler(
		required event,
		required executionTime,
		exception = {}
	){
		// Build out the exception data to trace if any?
		var exceptionData = {};
		if ( isObject( arguments.exception ) || !structIsEmpty( arguments.exception ) ) {
			exceptionData = {
				"detail"          : arguments.exception.detail ?: "",
				"errNumber"       : arguments.exception.errNumber ?: "",
				"errorCode"       : arguments.exception.errorCode ?: "",
				"extendedInfo"    : arguments.exception.extendedInfo ?: "",
				"lockName"        : arguments.exception.lockName ?: "",
				"lockOperation"   : arguments.exception.lockOperation ?: "",
				"missingFileName" : arguments.exception.missingFileName ?: "",
				"nativeErrorCode" : arguments.exception.nativeErrorCode ?: "",
				"queryError"      : arguments.exception.queryError ?: "",
				"sql"             : arguments.exception.sql ?: "",
				"sqlState"        : arguments.exception.sqlState ?: "",
				"stackTrace"      : arguments.exception.stacktrace ?: "",
				"tagContext"      : arguments.exception.tagContext ?: [],
				"type"            : arguments.exception.type ?: "",
				"where"           : arguments.exception.where ?: ""
			};
		}

		// Verify we have the tracking struct, we might not have it due to exceptions
		if ( !request.keyExists( "cbDebugger" ) ) {
			createRequestTracker( arguments.event );
		}

		// Event before recording
		variables.interceptorService.announce(
			"onDebuggerProfilerRecording",
			{ requestTracker : request.cbDebugger }
		);

		// Close out the profiler
		request.cbDebugger.append(
			{
				"endFreeMemory" : variables.jvmRuntime.freeMemory(),
				"exception"     : exceptionData,
				"executionTime" : arguments.executionTime - request.cbDebugger.startCount,
				"coldbox"       : {
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
				},
				"response" : {
					"statusCode"  : ( structIsEmpty( exceptionData ) ? getPageContextResponse().getStatus() : 500 ),
					"contentType" : getPageContextResponse().getContentType()
				},
				"timers" : variables.timerService.getTimers()
			},
			true
		);

		// New Profiler record to store into the singleton stack
		var targetStorage = getProfilerStorage().prePend( request.cbDebugger );

		// Are we using cache storage
		if ( variables.debuggerConfig.requestTracker.storage eq "cachebox" ) {
			// Store async in case it delays
			variables.asyncManager.newFuture( function(){
				// store indefintely using the debugger and app hash
				getCacheRegion().set( getStorageKey(), targetStorage, 0, 0 );
			} );
		}

		// async rotation - size check, if passed, pop one
		variables.asyncManager.newFuture( function(){
			storageSizeCheck();
		} );

		return this;
	}

	/**
	 * Do a storage size check and pop if necessary
	 */
	function storageSizeCheck(){
		var targetStorage = getProfilerStorage();
		if ( arrayLen( targetStorage ) gte variables.debuggerConfig.requestTracker.maxProfilers ) {
			arrayDeleteAt( targetStorage, arrayLen( targetStorage ) );
		}
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
	 * @message   The message to trace
	 * @severity  The severity of the message
	 * @category  The tracking category the message came from
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
		param request.cbDebugger.tracers = [];

		// Push it
		request.cbDebugger.tracers.append( arguments );

		return this;
	}

	/**
	 * Reset all tracers back to zero
	 */
	DebuggerService function resetTracers(){
		request.cbDebugger.tracers = [];
		return this;
	}

	/**
	 * Get all the request tracers array
	 */
	array function getTracers(){
		param request.cbDebugger.tracers = [];
		return request.cbDebugger.tracers;
	}

	/**
	 * Get the hostname of the executing machine.
	 */
	function discoverInetHost(){
		try {
			return getInetAddress().getLocalHost().getHostName();
		} catch ( any e ) {
			return cgi.SERVER_NAME;
		}
	}

	/**
	 * Get the server IP Address
	 */
	string function getServerIp(){
		try {
			return getInetAddress().getLocalHost().getHostAddress();
		} catch ( any e ) {
			return "0.0.0.0";
		}
	}

	/**
	 * Get the Java InetAddress object
	 *
	 * @return java.net.InetAddress
	 */
	private function getInetAddress(){
		if ( isNull( variables.inetAddress ) ) {
			variables.inetAddress = createObject( "java", "java.net.InetAddress" );
		}
		return variables.inetAddress;
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
	 * Helper method to deal with ACF's overload of the page context response, come on Adobe, get your act together!
	 */
	function getPageContextResponse(){
		return server.keyExists( "lucee" ) ? getPageContext().getResponse() : getPageContext()
			.getResponse()
			.getResponse();
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
	 * Process Stack trace for errors
	 *
	 * @str The stacktrace to process
	 *
	 * @return The nicer trace
	 */
	function processStackTrace( required str ){
		return getExceptionBean().processStackTrace( argumentCollection = arguments );
	}

	/**
	 * Compose a screen for a file to open in an editor
	 *
	 * @event    The request context
	 * @instance An instance of a tag context array
	 *
	 * @return The string for the IDE
	 */
	function openInEditorURL( required event, required struct instance ){
		return getExceptionBean().openInEditorURL( argumentCollection = arguments );
	}

	/**
	 * Get the exception bean helper lazy loaded
	 *
	 * @return coldbox.system.web.context.ExceptionBean
	 */
	function getExceptionBean(){
		if ( isNull( variables.exceptionBean ) ) {
			variables.exceptionBean = new coldbox.system.web.context.ExceptionBean();
		}
		return variables.exceptionBean;
	}

	/**
	 * This function tries to discover from where a target method was called from
	 * by investigating the call stack
	 *
	 * @targetMethod  The target method we are trying to pin point
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
						arguments.item.function == targetMethod && reFindNoCase(
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
