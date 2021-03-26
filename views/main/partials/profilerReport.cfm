<cfoutput>
<div style="border-radius: 5px; border: 1px solid blue" class="mt5">

	<div class="pl10 pr10 pt5" style="border-bottom:1px solid blue; background-color: ##dde1e6">
		<div class="floatRight">
			<button
				type="button"
				title="Reload Report"
				id="cbd-buttonRefreshProfilers"
				onClick="cbdGetProfilerReport( '#args.profiler.id#' )"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
				</svg>
			</button>
		</div>

		<h4>
			<!--- Back --->
			<div>
				<button
					type="button"
					title="Back to profilers"
					id="cbd-buttonBackToProfilers"
					onClick="cbdRefreshProfilers()"
				>
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
					</svg>
				</button>

				<!--- Info --->
				#args.profiler.requestData.method#
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
				</svg>
				#args.profiler.fullUrl#
			</div>

			<div class="mt5 ml30 size12">
				<strong>Event: </strong>
				<span class="textBlue mr5">
					#args.profiler.coldbox.currentEvent#
				</span>

				<cfif len( args.profiler.coldbox.currentRoute )>
					<strong>Route: </strong>
					<span class="textBlue">
						#args.profiler.coldbox.currentRoute#
					</span>

					<cfif len( args.profiler.coldbox.currentRoute )>
						<strong>Route Name: </strong>
						<span class="textBlue">
							(#args.profiler.coldbox.currentRoute#)
						</span>
					</cfif>
				</cfif>

			</div>

			<div style="display: flex;" class="mt10 ml30 size10 textMuted">

				<div>
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
					</svg>
					#timeformat( args.profiler.timestamp, "hh:mm:ss.l tt" )#
					/ #dateformat( args.profiler.timestamp, "mmm.dd.yyyy" )#
				</div>

				<div class="ml10" title="Request Ip Address">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
					</svg>
					<a
						href="https://www.whois.com/whois/#args.profiler.ip#"
						target="_blank"
						title="Open whois for this ip address"
					>
						#args.profiler.ip#
					</a>
				</div>

				<div class="ml10" title="Server">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
					</svg>
					#args.environment.inetHost#
				</div>

				<div class="ml10" title="Thread Info">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
					</svg>
					#args.profiler.threadInfo.replaceNoCase( "Thread", "" )#
				</div>

				<div class="ml10" title="Status Code">
					<cfif args.profiler.response.statusCode gte 200 && args.profiler.response.statusCode lt 300 >
						<span class="fw_greenText">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
							#args.profiler.response.statusCode#
						</span>
					<cfelseif args.profiler.response.statusCode gte 300 && args.profiler.response.statusCode lt 400 >
						<span class="fw_blueText">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
							#args.profiler.response.statusCode#
						</span>
					<cfelseif args.profiler.response.statusCode gte 400>
						<span class="fw_redText">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
							#args.profiler.response.statusCode#
						</span>
					</cfif>
				</div>

				<div class="ml10" title="Response Content Type">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
					</svg>
					#args.profiler.response.contentType.listFirst( ";" )#
				</div>
			</div>

		</h4>
	</div>

	<div class="p10">
		<cfif !structIsEmpty( args.profiler )>
			<!--- Details Row --->
			<div>

				<!--- **************************************************************--->
				<!--- Exception Data --->
				<!--- **************************************************************--->
				<cfif !args.profiler.exception.isEmpty()>
					<h2>Exception Data</h2>
					<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
						<cfloop collection="#args.profiler.exception#" item="thisItem" >
							<cfif !isSimpleValue( args.profiler.exception[ thisItem ] ) OR len( args.profiler.exception[ thisItem ] )>
								<tr>
									<th width="200" align="right">
										#thisItem# :
									</th>
									<td>
										<div class="cellScroller">
											<cfif isSimpleValue( args.profiler.exception[ thisItem ] )>
												<cfif thisItem eq "stacktrace">
													#new coldbox.system.web.context.ExceptionBean().processStackTrace( args.profiler.exception[ thisItem ] )#
												<cfelse>
													#args.profiler.exception[ thisItem ]#
												</cfif>
											<cfelse>
												<cfdump var="#args.profiler.exception[ thisItem ]#">
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
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<tr>
						<th width="200">HTTP Method:</th>
						<td>#args.profiler.requestData.method#</td>
					</tr>
					<cfif !isNull( args.profiler.requestData.content )>
						<tr>
							<th width="200">HTTP Content:</th>
							<td>
								<div class="cellScroller">
									<cfif isSimpleValue( args.profiler.requestData.content )>
										<cfif len( args.profiler.requestData.content )>
											#args.profiler.requestData.content#
										<cfelse>
											<em>empty</em>
										</cfif>
									<cfelse>
										<cfdump var="#args.profiler.requestData.content#">
									</cfif>
								</div>
							</td>
						</tr>
					</cfif>
					<cfloop collection="#args.profiler.requestData.headers#" item="thisHeader" >
						<tr>
							<th width="200">
								Header-#thisHeader#:
							</th>
							<td>
								<div class="cellScroller">
									#replace( args.profiler.requestData.headers[ thisHeader ], ";", "<br>", "all" )#
								</div>
							</td>
						</tr>
					</cfloop>
				</table>

				<!--- **************************************************************--->
				<!--- Profiling Timers --->
				<!--- **************************************************************--->
				#renderView(
					view : "main/partials/debugTimers",
					module : "cbdebugger",
					args : {
						timers : args.profiler.timers,
						debuggerConfig : args.debuggerConfig,
						executionTime : args.profiler.executionTime
					},
					prePostExempt : true
				)#
			</div>
		<cfelse>
			<div class="textRed">
				Profiler with ID: #rc.id# not found!
			</div>
		</cfif>
	</div>
</div>
</cfoutput>