<cfoutput>
	<!--- Panel Title --->
	<div class="cbd-titles"  onClick="cbdToggle( 'cbdCBOrmPanel' )" >
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
		</svg>
		cborm (#args.profiler.cborm.totalCriteriaQueries# / #numberFormat( args.profiler.cborm.totalCriteriaQueryExecutionTime )# ms)
	</div>

	<!--- Panel Content --->
	<div class="fw_debugContent<cfif args.debuggerConfig.expandedQBPanel>View</cfif>" id="cbdCBOrmPanel">

		<div>

			<!--- *************************************************************************** --->
			<!--- EXECUTE QUERY TIMERS --->
			<!--- *************************************************************************** --->

			<!--- ExecuteQuery Queries --->
			<h2>
				ExecuteQuery()
				<span class="cbd-badge-dark">
					#arrayLen( args.profiler.cborm.executeQuery )#
				</span>
			</h2>
			<cfif !arrayLen( args.profiler.cborm.executeQuery )>
				<em class=cbd-text-muted>
					No executeQuery() operations made
				</em>
			<cfelse>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<thead>
						<tr>
							<th width="125">Timestamp</th>
							<th>Query</th>
							<th width="100" align="center">Execution Time</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#args.profiler.cborm.executeQuery#" index="q">
							<tr>
								<td align="center">
									#TimeFormat( q.timestamp,"hh:MM:SS.l tt" )#
								</td>
								<td>
									<!--- SQL --->
									<code><pre>#q.sql#</pre></code>
									<!--- Params --->
									<cfif NOT q.params.isEmpty()>
										<div class="mt10 mb5 cbd-bindings">
											<div class="mb10">
												<strong>params: </strong>
											</div>
											<code>
												#getInstance( '@JSONPrettyPrint' ).formatJSON(
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
				<!--- Total Execution Time --->
				<div class="cbd-floatRight mr5 mt5 mb10">
					<div>
						<strong>Total Execution Time:</strong>
						<div class="cbd-badge-light">
							#numberFormat( args.profiler.cborm.totalExecuteQueryExecutionTime )# ms
						</div>
					</div>
				</div>
			</cfif>

			<hr class="mt20 mb20 cbd-clear cbd-dotted">

			<!--- *************************************************************************** --->
			<!--- LIST TIMERS --->
			<!--- *************************************************************************** --->

			<!--- List --->
			<h2>
				List()
				<span class="cbd-badge-dark">
					#arrayLen( args.profiler.cborm.lists )#
				</span>
			</h2>
			<cfif !arrayLen( args.profiler.cborm.lists )>
				<em class=cbd-text-muted>
					No list() operations made
				</em>
			<cfelse>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<thead>
						<tr>
							<th width="125">Timestamp</th>
							<th>Query</th>
							<th width="100" align="center">Execution Time</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#args.profiler.cborm.lists#" index="q">
							<tr>
								<td align="center">
									#TimeFormat( q.timestamp,"hh:MM:SS.l tt" )#
								</td>
								<td>
									<code>#q.sql#</code>
								</td>
								<td align="center">
									#q.executionTime# ms
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>

				<!--- List Total Execution Time --->
				<div class="cbd-floatRight mr5 mt5 mb10">
					<div>
						<strong>Total Execution Time:</strong>
						<div class="cbd-badge-light">
							#numberFormat( args.profiler.cborm.totalListsExecutionTime )# ms
						</div>
					</div>
				</div>
			</cfif>

			<hr class="mt20 mb20 cbd-clear cbd-dotted">

			<!--- *************************************************************************** --->
			<!--- GET TIMERS --->
			<!--- *************************************************************************** --->

			<h2>
				Get()
				<span class="cbd-badge-dark">
					#arrayLen( args.profiler.cborm.gets )#
				</span>
			</h2>
			<cfif !arrayLen( args.profiler.cborm.gets )>
				<em class=cbd-text-muted>
					No get() operations made
				</em>
			<cfelse>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<thead>
						<tr>
							<th width="125">Timestamp</th>
							<th>Query</th>
							<th width="100" align="center">Execution Time</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#args.profiler.cborm.gets#" index="q">
							<tr>
								<td align="center">
									#TimeFormat( q.timestamp,"hh:MM:SS.l tt" )#
								</td>
								<td>
									<code>#q.sql#</code>
								</td>
								<td align="center">
									#q.executionTime# ms
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>

				<!--- Get Execution Time --->
				<div class="cbd-floatRight mr5 mt5 mb10">
					<div>
						<strong>Total Execution Time:</strong>
						<div class="cbd-badge-light">
							#numberFormat( args.profiler.cborm.totalGetsExecutionTime )# ms
						</div>
					</div>
				</div>
			</cfif>

			<hr class="mt20 mb20 cbd-clear cbd-dotted">

			<!--- *************************************************************************** --->
			<!--- COUNT TIMERS --->
			<!--- *************************************************************************** --->

			<!--- Count Tables --->
			<h2>
				Count()
				<span class="cbd-badge-dark">
					#arrayLen( args.profiler.cborm.counts )#
				</span>
			</h2>
			<cfif !arrayLen( args.profiler.cborm.counts )>
				<em class=cbd-text-muted>
					No count() operations made
				</em>
			<cfelse>
				<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
					<thead>
						<tr>
							<th width="125">Timestamp</th>
							<th>Query</th>
							<th width="100" align="center">Execution Time</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#args.profiler.cborm.counts#" index="q">
							<tr>
								<td align="center">
									#TimeFormat( q.timestamp,"hh:MM:SS.l tt" )#
								</td>
								<td>
									<code>#q.sql#</code>
								</td>
								<td align="center">
									#q.executionTime# ms
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>

				<!--- Info Bar --->
				<div class="cbd-floatRight mr5 mt5 mb10">
					<div>
						<strong>Total Execution Time:</strong>
						<div class="cbd-badge-light">
							#numberFormat( args.profiler.cborm.totalCountsExecutionTime )# ms
						</div>
					</div>
				</div>
			</cfif>
		</div>

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
						#args.profiler.cborm.totalCriteriaQueries#
					</td>
				</tr>
				<tr>
					<th width="200" align="right">
						Total Query Execution Time:
					</th>
					<td>
						#numberFormat( args.profiler.cborm.totalCriteriaQueryExecutionTime )# ms
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