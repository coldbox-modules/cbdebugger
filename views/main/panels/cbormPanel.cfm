<cfset sqlFormatter = getInstance( "SqlFormatter@cbdebugger" )>
<cfset jsonFormatter = getInstance( '@JSONPrettyPrint' )>
<cfoutput>
	<!--- Panel Title --->
	<div class="cbd-titles"  onClick="cbdToggle( 'cbdCBOrmPanel' )" >
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
		class="cbd-contentView<cfif args.debuggerConfig.cborm.expanded> cbd-show<cfelse> cbd-hide</cfif>"
		id="cbdCBOrmPanel"
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
			<button
				class="cbd-selected"
				id="cbdButtonGroupedOrmQueries"
				onClick="cbdShowGroupedOrmQueries()"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
				</svg>
				Grouped
			</button>
			<button
				class=""
				id="cbdButtonTimelineOrmQueries"
				onClick="cbdShowTimelineOrmQueries()"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" />
				</svg>
				Timeline
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
			<div id="cbdGroupedOrmQueries">
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
									<code>
										#sqlFormatter.formatSql(
											args.profiler.cborm.grouped[ sqlHash ].sql
										)#
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
												<th width="15%">Timestamp</th>
												<th width="10%">Execution Time</th>
												<th width="10%">Type</th>
												<th>Bindings</th>
											</tr>
										</thead>
										<tbody>
											<cfloop array="#args.profiler.cborm.grouped[ sqlHash ].records#" index="q">
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
														<code>
															<cfif NOT q.params.isEmpty()>
																#jsonFormatter.formatJSON(
																	json : q.params,
																	spaceAfterColon : true
																)#
															<cfelse>
																<em>[]</em>
															</cfif>
														</code>
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
			<div id="cbdTimelineOrmQueries" class="cbd-hide">
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<thead>
						<tr>
							<th width="125">Timestamp</th>
							<th width="100">Type</th>
							<th>Query</th>
							<th width="100" align="center">Execution Time</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#args.profiler.cborm.all#" index="q">
							<tr>
								<td align="center">
									#TimeFormat( q.timestamp,"hh:MM:SS.l tt" )#
								</td>
								<td align="center">
									#q.type#
								</td>
								<td>
									<code>#sqlFormatter.formatSql( q.sql )#</code>

									<cfif NOT q.params.isEmpty()>
										<div class="mt10 mb5 cbd-bindings">
											<div class="mb10">
												<strong>Params: </strong>
											</div>
											<code>
												#jsonFormatter.formatJSON(
													json : q.params,
													spaceAfterColon : true
												)#
											</code>
										</div>
									</cfif>
								</td>
								<td align="center">
									#q.executionTime# ms
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>

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
				<cfloop array="#args.profiler.cborm.sessionStats.keyArray().sort( "textnocase" )#" item="thisItem" >
					<tr>
						<th width="200" align="right">
							#thisItem# :
						</th>
						<td>
							#args.profiler.cborm.sessionStats[ thisItem ]#
						</td>
					</tr>
				</cfloop>
			</table>
		</div>
	</div>
</cfoutput>