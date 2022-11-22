<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
	sqlFormatter = args.debuggerService.getSqlFormatter();
	jsonFormatter = args.debuggerService.getjsonFormatter();
	appPath = getSetting( "ApplicationPath" );
</cfscript>
<cfoutput>
<div
	id="cbd-cborm-panel"
	x-data="{
		panelOpen : #args.debuggerConfig.cborm.expanded ? 'true' : 'false'#,
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
		cborm

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
		</svg>

		<!--- Count --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
		</svg>
		#args.profiler.cborm.totalQueries#
		<!--- Execution Time --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>
		#numberFormat( args.profiler.cborm.totalExecutionTime )# ms
	</div>

	<!--- Panel Content --->
	<div
		class="cbd-contentView"
		id="cbd-cbormData"
		x-transition
		x-cloak
		x-show="panelOpen"
	>

		<!--- Info Bar --->
		<div class="cbd-floatRight mr5 mt10 mb10">
			<div>
				<strong>Total Queries:</strong>
				<div class="cbd-badge-light">
					#args.profiler.cborm.totalQueries#
				</div>
			</div>

			<div>
				<strong>Total Execution Time:</strong>
				<div class="cbd-badge-light">
					#args.profiler.cborm.totalExecutionTime# ms
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

		<!--- If no queries show message --->
		<cfif args.profiler.cborm.totalQueries EQ 0>
			<div class="cbd-text-muted">
				<em>No queries executed</em>
			</div>

		<!--- Show Queries --->
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
						<cfloop array="#args.profiler.cborm.grouped.keyArray()#" index="sqlHash">
							<!--- Show count + actual sql --->
							<tr>
								<td align="center">
									<div class="cbd-badge-light">
										#args.profiler.cborm.grouped[ sqlHash ].count#
									</div>
								</td>
								<td>
									<code id="cborm-groupsql-#sqlHash#">
										<svg
											xmlns="http://www.w3.org/2000/svg"
											class="h-6 w-6 cbd-floatRight cbd-text-pre mt5"
											fill="none"
											viewBox="0 0 24 24"
											stroke="currentColor"
											title="Copy SQL to Clipboard"
											style="width: 50px; height: 50px; cursor: pointer;"
											onclick="coldboxDebugger.copyToClipboard( 'cborm-groupsql-#sqlHash#' )"
										>
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
										</svg>
										<pre>#ltrim(
											sqlFormatter.format( args.profiler.cborm.grouped[ sqlHash ].sql )
											)#</pre>
									</code>
								</td>
							</tr>
							<!--- Show sql records --->
							<tr>
								<td></td>
								<td>
									<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
										<thead>
											<tr>
												<th width="15%" align="center">Timestamp</th>
												<th width="10%" align="center">Execution Time</th>
												<th width="10%" align="center">Type</th>
												<th>Caller + Params</th>
											</tr>
										</thead>
										<tbody>
											<cfloop array="#args.profiler.cborm.grouped[ sqlHash ].records#" index="q">
												<cfset q.id = createUUID()>
												<tr>
													<td align="center">
														#TimeFormat( q.timestamp, "hh:MM:SS.l tt" )#
													</td>
													<td align="center">
														#numberFormat( q.executionTime )# ms
													</td>
													<td align="center">
														#q.type#
													</td>
													<td>

														<!--- Show Template Caller if not empty --->
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

														<!--- Params --->
														<cfif NOT q.params.isEmpty()>
															<code id="cborm-groupsql-params-#q.id#">
																<svg
																	xmlns="http://www.w3.org/2000/svg"
																	class="h-6 w-6 cbd-floatRight cbd-text-pre mt5"
																	fill="none"
																	viewBox="0 0 24 24"
																	stroke="currentColor"
																	title="Copy Params to Clipboard"
																	style="width: 50px; height: 50px; cursor: pointer;"
																	onclick="coldboxDebugger.copyToClipboard( 'cborm-groupsql-params-#q.id#' )"
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
			<!--- End Grouped Queries --->

			<!--- Timeline Queries --->
			<div
				x-show="isTimelineView"
				x-transition
			>
				#view(
					view : "main/panels/requestTracker/cbormSqlTable",
					module : "cbdebugger",
					args : {
						sqlData			: args.profiler.cborm.all,
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
					view : "main/panels/requestTracker/cbormSqlTable",
					module : "cbdebugger",
					args : {
						sqlData			: args.profiler.cborm.all.sort( function( a, b ){
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
		<!--- End Show Queries --->

		<!--- Divider --->
		<hr class="mt20 mb20 cbd-clear cbd-dotted">

		<!--- *************************************************************************** --->
		<!--- HIBERNATE SESSION END STATS --->
		<!--- *************************************************************************** --->

		<!--- Hibernate Session Stats --->
		<div class="mt10">
			<h2>Hibernate Session Stats:</h2>
			<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
				<tr>
					<th width="200" align="right">
						Total Queries Executed:
					</th>
					<td>
						#args.profiler.cborm.totalQueries#
					</td>
				</tr>
				<tr>
					<th width="200" align="right">
						Total Execution Time:
					</th>
					<td>
						#args.profiler.cborm.totalExecutionTime#
					</td>
				</tr>
				<tr>
					<th width="200" align="right">
						Collection Count:
					</th>
					<td>
						#args.profiler.cborm.sessionStats.collectionCount#
					</td>
				</tr>
				<tr>
					<th width="200" align="right">
						Entity Count:
					</th>
					<td>
						#args.profiler.cborm.sessionStats.entityCount#
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</cfoutput>
