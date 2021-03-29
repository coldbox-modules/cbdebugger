<!---
This main debugger view collects all the different panels to present to the user
--->
<cfoutput>
<div>
	<!--- **************************************************************--->
	<!--- REQUEST PROFILERS--->
	<!--- **************************************************************--->
	<cfinclude template="panels/profilersPanel.cfm">

	<!--- **************************************************************--->
	<!--- COLLECTIONS --->
	<!--- **************************************************************--->
	<!--- Only show if it's the same request, we don't store rc/prc to avoid memory leaks --->
	<cfif args.debuggerConfig.showRCPanel>
		<div class="fw_titles"  onClick="fw_toggle( 'cbd-requestCollections' )" >
			&nbsp;
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
			</svg>
			ColdBox Request Structures
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
			</svg>
			#event.getCurrentEvent()#
		</div>
		<div class="fw_debugContent<cfif args.debuggerConfig.expandedRCPanel>View</cfif>" id="cbd-requestCollections">
			<!--- Public Collection --->
			#renderView(
				view : "main/panels/collectionPanel",
				module : "cbdebugger",
				args : {
					collection : rc,
					collectionType : "Public",
					debuggerConfig : args.debuggerConfig
				},
				prePostExempt : true
			)#
			<!--- Private Collection --->
			#renderView(
				view : "main/panels/collectionPanel",
				module : "cbdebugger",
				args : {
					collection : prc,
					collectionType : "Private",
					debuggerConfig : args.debuggerConfig
				},
				prePostExempt : true
			)#
		</div>
	</cfif>

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