<!---
This main debugger view collects all the different panels to present to the user
We use cfinclude to be fast and sneaky
--->
<cfparam name="args.currentProfiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfparam name="args.debugStartTime">
<cfparam name="args.environment">
<cfparam name="args.isVisualizer">
<cfparam name="args.manifestRoot">
<cfparam name="args.moduleRoot">
<cfparam name="args.moduleSettings">
<cfparam name="args.pageTitle">
<cfparam name="args.profilers">
<cfparam name="args.refreshFrequency">
<cfparam name="args.urlBase">
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
		ColdBox Debugger v#args.moduleSettings[ "cbdebugger" ].version#
	</span>

	<!--- Final Rendering --->
	<div class="mt10 mb10">
		<em>
			Debug Rendering Time: #numberFormat( getTickCount() - args.debugStartTime )# ms
		</em>
	</div>
</div>
</cfoutput>
