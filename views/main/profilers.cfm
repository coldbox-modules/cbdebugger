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
	<table border="0" cellpadding="0" cellspacing="1" class="fw_debugTables" width="100%">
		<tr>
			<th align="left" width="100">
				Timestamp
			</th>
			<th align="left" width="150">
				Status Code<br>
				Content Type
			</th>
			<th align="left" width="150">
				Server<br>
				Thread
			</th>
			<th align="left" width="75">
				Request IP
			</th>
			<th align="left">
				Requested Url
			</th>
			<th width="50">
				Timers
			</th>
			<th width="100">
				Execution Time
			</th>
			<th width="50">
				Actions
			</th>
		</tr>

		<cfloop from="#arrayLen( args.profilers )#" to="1" step="-1" index="x">
			<cfset thisProfiler = args.profilers[ x ]>
			<tr>
				<td align="right">
					<div>
						#dateformat( thisProfiler.timestamp,"mmm.dd.yyyy" )#
					</div>
					<div>
						#timeformat( thisProfiler.timestamp,"hh:mm:ss.l tt")#
					</div>
				</td>
				<td align="left">
					<div>
						<cfif thisProfiler.statusCode gte 200 && thisProfiler.statusCode lt 300 >
							<span class="fw_greenText">
								#thisProfiler.statusCode#
							</span>
						<cfelseif thisProfiler.statusCode gte 300 && thisProfiler.statusCode lt 400 >
							<span class="fw_blueText">
								#thisProfiler.statusCode#
							</span>
						<cfelseif thisProfiler.statusCode gte 400>
							<span class="fw_redText">
								#thisProfiler.statusCode#
							</span>
						</cfif>
					</div>
					<div>
						#thisProfiler.contentType#
					</div>
				</td>
				<td>
					<div>
						#thisProfiler.inetHost#
					</div>
					<div>
						#thisProfiler.threadName#
					</div>
				</td>
				<td>
					#thisProfiler.ip#
				</td>
				<td>
					<div>
						#thisProfiler.requestData.method#>#thisProfiler.fullUrl#
					</div>
					<div style="margin-top: 5px">
						<strong>
							Event:
						</strong>
						#thisProfiler.currentEvent#

						<strong>
							Route:
						</strong>
						#thisProfiler.currentRoute#
						<cfif len( thisProfiler.currentRouteName )>
							(#thisProfiler.currentRouteName#)
						</cfif>
					</div>
				</td>
				<td align="center">
					#arrayLen( thisProfiler.timers )#
				</td>
				<td align="right">
					<cfif thisProfiler.executionTime gt args.debuggerConfig.slowExecutionThreshold>
						<span class="fw_redText">
							#numberFormat( thisProfiler.executionTime )#ms
						</span>
					<cfelse>
						#numberFormat( thisProfiler.executionTime )#ms
					</cfif>
				</td>
				<td align="center">
					<button
						title="Show Request"
						onClick="fw_toggleRow( 'fw_executionprofile_#thisProfiler.id#' )"
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
						</svg>
					</button>
				</td>
			</tr>
			<tr class="fw_hide" id="fw_executionprofile_#thisProfiler.id#">
				<td colspan="8">
					<div>
						<!--- **************************************************************--->
						<!--- Request Data --->
						<!--- **************************************************************--->
						<h2>Request</h2>
						<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
							<tr>
								<th width="200">HTTP Method:</th>
								<td>#thisProfiler.requestData.method#</td>
							</tr>
							<cfif !isNull( thisProfiler.requestData.content )>
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
							</cfif>
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

						<!--- **************************************************************--->
						<!--- Debug Timers --->
						<!--- **************************************************************--->
						#renderView(
							view : "main/partials/debugTimers",
							module : "cbdebugger",
							args : {
								timers : thisProfiler.timers,
								debuggerConfig : args.debuggerConfig,
								executionTime : thisProfiler.executionTime
							},
							prePostExempt : true
						)#
					</div>
				</td>
			</tr>
		</cfloop>
	</table>

</div>
<!--- **************************************************************--->
</cfoutput>