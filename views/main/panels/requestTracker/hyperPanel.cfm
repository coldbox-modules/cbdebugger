<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
	formatter = args.debuggerService.getFormatter();
	appPath = getSetting( "ApplicationPath" );
</cfscript>
<cfoutput>
<div
	id="cbd-hyper-panel"
	x-data="{
		panelOpen : #args.debuggerConfig.hyper.expanded ? 'true' : 'false'#,
		queryView : 'grouped',
		isGroupView(){
			return this.queryView == 'grouped'
		},
		isTimelineView(){
			return this.queryView == 'timeline'
		},
		isSlowestView(){
			return this.queryView == 'slowest'
		}
	}"
>
	<!--- Panel Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cloud-lightning" viewBox="0 0 16 16">
			<path d="M13.405 4.027a5.001 5.001 0 0 0-9.499-1.004A3.5 3.5 0 1 0 3.5 10H13a3 3 0 0 0 .405-5.973zM8.5 1a4 4 0 0 1 3.976 3.555.5.5 0 0 0 .5.445H13a2 2 0 0 1 0 4H3.5a2.5 2.5 0 1 1 .605-4.926.5.5 0 0 0 .596-.329A4.002 4.002 0 0 1 8.5 1zM7.053 11.276A.5.5 0 0 1 7.5 11h1a.5.5 0 0 1 .474.658l-.28.842H9.5a.5.5 0 0 1 .39.812l-2 2.5a.5.5 0 0 1-.875-.433L7.36 14H6.5a.5.5 0 0 1-.447-.724l1-2z"/>
		</svg>
		Hyper

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
		</svg>

		<!--- Count --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
		</svg>
		#args.profiler.hyper.totalRequests#

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>
		#numberFormat( args.profiler.hyper.totalExecutionTime )# ms
	</div>

	<!--- Panel Content --->
	<div
		class="cbd-contentView p20"
		id="cbd-hyperData"
		x-show="panelOpen"
		x-cloak
		x-transition

	>
		<!--- Info Bar --->
		<div class="cbd-floatRight mr5 mt10 mb10">
			<div>
				<strong>Total Requests:</strong>
				<div class="cbd-badge-light">
					#args.profiler.hyper.totalRequests#
				</div>
			</div>

			<div>
				<strong>Total Execution Time:</strong>
				<div class="cbd-badge-light">
					#args.profiler.hyper.totalExecutionTime# ms
				</div>
			</div>
		</div>

		<!--- ToolBar --->
		<div class="p10">
			<!--- Grouped --->
			<button
				:class="{ 'cbd-selected' : isGroupView() }"
				@click="queryView='grouped'"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
				</svg>
				Grouped
			</button>
			<!--- Timeline --->
			<button
				:class="{ 'cbd-selected' : isTimelineView() }"
				@click="queryView='timeline'"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" />
				</svg>
				Timeline
			</button>
			<!--- Slowest --->
			<button
				:class="{ 'cbd-selected' : isSlowestView() }"
				@click="queryView='slowest'"
			>
				<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
				Slowest
			</button>
		</div>

		<cfif args.profiler.hyper.totalRequests EQ 0>
			<div class="cbd-text-muted">
				<em>No hyper requests detected</em>
			</div>
		<cfelse>

			<!--- Grouped Queries --->
			<div
				x-show="isGroupView"
				x-transition
			>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<thead>
						<tr>
							<th width="5%" align="center">Count</th>
							<th>Request Information</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#args.profiler.hyper.grouped.keyArray()#" index="requestHash">
							<tr>
								<td align="center">
									<div class="cbd-badge-light">
										#args.profiler.hyper.grouped[ requestHash ].count#
									</div>
								</td>
								<td>
									<code id="hyper-grouprequest-#requestHash#" style="min-height: 65px">
										<svg
											xmlns="http://www.w3.org/2000/svg"
											class="h-6 w-6 cbd-floatRight cbd-text-pre mt5"
											fill="none"
											viewBox="0 0 24 24"
											stroke="currentColor"
											title="Copy to Clipboard"
											style="width: 50px; height: 50px; cursor: pointer;"
											onclick="coldboxDebugger.copyToClipboard( 'hyper-grouprequest-#requestHash#' )"
										>
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
										</svg>
										<pre>#args.profiler.hyper.grouped[ requestHash ].method#>#args.profiler.hyper.grouped[ requestHash ].url#</pre>
									</code>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
										<thead>
											<tr>
												<th width="100">Status</th>
												<th width="125">Timestamp</th>
												<th width="125">Execution Time</th>
												<th>Caller</th>
											</tr>
										</thead>
										<tbody>
											<cfloop array="#args.profiler.hyper.grouped[ requestHash ].records#" index="requestId">
												<cfset thisRequestRecord = args.profiler.hyper.all[ requestId ]>
												<tr>
													<td>
														<div>
															<cfif thisRequestRecord.status eq "started">
																<span class="cbd-text-red" title="Started but never finished">
																	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-exclamation-octagon" viewBox="0 0 16 16">
																		<path d="M4.54.146A.5.5 0 0 1 4.893 0h6.214a.5.5 0 0 1 .353.146l4.394 4.394a.5.5 0 0 1 .146.353v6.214a.5.5 0 0 1-.146.353l-4.394 4.394a.5.5 0 0 1-.353.146H4.893a.5.5 0 0 1-.353-.146L.146 11.46A.5.5 0 0 1 0 11.107V4.893a.5.5 0 0 1 .146-.353L4.54.146zM5.1 1 1 5.1v5.8L5.1 15h5.8l4.1-4.1V5.1L10.9 1H5.1z"/>
																		<path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
																	</svg>
																</span>
															<cfelse>
																<span class="cbd-text-green" title="completed">
																	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
																		<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
																		<path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
																	</svg>
																</span>
															</cfif>
															#thisRequestRecord.response.statusCode#
															<small>#thisRequestRecord.response.statusText#</small>
														</div>
													</td>
													<td>
														#TimeFormat( thisRequestRecord.timestamp, "hh:MM:SS.l tt" )#
													</td>
													<td>
														#numberFormat( thisRequestRecord.executionTime )# ms
													</td>
													<td>
														<div class="mb10 mt10 cbd-params">
															<!--- Open in Editor--->
															<cfif args.debuggerService.openInEditorURL( event, thisRequestRecord.caller ) NEQ "">
																<div class="cbd-floatRight">
																	<a
																		class="cbd-button"
																		target="_self"
																		rel   ="noreferrer noopener"
																		title="Open in Editor"
																		href="#args.debuggerService.openInEditorURL( event, thisRequestRecord.caller )#"
																	>
																		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
																			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
																		</svg>
																	</a>
																</div>
															</cfif>
															<!--- Line --->
															<div>
																<strong>
																	#replaceNoCase( thisRequestRecord.caller.template, appPath, "" )#:#thisRequestRecord.caller.line#
																</strong>
															</div>
														</div>
													</td>
												</tr>
											</cfloop>
										</tbody>
									</table>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>

			<!--- Timeline Requests --->
			<div
				x-show="isTimelineView"
				x-transition
			>
				#view(
					view : "main/panels/requestTracker/hyperRequestTable",
					module : "cbdebugger",
					args : {
						requestData		: args.profiler.hyper.all,
						debuggerService : args.debuggerService,
						formatter 		: formatter,
						appPath			: appPath
					},
					prePostExempt : true
				)#
			</div>
			<!--- End Timeline Requests --->

			<!--- Slowest Requests --->
			<div
				x-show="isSlowestView"
				x-transition
			>
				#view(
					view : "main/panels/requestTracker/hyperRequestTable",
					module : "cbdebugger",
					args : {
						requestData			: args.profiler.hyper.all
							.reduce( ( results, key, value ) => {
								return results.append( value );
							}, [] )
							.sort( function( a, b ){
								return a.executionTime < b.executionTime ? 1 : -1;
							} ),
						debuggerService : args.debuggerService,
						formatter 		: formatter,
						appPath			: appPath
					},
					prePostExempt : true
				)#
			</div>
			<!--- End Slowest Queries --->
		</cfif>

	</div>
</div>
</cfoutput>
