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


