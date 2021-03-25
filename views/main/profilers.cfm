<cfoutput>
<!--- Start Rendering the Execution Profiler panel  --->
<div class="fw_titles" onClick="fw_toggle( 'fw_executionprofiler' )">
	&nbsp;
	<span style="float: right;">
		v#getModuleConfig( "cbdebugger" ).version#
	</span>

	<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
		<path fill-rule="evenodd" d="M2 5a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2V5zm14 1a1 1 0 11-2 0 1 1 0 012 0zM2 13a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2v-2zm14 1a1 1 0 11-2 0 1 1 0 012 0z" clip-rule="evenodd" />
	</svg>
	ColdBox Debugger Request Tracker (#arrayLen( args.profilers )# / #args.debuggerConfig.maxPersistentRequestProfilers#)
</div>

<div class="fw_debugContentView" id="fw_executionprofiler">

	<!--- Toolbar --->
	<div class="floatRight">
		<form name="fw_reinitcoldbox" id="fw_reinitcoldbox" action="#args.urlBase#" method="POST">
			<input type="hidden" name="fwreinit" id="fwreinit" value="">

			<button
				title="Reinitialize the framework."
				onClick="fw_reinitframework( #iif( controller.getSetting( 'ReinitPassword' ).length(), 'true', 'false' )#)"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
				</svg>
			</button>

			<button
				title="Open the profiler monitor in a new window."
				onClick="window.open( '#args.urlBase#?debugpanel=profiler', 'profilermonitor', 'status=1,toolbar=0,location=0,resizable=1,scrollbars=1,height=750,width=850' )"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
				</svg>
			</button>

			<button
				title="Turn the ColdBox Debugger Off"
				onClick="window.location='#args.urlBase#?debugmode=false'"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
				</svg>
			</button>
		</form>
	</div>

	<!--- Info --->
	<p>
		Below you can see the latest ColdBox requests made into the application.
		Click on the desired profiler to view its execution report.
	</p>

	<!--- Machine Info --->
	<div class="fw_debugTitleCell">
		Framework Info:
	</div>
	<div class="fw_debugContentCell">
		#controller.getColdboxSettings().codename#
		#controller.getColdboxSettings().version#
		#controller.getColdboxSettings().suffix#
	</div>

	<!--- App Name + Environment --->
	<div class="fw_debugTitleCell">
		Application Name:
	</div>
	<div class="fw_debugContentCell">
		#controller.getSetting( "AppName" )#
		<span class="fw_purpleText">
			(environment=#controller.getSetting( "Environment" )#)
		</span>
	</div>

	<!--- App Name + Environment --->
	<div class="fw_debugTitleCell">
		CFML Engine:
	</div>
	<div class="fw_debugContentCell">
		#server.coldfusion.productName#
		<cfif server.keyExists( "lucee" )>
			#server.lucee.version#
		<cfelse>
			#server.coldfusion.productVersion#
		</cfif>
		/
		#server.java.vendor#
		#server.java.version#
	</div>

	<!--- Render Profilers --->
	<table border="0" cellpadding="0" cellspacing="1" class="fw_debugTables mt10" width="100%">
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
				Request
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
					<div class="mt10">
						<strong>
							Event:
						</strong>
						#thisProfiler.currentEvent#

						<cfif len( thisProfiler.currentRoute )>
							<strong>
								Route:
							</strong>
							#thisProfiler.currentRoute#
							<cfif len( thisProfiler.currentRouteName )>
								(#thisProfiler.currentRouteName#)
							</cfif>
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
						class="pt5 pb5 rounded"
						onClick="fw_toggleRow( 'fw_executionprofile_#thisProfiler.id#' )"
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 21h7a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v11m0 5l4.879-4.879m0 0a3 3 0 104.243-4.242 3 3 0 00-4.243 4.242z" />
						</svg>
					</button>
				</td>
			</tr>

			<!--- Details Row --->
			<tr class="fw_hide" id="fw_executionprofile_#thisProfiler.id#">
				<td colspan="8" class="bgLightGray">
					<div>

						<!--- **************************************************************--->
						<!--- Exception Data --->
						<!--- **************************************************************--->
						<cfif !thisProfiler.exception.isEmpty()>
							<h2>Exception Data</h2>
							<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
								<cfloop collection="#thisProfiler.exception#" item="thisItem" >
									<cfif !isSimpleValue( thisProfiler.exception[ thisItem ] ) OR len( thisProfiler.exception[ thisItem ] )>
										<tr>
											<th width="200" align="right">
												#thisItem# :
											</th>
											<td>
												<div class="cellScroller">
													<cfif isSimpleValue( thisProfiler.exception[ thisItem ] )>
														<cfif thisItem eq "stacktrace">
															#new coldbox.system.web.context.ExceptionBean().processStackTrace( thisProfiler.exception[ thisItem ] )#
														<cfelse>
															#thisProfiler.exception[ thisItem ]#
														</cfif>
													<cfelse>
														<cfdump var="#thisProfiler.exception[ thisItem ]#">
													</cfif>
												</div>
											</td>
										</tr>
									</cfif>
								</cfloop>
							</table>
						</cfif>

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
									<td>
										<div class="cellScroller">
											<cfif isSimpleValue( thisProfiler.requestData.content )>
												<cfif len( thisProfiler.requestData.content )>
													#thisProfiler.requestData.content#
												<cfelse>
													<em>empty</em>
												</cfif>
											<cfelse>
												<cfdump var="#thisProfiler.requestData.content#">
											</cfif>
										</div>
									</td>
								</tr>
							</cfif>
							<cfloop collection="#thisProfiler.requestData.headers#" item="thisHeader" >
								<tr>
									<th width="200">
										Header-#thisHeader#:
									</th>
									<td>
										<div class="cellScroller">
											#replace( thisProfiler.requestData.headers[ thisHeader ], ";", "<br>", "all" )#
										</div>
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
						<!--- Profiling Timers --->
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