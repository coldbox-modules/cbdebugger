[![Build Status](https://travis-ci.com/coldbox-modules/cbox-debugger.svg?branch=master)](https://travis-ci.com/coldbox-modules/cbox-debugger)

# Welcome To The ColdBox Debugger Module

This module will enhance your application with debugger and profiling capabilities, a nice debugging panel and much more to make your ColdBox application development nicer, funer and greater! Yes, funer is a word!

## LICENSE

Apache License, Version 2.0.

## Important Links

- https://github.com/coldbox-modules/cbox-debugger
- https://www.forgebox.io/view/cbdebugger
- https://community.ortussolutions.com/c/box-modules/cbdebugger/38
- [Changelog](changelog.md)

## System Requirements

- Lucee 5+
- ColdFusion 2016+
- ColdBox 6+

# Instructions

Just drop into your **modules** folder or use CommandBox to install

`box install cbdebugger`

This will activate the debugger in your application and render out at the end of a request or by visiting the debugger request tracker visualizer at `/cbdebugger`.

## Settings

The debugger is highly configurable and we have tons of settings to assist you in your development adventures and also in your performance tuning adventures. Please note that the more collectors you active, the slower your application can become.  By default we have pre-selected defaults which add neglible performance to your applications.

Open your `config/coldbox.cfc` configuration object and add into the `moduleSettings` the `cbDebugger` key with the following options:

```js
moduleSettings = {
	// Debugger Settings
	cbDebugger = {
		// Turn the debugger on/off by default. You can always enable it via the URL using your debug password
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
			maxQueryRows : 50
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

The module will also register two model objects for you:

* `debuggerService@cbdebugger`
* `timer@cbdebugger`

The `DebuggerService` can be used a-la-carte for your debugging purposes.
The `Timer` object will allow you to time code execution and send the results to the debugger panel.

## Mixins

This module will also register a few methods in all your handlers/interceptors/layouts and views:

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
```

## LogBox Appender

This module also comes with a LogBox appender called `cbdebugger.appenders.TracerAppender` so your application can log to the debugger's tracer.  You won't be able to configure the appender in your main LogBox configuration since modules aren't loaded until after LogBox is already created.  What you can do though is add the appender programmatically to LogBox using the `afterConfigurationLoad` interception point.  Here's an example of what that might look like:

```js
// This appender is part of a module, so we need to register it after the modules have been loaded.
function afterConfigurationLoad() {
    var logBox = controller.getLogBox();
    logBox.registerAppender( 'tracer', 'cbdebugger.appenders.TracerAppender' );
    var appenders = logBox.getAppendersMap( 'tracer' );

    // Register the appender with the root loggger, and turn the logger on.
    var root = logBox.getRootLogger();
    root.addAppender( appenders['tracer'] );
    root.setLevelMax( 4 );
    root.setLevelMin( 0 );
}
```

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
