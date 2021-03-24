<cfoutput>
<!--- Start Rendering the Execution Profiler panel  --->
<div class="fw_titles" onClick="fw_toggle( 'fw_executionprofiler' )">
	&nbsp;
	<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
		<path fill-rule="evenodd" d="M2 5a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2V5zm14 1a1 1 0 11-2 0 1 1 0 012 0zM2 13a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2v-2zm14 1a1 1 0 11-2 0 1 1 0 012 0z" clip-rule="evenodd" />
	</svg>
	ColdBox Request Tracker (#arrayLen( args.profilers )# / #args.debuggerConfig.maxPersistentRequestProfilers#)
</div>
<div class="fw_debugContentView" id="fw_executionprofiler">

	<div style="float: right;">
		<input
		type="button"
		value="Open Profiler Monitor"
		name="profilermonitor"
		title="Open the profiler monitor in a new window."
		onClick="window.open( '#args.urlBase#?debugpanel=profiler', 'profilermonitor', 'status=1,toolbar=0,location=0,resizable=1,scrollbars=1,height=750,width=850' )">
	</div>

	<p>
		Below you can see the latest ColdBox requests made into the application.
		Click on the desired profiler to view its execution report.
	</p>

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
</cfoutput>