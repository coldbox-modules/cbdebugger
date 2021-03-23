<cfoutput>
<div class="fw_debugPanel">

	<!--- **************************************************************--->
	<!--- TRACER STACK--->
	<!--- **************************************************************--->
	<cfinclude template="panels/tracersPanel.cfm">

	<!--- Start Rendering the Execution Profiler panel  --->
	<div class="fw_titles">&nbsp;ColdBox Execution Profiler Report</div>
	<div class="fw_debugContentView" id="fw_executionprofiler">

		<div>
			<strong>Monitor Refresh Frequency: </strong>
			<select
				id="frequency"
				style="font-size:10px"
				onChange="fw_pollmonitor( 'profiler', this.value, '#args.URLBase#' )">
					<option value="0">None</option>
					<option value="1" <cfif args.refreshFrequency eq 1>selected</cfif>>1 Seconds</option>
					<option value="3" <cfif args.refreshFrequency eq 3>selected</cfif>>3 Seconds</option>
					<cfloop from="5" to="30" index="i" step="5">
						<option value="#i#" <cfif args.refreshFrequency eq i>selected</cfif>>#i# Seconds</option>
					</cfloop>
			</select>
			<hr>
		</div>

		<div class="fw_debugTitleCell">
			Profilers in stack
		</div>
		<div class="fw_debugContentCell">
			#arrayLen( args.profilers )# / #args.debuggerConfig.maxPersistentRequestProfilers#
		</div>

		<p>Below you can see the incoming request profilers. Click on the desired profiler to view its execution report.</p>
		<!--- Render Profilers --->
		<cfloop from="#arrayLen( args.profilers )#" to="1" step="-1" index="x">
			<cfset thisProfiler = args.profilers[ x ]>
			<div class="fw_profilers" onClick="fw_toggle('fw_executionprofile_#x#')">&nbsp;#dateformat(thisProfiler.datetime,"mm/dd/yyyy")# #timeformat(thisProfiler.datetime,"hh:mm:ss.l tt")# (#thisProfiler.ip#)</div>
			<div class="fw_debugContent" id="fw_executionprofile_#x#">


				<!--- **************************************************************--->
				<!--- Request Data --->
				<!--- **************************************************************--->
				<h2>Request</h2>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
					<tr>
						<th width="200">HTTP Method:</th>
						<td>#thisProfiler.requestData.method#</td>
					</tr>
					<tr>
						<th width="200">HTTP Content:</th>
						<td style="overflow: auto; max-width:300px; max-height: 300px">
							<cfif isSimpleValue( thisProfiler.requestData.content )>
								#thisProfiler.requestData.content#
							<cfelse>
								<cfdump var="#thisProfiler.requestData.content#">
							</cfif>
						</td>
					</tr>
					<cfloop collection="#thisProfiler.requestData.headers#" item="thisHeader" >
						<tr>
							<th width="200">Header-#thisHeader#:</th>
							<td style="overflow-y: auto; max-width:300px">
								#replace( thisProfiler.requestData.headers[ thisHeader ], ";", "<br>", "all" )#
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
						<td>#thisProfiler.statusCode#</td>
					</tr>
					<tr>
						<th width="200">Content Type:</th>
						<td>#thisProfiler.contentType#</td>
					</tr>
				</table>
				</cfif>

				<!--- **************************************************************--->
				<!--- Debug Timers --->
				<!--- **************************************************************--->
				#renderView(
					view : "main/partials/debugTimers",
					module : "cbdebugger",
					args : {
						timers : thisProfiler.timers,
						debuggerConfig : args.debuggerConfig
					},
					prePostExempt : true
				)#
			</div>
		</cfloop>

	</div>
	<!--- **************************************************************--->

</div><!--- End of Debug Panel Div --->
</cfoutput>