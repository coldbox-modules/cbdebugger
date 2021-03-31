<cfscript>
	isQuickInstalled = getController().getModuleService().isModuleRegistered( "quick" );
	isQBInstalled = getController().getModuleService().isModuleRegistered( "qb" );
	totalQueries = args.profiler.keyExists( "qbQueries" ) ? args.profiler.qbQueries.all.len() : 0;
	totalExecutionTime = !args.profiler.keyExists( "qbQueries" ) ? 0 : args.profiler.qbQueries.all.reduce( function( total, q ) {
		return arguments.total + arguments.q.executionTime;
	}, 0 );
	totalEntities = args.profiler.keyExists( "quick" ) ? args.profiler.quick.total : 0;
</cfscript>
<cfoutput>
	<!--- Panel Title --->
	<div class="cbd-titles"  onClick="cbdToggle( 'cbdQBPanel' )" >
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
		</svg>
		<cfif isQuickInstalled>Quick &##47; </cfif>qb (#totalQueries#)
	</div>

	<!--- Panel Content --->
	<div class="fw_debugContent<cfif args.debuggerConfig.expandedQBPanel>View</cfif>" id="cbdQBPanel">
		<div id="qbQueries">

			<!--- If not installed --->
			<cfif NOT isQBInstalled>
				<em>
					qb is not installed or registered.
				</em>
			<cfelse>

				<!--- Info Bar --->
				<div class="cbd-floatRight mr5 mt10">
					<div>
						<strong>Total Execution Time:</strong>
						<div class="cbd-badge-light">
							#totalExecutionTime# ms
						</div>
					</div>
				</div>

				<!--- ToolBar --->
				<div class="p10">
					<button
						class="cbd-selected"
						id="cbdButtonGroupedQueries"
						onClick="cbdShowGroupedQueries()"
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
						</svg>
						Grouped
					</button>
					<button
						class=""
						id="cbdButtonTimelineQueries"
						onClick="cbdShowTimelineQueries()"
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" />
						</svg>
						Timeline
					</button>
				</div>

				<!--- Query Views --->
				<cfif totalQueries EQ 0>
					<div class="cbd-text-muted">
						<em>No queries executed</em>
					</div>
				<cfelse>

					<!--- Grouped Queries --->
					<div id="cbdGroupedQueries">
						<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
							<thead>
								<tr>
									<th width="5%">Count</th>
									<th>Query</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#args.profiler.qbQueries.grouped.keyArray()#" index="sql">
									<tr>
										<td align="center">
											<div class="cbd-badge-light">
												#args.profiler.qbQueries.grouped[ sql ].len()#
											</div>
										</td>
										<td>
											<code>
												#sql#
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
														<th>Bindings</th>
													</tr>
												</thead>
												<tbody>
													<cfloop array="#args.profiler.qbQueries.grouped[ sql ]#" index="q">
														<tr>
															<td align="center">
																#TimeFormat( q.timestamp, "hh:MM:SS.l tt" )#
															</td>
															<td align="center">
																#numberFormat( q.executionTime )# ms
															</td>
															<td>
																<code>
																	<cfif NOT q.bindings.isEmpty()>
																		#getInstance( '@JSONPrettyPrint' ).formatJSON(
																			json : serializeJSON( q.bindings ),
																			spaceAfterColon : true
																		)#
																	<cfelse>
																		[]
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

					<!--- Timeline Queries --->
					<div id="cbdTimelineQueries" class="cbd-hide">
						<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
							<thead>
								<tr>
									<th width="125">Timestamp</th>
									<th>Query</th>
									<th width="100" align="center">Execution Time</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#args.profiler.qbQueries.all#" index="q">
									<tr>
										<td align="center">
											#TimeFormat( q.timestamp,"hh:MM:SS.l tt" )#
										</td>
										<td>
											<code>#q.sql#</code>

											<cfif NOT q.bindings.isEmpty()>
												<div class="mt10 mb5 cbd-bindings">
													<div class="mb10">
														<strong>Bindings: </strong>
													</div>
													<code>
														#getInstance( '@JSONPrettyPrint' ).formatJSON(
															json : serializeJSON( q.bindings ),
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
			</cfif>
		</div>

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
</cfoutput>