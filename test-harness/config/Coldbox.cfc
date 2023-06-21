component {

	// Configure ColdBox Application
	function configure(){
		// coldbox directives
		coldbox = {
			// Application Setup
			appName                 : "Module Tester",
			// Development Settings
			reinitPassword          : "",
			handlersIndexAutoReload : true,
			modulesExternalLocation : [],
			// Implicit Events
			defaultEvent            : "",
			requestStartHandler     : "main.onRequestStart",
			requestEndHandler       : "",
			applicationStartHandler : "main.onAppInit",
			applicationEndHandler   : "",
			sessionStartHandler     : "",
			sessionEndHandler       : "",
			missingTemplateHandler  : "",
			// Error/Exception Handling
			exceptionHandler        : "",
			onInvalidEvent          : "",
			customErrorTemplate     : "/coldbox/system/exceptions/Whoops.cfm",
			// Application Aspects
			handlerCaching          : false,
			eventCaching            : false
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = { development : "localhost,127\.0\.0\.1" };

		// Module Directives
		modules = {
			// An array of modules names to load, empty means all of them
			include : [],
			// An array of modules names to NOT load, empty means none
			exclude : []
		};

		// Register interceptors as an array, we need order
		interceptors = [];

		// LogBox DSL
		logBox = {
			// Define Appenders
			appenders : {
				myConsole : { class : "ConsoleAppender" },
				files : {
					class      : "coldbox.system.logging.appenders.RollingFileAppender",
					properties : {
						filename : "tester",
						filePath : "/#appMapping#/logs"
					}
				}
			},
			// Root Logger
			root : { levelmax : "DEBUG", appenders : "*" },
			// Implicit Level Categories
			info : [ "coldbox.system" ]
		};

		// Debugger Settings
		moduleSettings = {
			cbDebugger : {
				// This flag enables/disables the tracking of request data to our storage facilities
				// To disable all tracking, turn this master key off
				enabled   : true,
				// This setting controls if you will activate the debugger for visualizations ONLY
				// The debugger will still track requests even in non debug mode.
				debugMode : true,
				// The URL password to use to activate it on demand
				debugPassword  : "cb:null",
				// Request Tracker Options
				requestTracker : {
					storage : "cachebox",
					cacheName : "template",
					trackDebuggerEvents : false,
					// Expand by default the tracker panel or not
					expanded                     : true,
					// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
					slowExecutionThreshold       : 1000,
					// How many tracking profilers to keep in stack: Default is to monitor the last 20 requests
					maxProfilers                 : 25,
					// If enabled, the debugger will monitor the creation time of CFC objects via WireBox
					profileWireBoxObjectCreation : true,
					// Profile model objects annotated with the `profile` annotation
					profileObjects               : true,
					// If enabled, will trace the results of any methods that are being profiled
					traceObjectResults           : false,
					// Profile Custom or Core interception points
					profileInterceptions         : true,
					// By default all interception events are excluded, you must include what you want to profile
					includedInterceptions        : [ "ORMPostNew" ],
					// Control the execution timers
					executionTimers              : {
						expanded           : true,
						// Slow transaction timers in milliseconds, if execution time of the timer is above it, we mark it
						slowTimerThreshold : 250
					},
					// Control the coldbox info reporting
					coldboxInfo : { expanded : false },
					// Control the http request reporting
					httpRequest : {
						expanded        : false,
						// If enabled, we will profile HTTP Body content, disabled by default as it contains lots of data
						profileHTTPBody : false
					}
				},
				// ColdBox Tracer Appender Messages
				tracers     : { enabled : true, expanded : false },
				// Request Collections Reporting
				collections : {
					// Enable tracking
					enabled      : false,
					// Expanded panel or not
					expanded     : false,
					// How many rows to dump for object collections
					maxQueryRows : 50,
					// How many levels to output on dumps for objects
					maxDumpTop   : 5
				},
				// CacheBox Reporting
				cachebox : { enabled : true, expanded : false },
				// Modules Reporting
				modules  : { enabled : true, expanded : false },
				// Quick and QB Reporting
				qb       : {
					enabled   : true,
					expanded  : false,
					// Log the binding parameters
					logParams : true,
					defaultGrammar : "MySQLGrammar@qb"
				},
				// cborm Reporting
				cborm : {
					enabled   : true,
					expanded  : false,
					// Log the binding parameters
					logParams : true
				},
				// cfquery sql reporting
				acfSql : {
					enabled : true,
					expanded : false,
					logParams : true
				},
				luceeSQL : { enabled : true, expanded : false, logParams : true },
				// Hyper Collector
				hyper	: { enabled : true, expanded : false, logRequestBody : true, logResponseData : true }
			}
		};

		executors = {
			"debugger-tasks" : {
				"type" : "scheduled",
				"threads" : 5
			},
			"cachebound-tasks" : {
				"type" : "cached"
			}
		};
	}

	/**
	 * Load the Module you are testing
	 */
	function afterAspectsLoad( event, interceptData, rc, prc ){
		controller
			.getModuleService()
			.registerAndActivateModule(
				moduleName     = request.MODULE_NAME,
				invocationPath = "moduleroot"
			);
	}

}
