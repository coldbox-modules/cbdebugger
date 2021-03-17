<cfsetting enablecfoutputonly="true">
<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Template :  debug.cfm
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Debugging template for the application
----------------------------------------------------------------------->
<!--- Setup the panel --->
<cfsetting showdebugoutput="false">
<cfparam name="url.frequency" default="0">
<!--- Verify Frequency --->
<cfif not isNumeric(url.Frequency)>
	<cfset url.frequency = 0>
</cfif>
<cfoutput>
<html>
<head>
	<title>ColdBox Execution Profiler Monitor</title>
	<cfif url.frequency gt 0>
	<!--- Meta Tag Refresh --->
	<meta http-equiv="refresh" content="#url.frequency#">
	</cfif>
	<!--- Include Header --->
	<cfinclude template="/cbdebugger/includes/debugHeader.cfm">
</head>
<body>

	<div class="fw_debugPanel">

	<!--- **************************************************************--->
	<!--- TRACER STACK--->
	<!--- **************************************************************--->
	<cfinclude template="/cbdebugger/includes/panels/tracersPanel.cfm">

	<!--- Start Rendering the Execution Profiler panel  --->
	<div class="fw_titles">&nbsp;ColdBox Execution Profiler Report</div>
	<div class="fw_debugContentView" id="fw_executionprofiler">

		<div>
			<strong>Monitor Refresh Frequency (Seconds): </strong>
			<select id="frequency" style="font-size:10px" onChange="fw_pollmonitor('profiler',this.value,'#URLBase#')">
				<option value="0">No Polling</option>
				<cfloop from="5" to="30" index="i" step="5">
				<option value="#i#" <cfif url.frequency eq i>selected</cfif>>#i# sec</option>
				</cfloop>
			</select>
			<hr>
		</div>

		<div class="fw_debugTitleCell">
		  Profilers in stack
		</div>
		<div class="fw_debugContentCell">
		  #profilersCount# / #variables.debuggerConfig.maxPersistentRequestProfilers#
		</div>

		<p>Below you can see the incoming request profilers. Click on the desired profiler to view its execution report.</p>
		<!--- Render Profilers --->
		<cfloop from="#profilersCount#" to="1" step="-1" index="x">
			<cfset refLocal.thisProfiler = profilers[ x ]>
			<div class="fw_profilers" onClick="fw_toggle('fw_executionprofile_#x#')">&nbsp;#dateformat(refLocal.thisProfiler.datetime,"mm/dd/yyyy")# #timeformat(refLocal.thisProfiler.datetime,"hh:mm:ss.l tt")# (#refLocal.thisProfiler.ip#)</div>
			<div class="fw_debugContent" id="fw_executionprofile_#x#">


				<!--- **************************************************************--->
				<!--- Request Data --->
				<!--- **************************************************************--->
				<h2>Request</h2>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
					<tr>
						<th width="200">HTTP Method:</th>
						<td>#refLocal.thisProfiler.requestData.method#</td>
					</tr>
					<tr>
						<th width="200">HTTP Content:</th>
						<td style="overflow: auto; max-width:300px; max-height: 300px">
							<cfif isSimpleValue( refLocal.thisProfiler.requestData.content )>
								#refLocal.thisProfiler.requestData.content#
							<cfelse>
								<cfdump var="#refLocal.thisProfiler.requestData.content#">
							</cfif>
						</td>
					</tr>
					<cfloop collection="#refLocal.thisProfiler.requestData.headers#" item="thisHeader" >
						<tr>
							<th width="200">Header-#thisHeader#:</th>
							<td style="overflow-y: auto; max-width:300px">
								#replace( refLocal.thisProfiler.requestData.headers[ thisHeader ], ";", "<br>", "all" )#
							</td>
						</tr>
					</cfloop>
				</table>

				<!--- **************************************************************--->
				<!--- Response Data --->
				<!--- **************************************************************--->
				<cfif findNoCase( "lucee", server.coldfusion.productname )>
				<h2>Response</h2>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">

					<tr>
						<th width="200">Status Code:</th>
						<td>#refLocal.thisProfiler.statusCode#</td>
					</tr>
					<tr>
						<th width="200">Content Type:</th>
						<td>#refLocal.thisProfiler.contentType#</td>
					</tr>
				</table>
				</cfif>

				<!--- **************************************************************--->
				<!--- Method Executions --->
				<!--- **************************************************************--->
				<h2>Executions</h2>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
				  <tr>
					<th width="150" align="center" >Started At</th>
					<th width="150" align="center" >Finished At</th>
					<th width="10%" align="center" >Execution Time</th>
					<th >Framework Method</th>
				  </tr>
				  <cfloop array="#refLocal.thisProfiler.timers#" index="thisTimer">
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
				</table>
			</div>
		</cfloop>

	</div>
	<!--- **************************************************************--->

	</div><!--- End of Debug Panel Div --->

	<div align="center" style="margin-top:10px"><input type="button" name="close" value="Close Monitor" onClick="window.close()" style="font-size:10px"></div>
</body>
</html>
</cfoutput>
<cfsetting enablecfoutputonly="false">