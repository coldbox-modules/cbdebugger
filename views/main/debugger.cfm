<!---
This main debugger view collects all the different panels to present to the user
--->
<cfoutput>
<div>
	<!--- **************************************************************--->
	<!--- PROFILER REPORTS --->
	<!--- **************************************************************--->
	<cfinclude template="panels/profilersPanel.cfm">

	<!--- **************************************************************--->
	<!--- MODULES PANEL --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.showModulesPanel>
		<cfinclude template="panels/modulesPanel.cfm">
	</cfif>


	<!--- **************************************************************--->
	<!--- CACHE PANEL --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.showCachePanel>
		<cfmodule template="/coldbox/system/cache/report/monitor.cfm"
				cacheFactory="#controller.getCacheBox()#"
				expandedPanel="#args.debuggerConfig.expandedCachePanel#">
	</cfif>

	<!--- Final Rendering --->
	<div class="mt10 mb10">
		<em>
			ColdBox Debug Rendering Time: #getTickCount() - args.debugStartTime# ms
		</em>
	</div>
</div>
</cfoutput>