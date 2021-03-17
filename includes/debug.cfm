<cfsetting enablecfoutputonly=true>
<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Template :  debug.cfm
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	The ColdBox debugger
----------------------------------------------------------------------->
<cfoutput>
<!--- set cbox debugger header --->
<cfinclude template="debugHeader.cfm">
<div style="margin-top:40px"></div>
<div class="fw_debugPanel">

	<!--- **************************************************************--->
	<!--- TRACER STACK--->
	<!--- **************************************************************--->
	<cfinclude template="panels/tracersPanel.cfm">

	<!--- **************************************************************--->
	<!--- DEBUGGING PANEL --->
	<!--- **************************************************************--->
	<cfif variables.debuggerConfig.showInfoPanel>
	<div class="fw_titles" onClick="fw_toggle('fw_info')" >
		&nbsp;ColdBox Debugger v#controller.getSetting( "modules" ).cbdebugger.version#
	</div>

	<div class="fw_debugContent<cfif variables.debuggerConfig.expandedInfoPanel>View</cfif>" id="fw_info">

		<div>
			<form name="fw_reinitcoldbox" id="fw_reinitcoldbox" action="#URLBase#" method="POST">
				<input type="hidden" name="fwreinit" id="fwreinit" value="">
				<input
					type="button"
					value="Reinitialize Framework"
					name="reinitframework"
					style="font-size:10px"
					title="Reinitialize the framework."
					onClick="fw_reinitframework(#iif( controller.getSetting( 'ReinitPassword' ).length(), 'true', 'false' )#)"
				>
				<cfif variables.debuggerConfig.persistentRequestProfiler>
					&nbsp;
					<input
						type="button"
						value="Open Profiler Monitor"
						name="profilermonitor"
						style="font-size:10px"
						title="Open the profiler monitor in a new window."
						onClick="window.open( '#URLBase#?debugpanel=profiler', 'profilermonitor', 'status=1,toolbar=0,location=0,resizable=1,scrollbars=1,height=750,width=850' )">
				</cfif>
				&nbsp;
				<input
					type="button"
					value="Turn Debugger Off"
					name="debuggerButton"
					style="font-size:10px"
					title="Turn the ColdBox Debugger Off"
					onClick="window.location='#URLBase#?debugmode=false'">

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
			#controller.getSetting( "AppName")#
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
	    	#getInetHost()# (#getLocalHostIP()#)
		</div>

		<cfif findNoCase( "railo,lucee", server.coldfusion.productname  )>
		<div class="fw_debugTitleCell">
			HTTP Response:
		</div>
		<div class="fw_debugContentCell">
			statusCode=#getPageContext().getResponse().getStatus()#;
	    	contentType=#getPageContext().getResponse().getContentType()#
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
	    	<cfdump expand="false" label="HTTP Headers (click to expand)" var="#getHTTPRequestData().headers#">
		</div>

		<div class="fw_debugTitleCell">
		  Current Event:
		</div>
		<div class="fw_debugContentCell">
			<cfif Event.getCurrentEvent() eq ""><span class="fw_redText">N/A</span><cfelse>#Event.getCurrentEvent()#</cfif>
			<cfif Event.isEventCacheable( )><span class="fw_redText">&nbsp;CACHED EVENT</span></cfif>
		</div>

		<div class="fw_debugTitleCell">
		  Current Layout:
		</div>
		<div class="fw_debugContentCell">
			<cfif Event.getCurrentLayout() eq ""><span class="fw_redText">N/A</span><cfelse>#Event.getCurrentLayout()#</cfif>
			(Module: #event.getCurrentLayoutModule()#)
		</div>

		<div class="fw_debugTitleCell">
		  Current View:
		</div>
		<div class="fw_debugContentCell">
			<cfif Event.getCurrentView() eq ""><span class="fw_redText">N/A</span><cfelse>#Event.getCurrentView()#</cfif>
		</div>

		<div class="fw_debugTitleCell">
		  Route:
		</div>
		<div class="fw_debugContentCell">
			<cfif Event.getCurrentRoute() eq ""><span class="fw_redText">N/A</span><cfelse>#event.getCurrentRoute()#</cfif>
		</div>

		<div class="fw_debugTitleCell">
			Routed Record:
		</div>
		<div>
			<cfdump var="#event.getCurrentRouteRecord()#" expand="false" label="Route Record (click to expand)">
		</div>

		<div class="fw_debugTitleCell">
		  Routed URL:
		</div>
		<div class="fw_debugContentCell">
			<cfif Event.getCurrentRoutedURL() eq ""><span class="fw_redText">N/A</span><cfelse>#event.getCurrentRoutedURL()#</cfif>
		</div>

		<div class="fw_debugTitleCell">
		  Routed Namespace:
		</div>
		<div class="fw_debugContentCell">
			<cfif event.getCurrentRoutedNamespace() eq ""><span class="fw_redText">N/A</span><cfelse>#event.getCurrentRoutedNamespace()#</cfif>
		</div>

		<div class="fw_debugTitleCell">
		  LogBox Appenders:
		</div>
		<div class="fw_debugContentCell">#controller.getLogBox().getCurrentAppenders()#</div>
		<div class="fw_debugTitleCell">
		  RootLogger Levels:
		</div>
		<div class="fw_debugContentCell">
			#controller.getLogBox().logLevels.lookup(controller.getLogBox().getRootLogger().getLevelMin())# -
			#controller.getLogBox().logLevels.lookup(controller.getLogBox().getRootLogger().getLevelMax())#
		</div>

		<!--- **************************************************************--->
		<!--- Method Executions --->
		<!--- **************************************************************--->
		<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
		  <tr>
		  	<th width="150" align="center" >Started At</th>
			<th width="150" align="center" >Finished At</th>
			<th width="150" align="center" >Execution Time</th>
			<th >Framework Method</th>
		  </tr>

		  <!--- Show Timers if any are found --->
		  <cfif arrayLen( debugTimers )>
			  <cfloop array="#debugTimers#" index="thisTimer">
				  <cfif findnocase( "render", thisTimer.method )>
				  	<cfset color = "fw_greenText">
				  <cfelseif findnocase( "interception", thisTimer.method )>
				  	<cfset color = "fw_blackText">
				  <cfelseif findnocase( "runEvent",  thisTimer.method )>
				  	<cfset color = "fw_blueText">
				  <cfelseif findnocase( "pre", thisTimer.method ) or findnocase( "post", thisTimer.method )>
				  	<cfset color = "fw_purpleText">
				  <cfelse>
				  	<cfset color = "fw_greenText">
				  </cfif>
				  <tr style="border-bottom:1px solid ##eaeaea">
				  	<td align="center" >
						#timeFormat( thisTimer.startedAt, "hh:MM:SS.l tt" )#
					</td>
					<td align="center" >
						#timeFormat( thisTimer.stoppedAt, "hh:MM:SS.l tt" )#
					</td>
					<td align="center" >
						<cfif thisTimer.executionTime gt 200>
							<span class="fw_redText">#thisTimer.executionTime# ms</span>
						<cfelse>
							#thisTimer.executionTime# ms
						</cfif>
					</td>
					<td>
						<span class="#color#">#thisTimer.method#</span>
					</td>
				  </tr>
			  </cfloop>
		  <cfelse>
		  	<tr>
			  	<td colspan="5">No Timers Found...</td>
			</tr>
		  </cfif>

		  <cfif structKeyExists( request, "fwExecTime" )>
			<tr>
				<th colspan="5">Total ColdBox Request Execution Time: #request.fwExecTime# ms</th>
			</tr>
		  </cfif>
		</table>
		<!--- **************************************************************--->
	</div>
	</cfif>

	<!--- **************************************************************--->
	<!--- CACHE PANEL --->
	<!--- **************************************************************--->
	<cfif variables.debuggerConfig.showCachePanel>
		<cfmodule template="/coldbox/system/cache/report/monitor.cfm"
				  cacheFactory="#controller.getCacheBox()#"
				  expandedPanel="#variables.debuggerConfig.expandedCachePanel#">
	</cfif>

	<!--- **************************************************************--->
	<!--- DUMP VAR --->
	<!--- **************************************************************--->
	<cfif controller.getSetting( "debugger"). EnableDumpVar>
		<cfif structKeyExists(rc,"dumpvar" )>
		<!--- Dump Var --->
		<div class="fw_titles" onClick="fw_toggle('fw_dumpvar')">&nbsp;Dumpvar</div>
		<div class="fw_debugContent" id="fw_dumpvar">
			<cfloop list="#rc.dumpvar#" index="i">
				<cfif isDefined( "#i #" )>
					<cfdump var="#evaluate(i)#" label="#i#" expand="false">
				<cfelseif event.valueExists(i )>
					<cfdump var="#event.getValue(i)#" label="#i#" expand="false">
				</cfif>
			</cfloop>
		</div>
		</cfif>
	</cfif>

	<!--- **************************************************************--->
	<!--- ColdBox Modules --->
	<!--- **************************************************************--->
	<cfif variables.debuggerConfig.showModulesPanel>
		<cfinclude template="panels/modulesPanel.cfm">
	</cfif>

	<!--- **************************************************************--->
	<!--- Request Collection Debug --->
	<!--- **************************************************************--->
	<cfif variables.debuggerConfig.showRCPanel>
		<div class="fw_titles"  onClick="fw_toggle('fw_reqCollection')" >
		&nbsp;ColdBox Request Structures
		</div>
		<div class="fw_debugContent<cfif variables.debuggerConfig.expandedRCPanel>View</cfif>" id="fw_reqCollection">
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
	<cfif variables.debuggerConfig.showQBPanel>
		<cfinclude template="panels/qbPanel.cfm">
	</cfif>

	<!--- Final Rendering --->
	<div class="fw_renderTime">Approximate Debug Rendering Time: #GetTickCount() - DebugStartTime# ms</div>

</div>
</cfoutput>
<cfsetting enablecfoutputonly=false>
