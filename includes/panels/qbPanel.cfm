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
<cfoutput>
	<div class="fw_titles"  onClick="fw_toggle('fw_qbPanel')" >
		&nbsp;qb
	</div>
	<div class="fw_debugContent<cfif instance.debuggerConfig.expandedQBPanel>View</cfif>" id="fw_qbPanel">
		<cfif NOT getController().getModuleService().isModuleRegistered( "qb" )>
			qb is not installed or registered.
		<cfelse>
			<cfif NOT request.cbdebugger.keyExists( "qbQueries" ) OR request.cbdebugger.qbQueries.isEmpty()>
				No queries executed
			<cfelse>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
					<thead>
						<tr>
							<th width="5%">Count</th>
							<th>Query</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#request.cbdebugger.qbQueries.keyArray()#" index="sql">
							<tr>
								<td align="center">#request.cbdebugger.qbQueries[ sql ].len()#</td>
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
											<cfloop array="#request.cbdebugger.qbQueries[ sql ]#" index="q">
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
				<!--- <table border="0" align="center" cellpadding="0" cellspacing="1" class="fw_debugTables">
					<thead>
						<tr>
							<th>Timestamp</th>
							<th width="80%">Query</th>
							<th align="center">Execution Time</th>
							<th>Bindings</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#request.cbdebugger.qbQueries#" index="q">
							<tr <cfif debugTimers.currentrow mod 2 eq 0>class="even"</cfif>>
								<td>#TimeFormat(q.timestamp,"hh:MM:SS.l tt")#</td>
								<td>#q.sql#</td>
								<td>#q.executionTime# ms</td>
								<td><cfdump var="#q.bindings#" expand="false" /></td>
							</tr>
						</cfloop>
					</tbody>
				</table> --->
			</cfif>
		</cfif>
	</div>
</cfoutput>
<cfsetting enablecfoutputonly="false">
