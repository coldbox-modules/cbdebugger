<cfoutput>
	<!--- Panel Title --->
	<div class="fw_titles"  onClick="fw_toggle( 'cbdCBOrmPanel' )" >
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
		</svg>
		cborm (#args.profiler.cborm.totalCriteriaQueries# / #numberFormat( args.profiler.cborm.totalCriteriaQueryExecutionTime )# ms)
	</div>

	<!--- Panel Content --->
	<div class="fw_debugContent<cfif args.debuggerConfig.expandedQBPanel>View</cfif>" id="cbdCBOrmPanel">
		<!--- Info Bar --->
		<div class="floatRight mr5 mt10">
			<div>
				<strong>Total Execution Time:</strong>
				<div class="fw_badge_light">
					#numberFormat( args.profiler.cborm.totalListsExecutionTime )# ms
				</div>
			</div>
		</div>

		<!--- Timeline Queries --->
		<div>
			<h2>List() Queries (#arrayLen( args.profiler.cborm.lists )#)</h2>
			<cfif !arrayLen( args.profiler.cborm.lists )>
				<em class=textMuted>
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
			</cfif>

			<!--- Info Bar --->
			<div class="floatRight mr5 mt10">
				<div>
					<strong>Total Execution Time:</strong>
					<div class="fw_badge_light">
						#numberFormat( args.profiler.cborm.totalGetsExecutionTime )# ms
					</div>
				</div>
			</div>

			<h2>Get() Queries (#arrayLen( args.profiler.cborm.gets )#)</h2>
			<cfif !arrayLen( args.profiler.cborm.gets )>
				<em class=textMuted>
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
			</cfif>

			<!--- Info Bar --->
			<div class="floatRight mr5 mt10">
				<div>
					<strong>Total Execution Time:</strong>
					<div class="fw_badge_light">
						#numberFormat( args.profiler.cborm.totalCountsExecutionTime )# ms
					</div>
				</div>
			</div>

			<h2>Count() Queries (#arrayLen( args.profiler.cborm.counts )#)</h2>
			<cfif !arrayLen( args.profiler.cborm.counts )>
				<em class=textMuted>
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
			</cfif>
		</div>

		<!--- Hibernate Session Stats --->
		<div class="mt10">
			<h2>Hibernate Session Stats:</h2>

			<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
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