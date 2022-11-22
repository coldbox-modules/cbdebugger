<!--- View Inputs --->
<cfparam name="args.debuggerService">
<cfparam name="args.environment">
<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.isVisualizer">
<cfoutput>
<div
	id="cbd-profiler-report"
	class="cbd-rounded mt10 mb10 cbd-reportContainer"
	x-data="{
		profilerId : '#args.profiler.id#',
		statusCode : '#args.profiler.response.statusCode#',
		statusColor (){
			if( this.statusCode >= 200 && this.statusCode < 300 )
				return 'cbd-text-green'

			if( this.statusCode >= 300 && this.statusCode < 400 )
				return 'cbd-text-blue'

			return 'cbd-text-red'
		}
	}"
>

	<!--- Header Panel --->
	<div class="pl10 pr10 pt5 cbd-reportHeader">

		<!--- Toolbar --->
		<div class="cbd-floatRight">
			<!--- VISUALIZER TOOLBAR --->
			<cfif args.isVisualizer>

				<!--- Refresh Button --->
				<button
					type="button"
					title="Refresh"
					@click="loadProfilerReport( profilerId )"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
					</svg>
				</button>

				<a
					href="#event.buildLink( 'cbdebugger:exportProfilerReport', { id : args.profiler.id } )#"
					target="_blank"
					class="pt5 pb5 cbd-button cbd-rounded"
					title="Export Profiler to JSON"
				><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3V10"></path></svg></a>

				<!--- Back to Profilers --->
				<button
					type="button"
					title="Back to profilers"
					@click="refreshProfilers()"
				>
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
					</svg>
				</button>
			</cfif>
		</div>

		<h4>
			<!--- Info --->
			<div
				class="cbd-size13"
			>
				<span title="Status Code">

					<span :class="statusColor">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
						</svg>
						#args.profiler.response.statusCode#
					</span>

				</span>

				<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
				  </svg>

				#args.profiler.requestData.method# > #args.profiler.fullUrl#
			</div>

			<!--- Execution Time --->
			<div
				class="cbd-floatRight cbd-size14 mt10 mr5 <cfif args.profiler.executionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold>cbd-badge-light<cfelse>cbd-badge-dark</cfif>"
				title="Total ColdBox Request Execution Time"
			>
				<span class="<cfif args.profiler.executionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold>cbd-text-red</cfif>">
					#numberFormat( args.profiler.executionTime )# ms
				</span>
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

				<div class="ml10" title="Free Memory Diff">
					<cfset diff = numberFormat( ( args.profiler.endFreeMemory - args.profiler.startFreeMemory ) / 1048576 )>
					<cfif diff gt 0>
						<span class="cbd-text-green">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
								<path fill-rule="evenodd" d="M12 7a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0V8.414l-4.293 4.293a1 1 0 01-1.414 0L8 10.414l-4.293 4.293a1 1 0 01-1.414-1.414l5-5a1 1 0 011.414 0L11 10.586 14.586 7H12z" clip-rule="evenodd" />
							</svg>
							#diff#MB
						</span>
					<cfelse>
						<span class="cbd-text-red">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
								<path fill-rule="evenodd" d="M12 13a1 1 0 100 2h5a1 1 0 001-1V9a1 1 0 10-2 0v2.586l-4.293-4.293a1 1 0 00-1.414 0L8 9.586 3.707 5.293a1 1 0 00-1.414 1.414l5 5a1 1 0 001.414 0L11 9.414 14.586 13H12z" clip-rule="evenodd" />
							</svg>
							#diff#MB
						</span>
					</cfif>
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
					debuggerConfig : args.debuggerConfig,
					debuggerService : args.debuggerService
				} )#

				<!--- **************************************************************--->
				<!--- Exception Data --->
				<!--- **************************************************************--->
				<cfif !args.profiler.exception.isEmpty()>
					#view(
						view : "main/panels/requestTracker/exceptionPanel",
						module : "cbdebugger",
						args : {
							debuggerConfig : args.debuggerConfig,
							profiler : args.profiler,
							debuggerService : args.debuggerService
						},
						prePostExempt : true
					)#
				</cfif>


				<!--- **************************************************************--->
				<!--- Profiling Timers --->
				<!--- **************************************************************--->
				#view(
					view : "main/panels/requestTracker/debugTimersPanel",
					module : "cbdebugger",
					args : {
						timers : args.profiler.timers,
						debuggerConfig : args.debuggerConfig,
						executionTime : args.profiler.executionTime,
						debuggerService : args.debuggerService
					},
					prePostExempt : true
				)#

				<!--- **************************************************************--->
				<!--- ColdBox Data --->
				<!--- **************************************************************--->
				#view(
					view : "main/panels/requestTracker/coldboxPanel",
					module : "cbdebugger",
					args : {
						profiler : args.profiler,
						debuggerConfig : args.debuggerConfig,
						debuggerService : args.debuggerService
					},
					prePostExempt : true
				)#

				<!--- **************************************************************--->
				<!--- HTTP Request Data --->
				<!--- **************************************************************--->
				#view(
					view : "main/panels/requestTracker/httpRequestPanel",
					module : "cbdebugger",
					args : {
						profiler : args.profiler,
						debuggerConfig : args.debuggerConfig,
						debuggerService : args.debuggerService
					},
					prePostExempt : true
				)#

				<!--- **************************************************************--->
				<!--- Tracers --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.tracers.enabled>
					#view(
						view : "main/panels/requestTracker/tracersPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							tracers : args.profiler.tracers,
							debuggerConfig : args.debuggerConfig,
							debuggerService : args.debuggerService
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- **************************************************************--->
				<!--- COLLECTIONS --->
				<!--- **************************************************************--->
				<!--- Only show if it's the same request, we don't store rc/prc to avoid memory leaks --->
				<cfif !args.isVisualizer and args.debuggerConfig.collections.enabled>
					#view(
						view : "main/panels/requestTracker/coldboxCollectionsPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							debuggerConfig : args.debuggerConfig,
							debuggerService : args.debuggerService
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- **************************************************************--->
				<!--- ACFSQL --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.acfSql.enabled>
					#view(
						view : "main/panels/requestTracker/acfSqlPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							debuggerConfig : args.debuggerConfig,
							debuggerService : args.debuggerService
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- **************************************************************--->
				<!--- CBORM --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.cborm.enabled>
					#view(
						view : "main/panels/requestTracker/cbormPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							debuggerConfig : args.debuggerConfig,
							debuggerService : args.debuggerService
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- **************************************************************--->
				<!--- QB/QUICK --->
				<!--- **************************************************************--->
				<cfif args.debuggerConfig.qb.enabled>
					#view(
						view : "main/panels/requestTracker/qbPanel",
						module : "cbdebugger",
						args : {
							profiler : args.profiler,
							debuggerConfig : args.debuggerConfig,
							debuggerService : args.debuggerService
						},
						prePostExempt : true
					)#
				</cfif>

				<!--- Event --->
				#announce( "afterProfilerReportPanels", {
					profiler : args.profiler,
					debuggerConfig : args.debuggerConfig,
					debuggerService : args.debuggerService
				} )#

			</div>
		<cfelse>
			<div class="cbd-text-red">
				Profiler with ID: #encodeForHTML( args.profiler.id )# not found!
			</div>
		</cfif>
	</div>

	<!--- Scroll to top --->
	<div class="mt10 mb10 cbd-text-center">
		<button
			type="button"
			title="Got to top of report"
			onClick="coldboxDebugger.scrollTo( 'cbd-request-tracker' )"
		>
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
			</svg>
		</button>
	</div>
</div>
</cfoutput>
