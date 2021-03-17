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
</cfscript>