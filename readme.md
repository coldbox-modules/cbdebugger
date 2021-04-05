[![Build Status](https://travis-ci.com/coldbox-modules/cbox-debugger.svg?branch=master)](https://travis-ci.com/coldbox-modules/cbox-debugger)

# Welcome To The ColdBox Debugger Module

The ColdBox Debugger module is a light-weigth performance monitor and profiling tool for ColdBox applications.  It can generate a nice debugging panel on every rendered page or a dedicated visualizer to make your ColdBox application development nicer, funer and greater! Yes, funer is a word!
****
<p align="center">
	<img src="https://raw.githubusercontent.com/coldbox-modules/cbdebugger/development/test-harness/includes/images/debugger-visualizer.png">
	Debugger Request Visualizer
</p>

<br>

<p align="center">
	<img src="https://raw.githubusercontent.com/coldbox-modules/cbdebugger/development/test-harness/includes/images/debugger-collapsed.png">
	Request Tracker Collapsed
</p>

## LICENSE

Apache License, Version 2.0.

## Important Links

- https://github.com/coldbox-modules/cbox-debugger
- https://www.forgebox.io/view/cbdebugger
- https://community.ortussolutions.com/c/box-modules/cbdebugger/38
- [Changelog](changelog.md)

## System Requirements

- Lucee 5+
- ColdFusion 2018+
- ColdBox 6+

# Instructions

Just drop into your **modules** folder or use CommandBox to install

`box install cbdebugger`

This will activate the debugger in your application and render out at the end of a request or by visiting the debugger request tracker visualizer at `/cbdebugger`.

## Capabilities

The ColdBox debugger is a full fledged lightweith performance monitor for your ColdBox applications.  It tracks your requests, whether Ajax, traditional or REST, it's environment, execution and much more.  Here is a listing of some of the capabilities you get with the ColdBox Debugger:

- Track all incoming requests to your applications in memory or offloaded cache
- Track exceptions and execution environment
- Track incoming http requests, parameters, body and much more
- Track request collections
- Track Hibernate and `cborm` queries, criteria queries and session stats
- Track `qb` and `quick` queries, entities and stats
- Tap into LogBox via our Tracer messages and discover logging on a per request basis
- Profile execution and results of **ANY** model object
- Profile execution of any ColdBox interception point
- Custom Timer helpers for adding timing methods and annotations anywhere in -our code
- Profile your production or development apps with ease
- Track ColdBox modules and lifecycles
- Highly configurable
- Highly extensible

## Settings

The debugger is highly configurable and we have tons of settings to assist you in your development adventures and also in your performance tuning adventures. Please note that the more collectors you active, the slower your application can become.  By default we have pre-selected defaults which add neglible performance to your applications.

Open your `config/coldbox.cfc` configuration object and add into the `moduleSettings` the `cbDebugger` key with the following options:

```js
moduleSettings = {
	// Debugger Settings
	cbDebugger = {
		// Master switch to enable/disable request tracking into storage facilities.
		enabled : true,
		// Turn the debugger UI on/off by default. You can always enable it via the URL using your debug password
		// Please note that this is not the same as the master switch above
		// The debug mode can be false and the debugger will still collect request tracking
		debugMode : true,
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
			profileObjects               : false,
			// If enabled, will trace the results of any methods that are being profiled
			traceObjectResults           : false,
			// Profile Custom or Core interception points
			profileInterceptions         : false,
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
			maxQueryRows : 50,
			// Max number to use when dumping objects via the top argument
			maxDumpTop: 5
		},
		// CacheBox Reporting
		cachebox : { enabled : false, expanded : false },
		// Modules Reporting
		modules  : { enabled : false, expanded : false },
		// Quick and QB Reporting
		qb       : {
			enabled   : true,
			expanded  : false,
			// Log the binding parameters
			logParams : true
		},
		// cborm Reporting
		cborm : {
			enabled   : true,
			expanded  : false,
			// Log the binding parameters
			logParams : true
		}
	}
}
```

## WireBox Mappings

The module will also register the following model objects for you:

- `debuggerService@cbdebugger`
- `timer@cbdebugger`
  
The `DebuggerService` can be used a-la-carte for your debugging purposes.
The `Timer` object will allow you to time code execution and send the results to the debugger panel.

## Helper Mixins

This module will also register a few methods in all your handlers/interceptors/layouts and views.  You can use them for turning the debugger panel on/off, timing code execution and much more.

```js
	/**
	 * Method to turn on the rendering of the debug panel on a reqquest
	 */
	any function showDebugger()

	/**
	 * Method to turn off the rendering of the debug panel on a reqquest
	 */
	any function hideDebugger()

	/**
	 * See if the debugger will be rendering or not
	 */
	boolean function isDebuggerRendering()

	/**
	 * Start a timer with a tracking label
	 *
	 * @label The tracking label to register
	 *
	 * @return A unique tracking hash you must use to stop the timer
	 */
	function startCBTimer( required label )

	/**
	 * End a code timer with a tracking hash. If the tracking hash is not tracked we ignore it
	 *
	 * @labelHash The timer label hash to stop
	 */
	function stopCBTimer( required labelHash )

	/**
	 * Time the execution of the passed closure that we will execution for you
	 *
	 * @label The label to use as a timer label
	 * @closure The target to execute and time
	 */
	function cbTimeIt( required label, required closure )

	/**
	 * Shortcut to get a reference to the ColdBox Debugger Service
	 */
	function getCBDebugger()

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
	DebuggerService function cbTracer(
		required message,
		severity  = "info",
		category  = "",
		timestamp = now(),
		extraInfo = ""
	)
```

## Deubgger Events



********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

### HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
