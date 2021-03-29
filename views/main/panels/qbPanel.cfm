<cfscript>
	isQuickInstalled = getController().getModuleService().isModuleRegistered( "quick" );
	isQBInstalled = getController().getModuleService().isModuleRegistered( "qb" );
	totalQueries = args.profiler.keyExists( "qbQueries" ) ? args.profiler.qbQueries.all.len() : 0;
	totalExecutionTime = !args.profiler.keyExists( "qbQueries" ) ? 0 : args.profiler.qbQueries.all.reduce( function( total, q ) {
		return total + q.executionTime;
	}, 0 );
	totalEntities = args.profiler.keyExists( "quick" ) ? args.profiler.quick.total : 0;
</cfscript>
<cfoutput>
	<!--- Panel Title --->
	<div class="fw_titles"  onClick="fw_toggle('fw_qbPanel')" >
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
		</svg>
		<cfif isQuickInstalled>Quick &##47; </cfif>qb (#totalQueries#)
	</div>

	<!--- Panel Content --->
	<div class="fw_debugContent<cfif args.debuggerConfig.expandedQBPanel>View</cfif>" id="fw_qbPanel">
		<div id="qbQueries">
			<cfif NOT isQBInstalled>
				qb is not installed or registered.
			<cfelse>
				<div class="fw_subtitles">&nbsp;Queries <span class="fw_badge_dark" style="margin-left: 1em;">#totalQueries#</span></div>
				<div style="padding: 1em;">
					<input type="button" style="font-size:10px" value="Grouped View" onClick="fw_showGroupedQueries()">
					<input type="button" style="font-size:10px" value="Timeline View" onClick="fw_showTimelineQueries()">
				</div>
				<cfif totalQueries EQ 0>
					No queries executed
				<cfelse>
					<div id="groupedQueries">
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
										<td align="center">#args.profiler.qbQueries.grouped[ sql ].len()#</td>
										<td>#sql#</td>
									</tr>
									<tr style="margin-right: 2em;">
										<td></td>
										<td style="width: 100%;">
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
															<td>#TimeFormat(q.timestamp,"hh:MM:SS.l tt")#</td>
															<td>#q.executionTime# ms</td>
															<td>
																<cfif NOT q.bindings.isEmpty()>
																	<cfdump var="#q.bindings#" expand="false" />
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
					<div id="timelineQueries" style="display: none;">
						<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
							<thead>
								<tr>
									<th>Timestamp</th>
									<th width="80%">Query</th>
									<th align="center">Execution Time</th>
									<th>Bindings</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#args.profiler.qbQueries.all#" index="q">
									<tr>
										<td>#TimeFormat(q.timestamp,"hh:MM:SS.l tt")#</td>
										<td>#q.sql#</td>
										<td>#q.executionTime# ms</td>
										<td><cfdump var="#q.bindings#" expand="false" /></td>
									</tr>
								</cfloop>
							</tbody>
						</table>
					</div>
					<div style="margin-top: 0.5em; margin-left: 1em;">
						<div class="fw_debugTitleCell">
							Total Execution Time:
						</div>
						<div class="fw_debugContentCell">
							#totalExecutionTime# ms
						</div>
					</div>
				</cfif>
			</cfif>
		</div>
		<cfif isQuickInstalled>
			<hr />
			<div id="quickEntities" style="margin-top: 1em;">
				<div class="fw_subtitles">&nbsp;Entities <span class="fw_badge_dark" style="margin-left: 1em;">#totalEntities#</span></div>
				<cfif totalEntities EQ 0>
					No Quick entities loaded.
				<cfelse>
					<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables" style="margin-top: 1em;">
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