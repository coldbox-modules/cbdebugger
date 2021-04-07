<cfoutput>
<div class="cbd-rounded mt10 mb10 cbd-reportContainer">

	<!--- Header Panel --->
	<div class="pl10 pr10 pt5 cbd-reportHeader">

		<!--- Reload Report Button --->
		<div class="cbd-floatRight">
			<!--- Back Only on Ajax --->
			<cfif args.isVisualizer>
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
			</cfif>
			<button
				type="button"
				title="Reload Report"
				id="cbd-buttonGetProfilerReport-#args.profiler.id#"
				onClick="cbdGetProfilerReport( '#args.profiler.id#', #args.isVisualizer ? 'true' : 'false'# )"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
				</svg>
			</button>
		</div>

		<h4>
			<!--- Info --->
			<div
				class="cbd-size13"
			>
				<span title="Status Code">
					<cfif args.profiler.response.statusCode gte 200 && args.profiler.response.statusCode lt 300 >
						<span class="cbd-text-green">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
							#args.profiler.response.statusCode#
						</span>
					<cfelseif args.profiler.response.statusCode gte 300 && args.profiler.response.statusCode lt 400 >
						<span class="cbd-text-blue">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
							#args.profiler.response.statusCode#
						</span>
					<cfelseif args.profiler.response.statusCode gte 400>
						<span class="cbd-text-red">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
							#args.profiler.response.statusCode#
						</span>
					</cfif>
				</span>

				<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
				  </svg>

				#args.profiler.requestData.method# : #args.profiler.fullUrl#
			</div>

			<!--- Execution Time --->
			<div
				class="cbd-floatRight cbd-size14 mt10 mr5 <cfif args.profiler.executionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold>cbd-badge-light<cfelse>cbd-badge-dark</cfif>"
				title="Total ColdBox Request Execution Time"
			>
				<cfif args.profiler.executionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold>
					<span class="cbd-text-red">
						#numberFormat( args.profiler.executionTime )# ms
					</span>
				<cfelse>
					#numberFormat( args.profiler.executionTime )# ms
				</cfif>
			</div>

			<!--- Current Event --->
			<div class="mt5 cbd-size12 cbd-badge-light">
				<strong>Event: </strong>
				<span class="textBlue mr5">
					#args.profiler.coldbox.event#
				</span>
			</div>

			<!--- Info Bar --->
			<div class="cbd-flex mt10 cbd-size11 cbd-text-muted">

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
					#args.profiler.inetHost#
				</div>

				<div class="ml10" title="Thread Info">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
					</svg>
					#args.profiler.threadInfo.replaceNoCase( "Thread", "" )#
				</div>

				<div class="ml10" title="Machine Ip">
					<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
					</svg>
					#args.profiler.localIp#
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

	<!--- Content Report --->
	<div class="p10">
		<cfif !structIsEmpty( args.profiler )>
			<!--- Details Row --->
			<div>

				<!--- Event --->
				#announce( "beforeProfilerReportPanels", {
					profiler : args.profiler,
					debuggerConfig : args.debuggerConfig
				} )#

				<!--- **************************************************************--->
				<!--- Exception Data --->
				<!--- **************************************************************--->
				<cfif !args.profiler.exception.isEmpty()>
					#renderView(
						view : "main/panels/exceptionPanel",
						module : "cbdebugger",
						args : {
							debuggerConfig : args.debuggerConfig,
							profiler : args.profiler
						},
						prePostExempt : true
					)#
				</cfif>


				<!--- **************************************************************--->
				<!--- Profiling Timers --->
				<!--- **************************************************************--->
				#renderView(
					view : "main/panels/debugTimersPanel",
					module : "cbdebugger",
					args : {
						timers : args.profiler.timers,
						debuggerConfig : args.debuggerConfig,
						executionTime : args.profiler.executionTime
					},
					prePostExempt : true
				)#

				<!--- **************************************************************--->
				<!--- ColdBox Data --->
				<!--- **************************************************************--->
				#renderView(
					view : "main/panels/coldboxPanel",
					module : "cbdebugger",
					args : {
						profiler : args.profiler,
						debuggerConfig : args.debuggerConfig
					},
					prePostExempt : true
				)#

				<!--- **************************************************************--->
				<!--- HTTP Request Data --->
				<!--- **************************************************************--->
				#renderView(
					view : "main/panels/httpRequestPanel",
					module : "cbdebugger",
					args : {
						profiler : args.profiler,
						debuggerConfig : args.debuggerConfig
					},
					prePostExempt : true
				)#

				<!--- **************************************************************--->
				<!--- Tracers --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.tracers.enabled>
					#renderView(
						view : "main/panels/tracersPanel",
						module : "cbdebugger",
						args : {
							tracers : args.profiler.tracers,
							debuggerConfig : args.debuggerConfig
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- **************************************************************--->
				<!--- COLLECTIONS --->
				<!--- **************************************************************--->
				<!--- Only show if it's the same request, we don't store rc/prc to avoid memory leaks --->
				<cfif !args.isVisualizer and args.debuggerConfig.collections.enabled>
					<div class="cbd-titles"  onClick="cbdToggle( 'cbd-requestCollections' )" >
						&nbsp;
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
						</svg>
						ColdBox Request Structures
					</div>
					<div
						class="cbd-contentView<cfif args.debuggerConfig.collections.expanded> cbd-show<cfelse> cbd-hide</cfif>"
						id="cbd-requestCollections"
					>
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
				<!--- CBORM --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.cborm.enabled>
					#renderView(
						view : "main/panels/cbormPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							debuggerConfig : args.debuggerConfig
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- **************************************************************--->
				<!--- QB/QUICK --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.qb.enabled>
					#renderView(
						view : "main/panels/qbPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							debuggerConfig : args.debuggerConfig
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- Event --->
				#announce( "afterProfilerReportPanels", {
					profiler : args.profiler,
					debuggerConfig : args.debuggerConfig
				} )#

			</div>
		<cfelse>
			<div class="cbd-text-red">
				Profiler with ID: #rc.id# not found!
			</div>
		</cfif>
	</div>

	<!--- Scroll to top --->
	<div class="mt10 mb10 cbd-text-center">
		<button
			type="button"
			title="Got to top of report"
			onClick="cbdScrollToProfilerReport()"
		>
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
			</svg>
		</button>
	</div>
</div>
</cfoutput>