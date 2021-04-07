<!---
This main debugger view collects all the different panels to present to the user
We use cfinclude to be fast and sneaky
--->
<cfoutput>
<div>

	<!--- **************************************************************--->
	<!--- REQUEST TRACKER REPORTS --->
	<!--- **************************************************************--->
	<cfinclude template="panels/requestTrackerPanel.cfm">

	<!--- **************************************************************--->
	<!--- MODULES PANEL --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.modules.enabled>
		<cfinclude template="panels/modulesPanel.cfm">
	</cfif>

	<!--- **************************************************************--->
	<!--- ASYNC PANEL --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.async.enabled>
		<cfinclude template="panels/asyncPanel.cfm">
	</cfif>

	<!--- **************************************************************--->
	<!--- CACHE PANEL --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.cachebox.enabled>
		<cfinclude template="panels/cacheBoxPanel.cfm">
	</cfif>

	<!--- **************************************************************--->
	<!--- FOOTER --->
	<!--- **************************************************************--->

	<!--- Debugger Version --->
	<span class="mt10 mb10 cbd-floatRight">
		ColdBox Debugger v#getModuleConfig( "cbdebugger" ).version#
	</span>

	<!--- Final Rendering --->
	<div class="mt10 mb10">
		<em>
			Debug Rendering Time: #getTickCount() - args.debugStartTime# ms
		</em>
	</div>
</div>
</cfoutput>