<cfoutput>
<div style="margin-top:40px"></div>
<div class="fw_debugPanel">

	<!--- **************************************************************--->
	<!--- TRACER STACK--->
	<!--- **************************************************************--->
	<cfinclude template="panels/tracersPanel.cfm">

	<!--- **************************************************************--->
	<!--- DEBUGGING PANEL --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.showInfoPanel>

		<div class="fw_titles" onClick="fw_toggle( 'fw_info' )" >
			&nbsp;
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z" />
			</svg>
			ColdBox Debugger v#getModuleConfig( "cbdebugger" ).version#
		</div>

		<div class="fw_debugContent<cfif args.debuggerConfig.expandedInfoPanel>View</cfif>" id="fw_info">

			<div>
				<form name="fw_reinitcoldbox" id="fw_reinitcoldbox" action="#args.urlBase#" method="POST">
					<input type="hidden" name="fwreinit" id="fwreinit" value="">
					<input
						type="button"
						value="Reinitialize Framework"
						name="reinitframework"
						title="Reinitialize the framework."
						onClick="fw_reinitframework( #iif( controller.getSetting( 'ReinitPassword' ).length(), 'true', 'false' )#)"
					>
					<cfif args.debuggerConfig.persistentRequestProfiler>
						&nbsp;
						<input
							type="button"
							value="Open Profiler Monitor"
							name="profilermonitor"
							title="Open the profiler monitor in a new window."
							onClick="window.open( '#args.urlBase#?debugpanel=profiler', 'profilermonitor', 'status=1,toolbar=0,location=0,resizable=1,scrollbars=1,height=750,width=850' )">
					</cfif>
					&nbsp;
					<input
						type="button"
						value="Turn Debugger Off"
						name="debuggerButton"
						title="Turn the ColdBox Debugger Off"
						onClick="window.location='#args.urlBase#?debugmode=false'">

				</form>
			<br>
			</div>

			<div class="fw_debugTitleCell">
				Framework Info:
			</div>
			<div class="fw_debugContentCell">
				#controller.getColdboxSettings().codename#
				#controller.getColdboxSettings().version#
				#controller.getColdboxSettings().suffix#
			</div>

			<div class="fw_debugTitleCell">
				Application Name:
			</div>
			<div class="fw_debugContentCell">
				#controller.getSetting( "AppName" )#
				<span class="fw_purpleText">
					(environment=#controller.getSetting( "Environment" )#)
				</span>
			</div>

			<div class="fw_debugTitleCell">
				TimeStamp:
			</div>
			<div class="fw_debugContentCell">
				#dateformat( now(), "MMM-DD-YYYY" )# #timeFormat( now(), "hh:MM:SS tt" )#
			</div>

			<div class="fw_debugTitleCell">
				Server Instance:
			</div>
			<div class="fw_debugContentCell">
				#args.inetHost# (#getLocalHostIP()#)
			</div>

			<cfif findNoCase( "lucee", server.coldfusion.productname  )>
				<div class="fw_debugTitleCell">
					HTTP Response:
				</div>
				<div class="fw_debugContentCell">
					statusCode=#args.httpResponse.getStatus()#;
					contentType=#args.httpResponse.getContentType()#
				</div>
			</cfif>

			<div class="fw_debugTitleCell">
				HTTP Method:
			</div>
			<div class="fw_debugContentCell">
				#getHTTPRequestData().method#
			</div>

			<div class="fw_debugTitleCell">
				HTTP Headers:
			</div>
			<div>
				<cfdump
					expand="false"
					label="HTTP Headers (click to expand)"
					var="#getHTTPRequestData().headers#">
			</div>

			<div class="fw_debugTitleCell">
				Current Event:
			</div>
			<div class="fw_debugContentCell">
				<cfif event.getCurrentEvent() eq "">
					<span class="fw_redText">N/A</span>
				<cfelse>
					#event.getCurrentEvent()#
				</cfif>
				<cfif event.isEventCacheable( )>
					<span class="fw_redText">&nbsp;CACHED EVENT</span>
				</cfif>
			</div>

			<div class="fw_debugTitleCell">
				Current Layout:
			</div>
			<div class="fw_debugContentCell">
				<cfif event.getCurrentLayout() eq "">
					<span class="fw_redText">N/A</span>
				<cfelse>
					#event.getCurrentLayout()#
				</cfif>
				(Module: #event.getCurrentLayoutModule()#)
			</div>

			<div class="fw_debugTitleCell">
				Current View:
			</div>
			<div class="fw_debugContentCell">
				<cfif event.getCurrentView() eq "">
					<span class="fw_redText">N/A</span>
				<cfelse>
					#event.getCurrentView()#
				</cfif>
			</div>

			<div class="fw_debugTitleCell">
				Route:
			</div>
			<div class="fw_debugContentCell">
				<cfif event.getCurrentRoute() eq "">
					<span class="fw_redText">N/A</span>
				<cfelse>
					#event.getCurrentRoute()#
				</cfif>
			</div>

			<div class="fw_debugTitleCell">
				Routed Record:
			</div>
			<div>
				<cfdump
					var="#event.getCurrentRouteRecord()#"
					expand="false"
					label="Route Record (click to expand)">
			</div>

			<div class="fw_debugTitleCell">
				Routed URL:
			</div>
			<div class="fw_debugContentCell">
				<cfif event.getCurrentRoutedURL() eq "">
					<span class="fw_redText">N/A</span>
				<cfelse>
					#event.getCurrentRoutedURL()#
				</cfif>
			</div>

			<div class="fw_debugTitleCell">
				LogBox Appenders:
			</div>
			<div class="fw_debugContentCell">
				#controller.getLogBox().getCurrentAppenders()#
			</div>
			<div class="fw_debugTitleCell">
				RootLogger Levels:
			</div>
			<div class="fw_debugContentCell">
				#controller.getLogBox().logLevels.lookup( controller.getLogBox().getRootLogger().getLevelMin() )# -
				#controller.getLogBox().logLevels.lookup( controller.getLogBox().getRootLogger().getLevelMax() )#
			</div>

			<!--- **************************************************************--->
			<!--- Debugging Timers --->
			<!--- **************************************************************--->
			#renderView(
				view : "main/partials/debugTimers",
				module : "cbdebugger",
				args : {
					timers : args.debugTimers,
					debuggerConfig : args.debuggerConfig
				},
				prePostExempt : true
			)#
			<!--- **************************************************************--->
		</div>
	</cfif>

	<!--- **************************************************************--->
	<!--- ColdBox Modules --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.showModulesPanel>
		<cfinclude template="panels/modulesPanel.cfm">
	</cfif>

	<!--- **************************************************************--->
	<!--- Request Collection Debug --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.showRCPanel>
		<div class="fw_titles"  onClick="fw_toggle( 'fw_reqCollection' )" >
			&nbsp;
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
			</svg>
			ColdBox Request Structures
		</div>
		<div class="fw_debugContent<cfif args.debuggerConfig.expandedRCPanel>View</cfif>" id="fw_reqCollection">
			<!--- Public Collection --->
			<cfset thisCollection = rc>
			<cfset thisCollectionType = "Public">
			<cfinclude template="panels/collectionPanel.cfm">
			<!--- Private Collection --->
			<cfset thisCollection = prc>
			<cfset thisCollectionType = "Private">
			<cfinclude template="panels/collectionPanel.cfm">
		</div>
	</cfif>

	<!--- **************************************************************--->
	<!--- qb debug --->
	<!--- **************************************************************--->
	<cfif args.debuggerConfig.showQBPanel>
		<cfinclude template="panels/qbPanel.cfm">
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
	<div class="fw_renderTime">Approximate Debug Rendering Time: #getTickCount() - args.debugStartTime# ms</div>

</div>
</cfoutput>