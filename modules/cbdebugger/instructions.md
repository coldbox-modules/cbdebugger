#INSTRUCTIONS

Just drop into your **modules** folder or use CommandBox to install

`box install cbdebugger`

This will activate the debugger in your application and render out at the end of a request.  

## Settings
This will also allow you to use several settings in your parent application or you can modify the settings in the `ModuleConfig` if desired. We recommend placing your debugger settings in your main `ColdBox.cfc` configuration file under a `debugger` struct.

```js
// Debugger Settings
debugger = {
	// Activate debugger for everybody
	debugMode = true,
	// Setup a password for the panel
	debugPassword = "",
	enableDumpVar = true,
	persistentRequestProfiler = true,
	maxPersistentRequestProfilers = 10,
	maxRCPanelQueryRows = 50,
	showTracerPanel = true,
	expandedTracerPanel = true,
	showInfoPanel = true,
	expandedInfoPanel = true,
	showCachePanel = true,
	expandedCachePanel = false,
	showRCPanel = true,
	expandedRCPanel = false,
	showModulesPanel = true,
	expandedModulesPanel = false,
	showRCSnapshots = false,
	wireboxCreationProfiler=false
};
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

This module also comes with a LogBox appender called `cbdebugger.includes.appenders.ColdBoxTracerAppender` so your application can log to the debugger's tracer.  You won't be able to configure the appender in your main LogBox configuration since modules aren't loaded until after LogBox is already created.  What you can do though is add the appender programmatically to LogBox using the `afterConfigurationLoad` interception point.  Here's an example of what that might look like:


```js
// This appender is part of a module, so we need to register it after the modules have been loaded.
function afterConfigurationLoad() {
	var logBox = controller.getLogBox();
	logBox.registerAppender( 'tracer', 'cbdebugger.includes.appenders.ColdBoxTracerAppender' );
	var appenders = logBox.getAppendersMap( 'tracer' );
	
	// Register the appender with the root loggger, and turn the logger on.
	var root = logBox.getRootLogger();
	root.addAppender( appenders['tracer'] );
	root.setLevelMax( 4 );
	root.setLevelMin( 0 );
}
```

