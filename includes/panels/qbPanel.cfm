<cfsetting enablecfoutputonly="true">
<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Template :  debug.cfm
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Debugging template for the application
----------------------------------------------------------------------->
<cfscript>
	var isQuickInstalled = getController().getModuleService().isModuleRegistered( "quick" );
	var isQBInstalled = getController().getModuleService().isModuleRegistered( "qb" );
	var totalQueries = request.cbdebugger.keyExists( "qbQueries" ) ? request.cbdebugger.qbQueries.all.len() : 0;
	var totalEntities = request.cbdebugger.keyExists( "quick" ) ? request.cbdebugger.quick.total : 0;
</cfscript>
<cfoutput>
	<div class="fw_titles"  onClick="fw_toggle('fw_qbPanel')" >
		&nbsp;<cfif isQuickInstalled>Quick &##47; </cfif>qb
	</div>
	<div class="fw_debugContent<cfif instance.debuggerConfig.expandedQBPanel>View</cfif>" id="fw_qbPanel">
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
														<th>Timestamp</th>
														<th>Execution Time</th>
														<th>Bindings</th>
													</tr>
												</thead>
												<tbody>
													<cfloop array="#request.cbdebugger.qbQueries.grouped[ sql ]#" index="q">
														<tr>
															<td>#TimeFormat(q.timestamp,"hh:MM:SS.l tt")#</td>
															<td>#q.executionTime# ms</td>
															<td><cfdump var="#q.bindings#" expand="false" /></td>
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
									<tr <cfif debugTimers.currentrow mod 2 eq 0>class="even"</cfif>>
										<td>#TimeFormat(q.timestamp,"hh:MM:SS.l tt")#</td>
										<td>#q.sql#</td>
										<td>#q.executionTime# ms</td>
										<td><cfdump var="#q.bindings#" expand="false" /></td>
									</tr>
								</cfloop>
							</tbody>
						</table>
					</div>
				</cfif>
			</cfif>
		</div>
		<cfif isQuickInstalled>
			<div id="quickEntities" style="margin-top: 1em;">
				<div class="fw_subtitles">&nbsp;Entities <span class="fw_badge_dark" style="margin-left: 1em;">#totalEntities#</span></div>
				<cfif totalEntities EQ 0>
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
								<tr <cfif debugTimers.currentrow mod 2 eq 0>class="even"</cfif>>
									<td>#request.cbdebugger.quick.byMapping[ mapping ]#</td>
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
<cfsetting enablecfoutputonly="false">
