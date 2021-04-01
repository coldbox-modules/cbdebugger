/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// Module Properties
	this.title              = "ColdBox Debugger";
	this.author             = "Curt Gratz - Ortus Solutions";
	this.version            = "@build.version@+@build.number@";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "The ColdBox Debugger Module";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup   = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint         = "cbdebugger";
	// CF Mapping
	this.cfMapping          = "cbdebugger";
	// Model Namespace
	this.modelNamespace     = "cbdebugger";
	// App Helpers
	this.applicationHelper  = [ "helpers/Mixins.cfm" ];

	/**
	 * Module Registration
	 */
	function configure(){
		/**
		 * Settings
		 */
		variables.settings = {
			// Turn the debugger on/off by default. You can always enable it via the URL using your debug password
			debugMode : controller.getSetting(
				name         = "environment",
				defaultValue = "production"
			) == "development",
			// The URL password to use to activate it on demand
			debugPassword  : "cb:null",
			// Request Tracker Options
			requestTracker : {
				// Expand by default the tracker panel or not
				expanded                     : true,
				// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
				slowExecutionThreshold       : 1000,
				// How many tracking profilers to keep in stack: Default is to monitor the last 20 requests
				maxProfilers                 : 25,
				// If enabled, the debugger will monitor the creation time of CFC objects via WireBox
				profileWireBoxObjectCreation : false,
				// Profile model objects annotated with the `profile` annotation
				profileObjects               : true,
				// If enabled, will trace the results of any methods that are being profiled
				traceObjectResults           : false,
				// Profile Custom or Core interception points
				profileInterceptions         : true,
				// By default all interception events are excluded, you must include what you want to profile
				includedInterceptions        : [],
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
				maxQueryRows : 50
			},
			// CacheBox Reporting
			cachebox : { enabled : false, expanded : false },
			// Modules Reporting
			modules  : { enabled : false, expanded : false },
			// Quick and QB Reporting
			qb       : { enabled : true, expanded : false },
			// cborm Reporting
			cborm    : { enabled : true, expanded : false }
		};

		// Visualizer Route
		router
			.route( "/" )
			.to( "Main.index" )
			.route( "/:action" )
			.toHandler( "Main" );
		;

		/**
		 * Custom Interception Points
		 */
		variables.interceptorSettings = {
			customInterceptionPoints : [
				// Before the debugger panel is rendered
				"beforeDebuggerPanel",
				// After the last debugger panel is rendered
				"afterDebuggerPanel",
				// Before any individual profiler report panels are rendered
				"beforeProfilerReportPanels",
				// After any individual profiler report panels are rendered
				"afterProfilerReportPanels",
				// When the request tracker has been created and placed in request scope
				"onDebuggerRequestTrackerCreation",
				// Before the request tracker is saved in the profiler, last chance to influence the recording
				"onDebuggerProfilerRecording"
			]
		};

		/******************** LOAD AOP MIXER ************************************/

		// Verify if the AOP mixer is loaded, if not, load it
		if ( !isAOPMixerLoaded() ) {
			loadAOPMixer();
		}

		/******************** DEBUGGER INTERCEPTORS ************************************/

		variables.interceptors = [ { class : "cbdebugger.interceptors.RequestCollector" } ];
	}

	/**
	 * Load the module
	 */
	function onLoad(){
		// default the password to something so we are secure by default
		if ( variables.settings.debugPassword eq "cb:null" ) {
			variables.settings.debugPassword = hash( getCurrentTemplatePath() );
		} else if ( len( variables.settings.debugPassword ) ) {
			// hash the password into memory
			variables.settings.debugPassword = hash( variables.settings.debugPassword );
		}

		// Configure the debugging mode from the loaded app settings
		wirebox.getInstance( "debuggerService@cbDebugger" ).setDebugMode( variables.settings.debugMode );

		/******************** PROFILE OBJECTS ************************************/

		if ( variables.settings.requestTracker.profileObjects ) {
			// Object Profiler Aspect
			binder
				.mapAspect( "ObjectProfiler" )
				.to( "#moduleMapping#.aspects.ObjectProfiler" )
				.initArg(
					name  = "traceResults",
					value = variables.settings.requestTracker.traceObjectResults
				);

			// Bind Object Aspects to monitor all a-la-carte profilers via method and component annotations
			binder.bindAspect(
				classes = binder.match().any(),
				methods = binder.match().annotatedWith( "profile" ),
				aspects = "ObjectProfiler"
			);
			binder.bindAspect(
				classes = binder.match().annotatedWith( "profile" ),
				methods = binder.match().any(),
				aspects = "ObjectProfiler"
			);
		}

		/******************** PROFILE INTERCEPTIONS ************************************/

		if ( variables.settings.requestTracker.profileInterceptions ) {
			// Register our interceptor profiler
			binder
				.mapAspect( "InterceptorProfiler" )
				.to( "#moduleMapping#.aspects.InterceptorProfiler" )
				.initArg(
					name  = "excludedInterceptions",
					value = controller.getInterceptorService().getInterceptionPoints()
				)
				.initArg(
					name  = "includedInterceptions",
					value = variables.settings.requestTracker.includedInterceptions
				);
			// Intercept all announcements
			binder.bindAspect(
				classes = binder.match().mappings( "coldbox.system.services.InterceptorService" ),
				methods = binder.match().methods( "announce" ),
				aspects = "InterceptorProfiler"
			);
			// Apply AOP
			wirebox.autowire(
				target   = controller.getInterceptorService(),
				targetID = "coldbox.system.services.InterceptorService"
			);
		}

		/******************** Register QB Collector ************************************/

		if ( variables.settings.qb.enabled && controller.getModuleService().isModuleRegistered( "qb" ) ) {
			controller
				.getInterceptorService()
				.registerInterceptor(
					interceptorClass = "#moduleMapping#.interceptors.QBCollector",
					interceptorName  = "QBCollector@cbdebugger"
				);
		}

		/******************** Register Quick Collector ************************************/

		if ( variables.settings.qb.enabled && controller.getModuleService().isModuleRegistered( "quick" ) ) {
			controller
				.getInterceptorService()
				.registerInterceptor(
					interceptorClass = "#moduleMapping#.interceptors.QuickCollector",
					interceptorName  = "QuickCollector@cbdebugger"
				);
		}

		/******************** Register cborm Collector ************************************/

		if ( variables.settings.cborm.enabled && controller.getModuleService().isModuleRegistered( "cborm" ) ) {
			controller
				.getInterceptorService()
				.registerInterceptor(
					interceptorClass = "#moduleMapping#.interceptors.CBOrmCollector",
					interceptorName  = "CBOrmCollector@cbdebugger"
				);
		}
	}

	/**
	 * Unloading
	 */
	function onUnload(){
		if ( variables.settings.qb.enabled && controller.getModuleService().isModuleRegistered( "qb" ) ) {
			controller.getInterceptorService().unregister( "QBCollector@cbdebugger" );
		}
		if ( variables.settings.qb.enabled && controller.getModuleService().isModuleRegistered( "quick" ) ) {
			controller.getInterceptorService().unregister( "QuickCollector@cbdebugger" );
		}
		if ( variables.settings.cborm.enabled && controller.getModuleService().isModuleRegistered( "cborm" ) ) {
			controller.getInterceptorService().unregister( "CBOrmCollector@cbdebugger" );
		}
	}

	/**
	 * Register our tracer appender after the configuration loads
	 */
	function afterConfigurationLoad(){
		if ( variables.settings.tracers.enabled ) {
			var logBox = controller.getLogBox();
			logBox.registerAppender(
				"tracer",
				"cbdebugger.appenders.TracerAppender"
			);
			var appenders = logBox.getAppendersMap( "tracer" );
			// Register the appender with the root loggger, and turn the logger on.
			var root      = logBox.getRootLogger();
			root.addAppender( appenders[ "tracer" ] );
			root.setLevelMax( 4 );
			root.setLevelMin( 0 );
		}
	}

	/**
	 * Loads the AOP mixer if not loaded in the application
	 */
	private function loadAOPMixer(){
		var mixer = new coldbox.system.aop.Mixer();
		// configure it
		mixer.configure( wirebox, {} );
		// register it
		controller
			.getInterceptorService()
			.registerInterceptor(
				interceptorObject = mixer,
				interceptorName   = "AOPMixer"
			);
	}

	/**
	 * Verify if wirebox aop mixer is loaded
	 */
	private boolean function isAOPMixerLoaded(){
		var listeners = wirebox.getBinder().getListeners();
		var results   = false;

		for ( var thisListener in listeners ) {
			if ( thisListener.class eq "coldbox.system.aop.Mixer" ) {
				results = true;
				break;
			}
		}

		return results;
	}

}
