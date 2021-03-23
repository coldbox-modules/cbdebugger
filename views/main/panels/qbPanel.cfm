<cfscript>
	local.isQuickInstalled = event.getController().getModuleService().isModuleRegistered( "quick" );
	local.isQBInstalled = event.getController().getModuleService().isModuleRegistered( "qb" );
	local.totalQueries = request.cbdebugger.keyExists( "qbQueries" ) ? request.cbdebugger.qbQueries.all.len() : 0;
	local.totalExecutionTime = !request.cbdebugger.keyExists( "qbQueries" ) ? 0 : request.cbdebugger.qbQueries.all.reduce( function( total, q ) {
		return total + q.executionTime;
	}, 0 );
	local.totalEntities = request.cbdebugger.keyExists( "quick" ) ? request.cbdebugger.quick.total : 0;
</cfscript>
<cfoutput>
	<div class="fw_titles"  onClick="fw_toggle('fw_qbPanel')" >
		&nbsp;<cfif local.isQuickInstalled>Quick &##47; </cfif>qb
	</div>
	<div class="fw_debugContent<cfif args.debuggerConfig.expandedQBPanel>View</cfif>" id="fw_qbPanel">
		<div id="qbQueries">
			<cfif NOT local.isQBInstalled>
				qb is not installed or registered.
			<cfelse>
				<div class="fw_subtitles">&nbsp;Queries <span class="fw_badge_dark" style="margin-left: 1em;">#local.totalQueries#</span></div>
				<div style="padding: 1em;">
					<input type="button" style="font-size:10px" value="Grouped View" onClick="fw_showGroupedQueries()">
					<input type="button" style="font-size:10px" value="Timeline View" onClick="fw_showTimelineQueries()">
				</div>
				<cfif local.totalQueries EQ 0>
					No queries executed
				<cfelse>
					<div id="groupedQueries">
						<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
							<thead>
								<tr>
									<th width="5%">Count</th>
									<th>Query</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#request.cbdebugger.qbQueries.grouped.keyArray()#" index="sql">
									<tr>
										<td align="center">#request.cbdebugger.qbQueries.grouped[ sql ].len()#</td>
										<td>#sql#</td>
									</tr>
									<tr style="margin-right: 2em;">
										<td></td>
										<td style="width: 100%;">
											<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
												<thead>
													<tr>
														<th width="15%">Timestamp</th>
														<th width="15%">Execution Time</th>
														<th>Bindings</th>
													</tr>
												</thead>
												<tbody>
													<cfloop array="#request.cbdebugger.qbQueries.grouped[ sql ]#" index="q">
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
						<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
							<thead>
								<tr>
									<th>Timestamp</th>
									<th width="80%">Query</th>
									<th align="center">Execution Time</th>
									<th>Bindings</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#request.cbdebugger.qbQueries.all#" index="q">
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
							#local.totalExecutionTime# ms
						</div>
					</div>
				</cfif>
			</cfif>
		</div>
		<cfif local.isQuickInstalled>
			<hr />
			<div id="quickEntities" style="margin-top: 1em;">
				<div class="fw_subtitles">&nbsp;Entities <span class="fw_badge_dark" style="margin-left: 1em;">#local.totalEntities#</span></div>
				<cfif local.totalEntities EQ 0>
					No Quick entities loaded.
				<cfelse>
					<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables" style="margin-top: 1em;">
						<thead>
							<tr>
								<th width="5%">Count</th>
								<th>Mapping</th>
							</tr>
						</thead>
						<tbody>
							<cfloop collection="#request.cbdebugger.quick.byMapping#" item="mapping">
								<tr>
									<td align="center">#request.cbdebugger.quick.byMapping[ mapping ]#</td>
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