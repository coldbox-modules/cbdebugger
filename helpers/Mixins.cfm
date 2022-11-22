<cfscript>
	/**
	 * Method to turn on the rendering of the debug panel on a reqquest
	 */
	any function showDebugger(){
		getRequestContext().setPrivateValue( name="cbox_debugger_show", value=true );
		return this;
	}

	/**
	 * Method to turn off the rendering of the debug panel on a reqquest
	 */
	any function hideDebugger(){
		getRequestContext().setPrivateValue( name="cbox_debugger_show", value=false );
		return this;
	}

	/**
	 * See if the debugger will be rendering or not
	 */
	boolean function isDebuggerRendering(){
		return getRequestContext().getPrivateValue( name="cbox_debugger_show", defaultValue=true );
	}

	/**
	 * Start a timer with a tracking label
	 *
	 * @label The tracking label to register
	 *
	 * @return A unique tracking hash you must use to stop the timer
	 */
	function startCBTimer( required label ){
		return variables.wirebox.getInstance( "Timer@cbdebugger" ).start( arguments.label );
	}

	/**
	 * End a code timer with a tracking hash. If the tracking hash is not tracked we ignore it
	 *
	 * @labelHash The timer label hash to stop
	 */
	function stopCBTimer( required labelHash ){
		return variables.wirebox.getInstance( "Timer@cbdebugger" ).stop( arguments.labelHash );
	}

	/**
	 * Time the execution of the passed closure that we will execution for you
	 *
	 * @label The label to use as a timer label
	 * @closure The target to execute and time
	 * @metadata A struct of metadata to store in the execution timer
	 */
	function cbTimeIt( required label, required closure, struct metadata = {} ){
		return variables.wirebox.getInstance( "Timer@cbdebugger" ).timeIt( argumentCollection=arguments );
	}

	/**
	 * Shortcut to get a reference to the ColdBox Debugger Service
	 */
	function getCBDebugger(){
		return variables.wirebox.getInstance( "debuggerService@cbdebugger" );
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
	DebuggerService function cbTracer(
		required message,
		severity  = "info",
		category  = "",
		timestamp = now(),
		extraInfo = ""
	){
		return getCBDebugger().pushTracer( argumentCollection=arguments );
	}

</cfscript>
