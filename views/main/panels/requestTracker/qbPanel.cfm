<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
	sqlFormatter = args.debuggerService.getSqlFormatter();
	jsonFormatter = args.debuggerService.getjsonFormatter();
	isQuickInstalled = controller.getModuleService().isModuleRegistered( "quick" );
	isQBInstalled = controller.getModuleService().isModuleRegistered( "qb" );
	totalEntities = args.profiler.keyExists( "quick" ) ? args.profiler.quick.total : 0;
	appPath = getSetting( "ApplicationPath" );
</cfscript>
<cfoutput>
<div
	id="cbd-qb-panel"
	x-data="{
		panelOpen : #args.debuggerConfig.qb.expanded ? 'true' : 'false'#,
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
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
		</svg>
		<cfif isQuickInstalled>Quick &##47; </cfif>qb

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
		</svg>

		<!--- Count --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
		</svg>
		#args.profiler.qbQueries.totalQueries#

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>
		#numberFormat( args.profiler.qbQueries.totalExecutionTime )# ms
	</div>

	<!--- Panel Content --->
	<div
		class="cbd-contentView p20"
		id="cbd-qbData"
		x-show="panelOpen"
		x-cloak
		x-transition

	>

		<!--- If not installed --->
		<cfif NOT isQBInstalled>
			<em>
				qb is not installed or registered.
			</em>
		<cfelse>
			<!--- Info Bar --->
			<div class="cbd-floatRight mr5 mt10 mb10">
				<div>
					<strong>Total Queries:</strong>
					<div class="cbd-badge-light">
						#args.profiler.qbQueries.totalQueries#
					</div>
				</div>

				<div>
					<strong>Total Execution Time:</strong>
					<div class="cbd-badge-light">
						#args.profiler.qbQueries.totalExecutionTime# ms
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

			<!--- Query Views --->
			<cfif args.profiler.qbQueries.totalQueries EQ 0>
				<div class="cbd-text-muted">
					<em>No queries executed</em>
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
								<th width="5%">Count</th>
								<th>Query</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#args.profiler.qbQueries.grouped.keyArray()#" index="sqlHash">
								<tr>
									<td align="center">
										<div class="cbd-badge-light">
											#args.profiler.qbQueries.grouped[ sqlHash ].count#
										</div>
									</td>
									<td>
										<code id="qb-groupsql-#sqlHash#">
											<svg
												xmlns="http://www.w3.org/2000/svg"
												class="h-6 w-6 cbd-floatRight cbd-text-pre mt5"
												fill="none"
												viewBox="0 0 24 24"
												stroke="currentColor"
												title="Copy SQL to Clipboard"
												style="width: 50px; height: 50px; cursor: pointer;"
												onclick="coldboxDebugger.copyToClipboard( 'qb-groupsql-#sqlHash#' )"
											>
												<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
											</svg>
											<pre>#sqlFormatter.format(
												args.profiler.qbQueries.grouped[ sqlHash ].sql
											)#</pre>
										</code>
									</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
											<thead>
												<tr>
													<th width="15%">Timestamp</th>
													<th width="15%">Execution Time</th>
													<th>Params</th>
												</tr>
											</thead>
											<tbody>
												<cfloop array="#args.profiler.qbQueries.grouped[ sqlHash ].records#" index="q">
													<cfset q.id = createUUID()>
													<tr>
														<td align="center">
															#TimeFormat( q.timestamp, "hh:MM:SS.l tt" )#
														</td>
														<td align="center">
															#numberFormat( q.executionTime )# ms
														</td>
														<td>
															<cfif q.caller.template.len()>
																<div class="mb10 mt10 cbd-params">
																	<!--- Title --->
																	<strong>Called From: </strong>
																	<!--- Open in Editor--->
																	<cfif args.debuggerService.openInEditorURL( event, q.caller ) NEQ "">
																		<div class="cbd-floatRight">
																			<a
																				class="cbd-button"
																				target="_self"
																				rel   ="noreferrer noopener"
																				title="Open in Editor"
																				href="#args.debuggerService.openInEditorURL( event, q.caller )#"
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
																			#replaceNoCase( q.caller.template, appPath, "" )#:#q.caller.line#
																		</strong>
																	</div>
																</div>
															</cfif>

															<cfif NOT q.params.isEmpty()>
																<code id="qb-groupsql-params-#q.id#">
																	<svg
																		xmlns="http://www.w3.org/2000/svg"
																		class="h-6 w-6 cbd-floatRight cbd-text-pre mt5"
																		fill="none"
																		viewBox="0 0 24 24"
																		stroke="currentColor"
																		title="Copy Params to Clipboard"
																		style="width: 50px; height: 50px; cursor: pointer;"
																		onclick="coldboxDebugger.copyToClipboard( 'qb-groupsql-params-#q.id#' )"
																	>
																		<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
																	</svg>
																	<pre>#jsonFormatter.formatJSON( json : q.params, spaceAfterColon : true )#</pre>
																</code>
															</cfif>
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

				<!--- Timeline Queries --->
				<div
					x-show="isTimelineView"
					x-transition
				>
					#view(
						view : "main/panels/requestTracker/qbSqlTable",
						module : "cbdebugger",
						args : {
							sqlData			: args.profiler.qbQueries.all,
							debuggerService : args.debuggerService,
							sqlFormatter 	: sqlFormatter,
							jsonFormatter 	: jsonFormatter,
							appPath			: appPath
						},
						prePostExempt : true
					)#
				</div>
				<!--- End Timeline Queries --->

				<!--- Slowest Queries--->
				<div
					x-show="isSlowestView"
					x-transition
				>
					#view(
						view : "main/panels/requestTracker/qbSqlTable",
						module : "cbdebugger",
						args : {
							sqlData			: args.profiler.qbQueries.all.sort( function( a, b ){
								return a.executionTime < b.executionTime ? 1 : -1;
							} ),
							debuggerService : args.debuggerService,
							sqlFormatter 	: sqlFormatter,
							jsonFormatter 	: jsonFormatter,
							appPath			: appPath
						},
						prePostExempt : true
					)#
				</div>
				<!--- End Slowest Queries --->
			</cfif>
		</cfif>

		<!--- Quick info --->
		<cfif isQuickInstalled>

			<hr class="mt10 mb10" />

			<div id="quickEntities" class="mt10">
				<div class="cbd-subtitles">&nbsp;Entities
					<span class="cbd-badge-dark ml5">#totalEntities#</span>
				</div>
				<cfif totalEntities EQ 0>
					<em class="cbd-text-muted">
						No Quick entities loaded.
					</em>
				<cfelse>
					<table
						border="0"
						align="center"
						cellpadding="0"
						cellspacing="1"
						class="cbd-tables mt5">
						<thead>
							<tr>
								<th width="5%">Count</th>
								<th>Mapping</th>
							</tr>
						</thead>
						<tbody>
							<cfloop collection="#args.profiler.quick.byMapping#" item="mapping">
								<tr>
									<td align="center">#args.profiler.quick.byMapping[ mapping ]#</td>
									<td>#mapping#</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</cfif>
			</div>
		</cfif>
	</div>
</div>
</cfoutput>
