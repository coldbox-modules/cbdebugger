<cfoutput>
<div
	id="cbd-profilers"
	x-data="{}"
	x-cloak
	x-show="!currentProfileId"
>
	<table border="0" cellpadding="0" cellspacing="1" class="cbd-tables mt10">
		<tr class="cbdHeader">
			<th align="left" width="125">
				Timestamp<br>
				Ip
			</th>

			<th align="left" width="150">
				Server Info
			</th>

			<th align="left" width="75">
				Response
			</th>

			<th align="left">
				Request
			</th>

			<th width="100" title="Free memory difference between start and end of the request">
				Memory Diff
			</th>

			<cfif args.debuggerConfig.cborm.enabled>
				<th width="65">
					cborm
					<br>
					time + %
				</th>
			</cfif>

			<cfif args.debuggerConfig.acfSql.enabled>
				<th width="65">
					ACF SQL
					<br>
					time + %
				</th>
			</cfif>

			<cfif args.debuggerConfig.qb.enabled>
				<th width="65">
					QB
					<br>
					time + %
				</th>
			</cfif>

			<th width="65">
				Time<br>
				(ms)
			</th>

			<th width="50">
				Actions
			</th>
		</tr>

		<cfloop array="#args.profilers#" index="thisProfiler">

			<tr
				@dblclick="loadProfilerReport( '#thisProfiler.id#' )"
				<cfif thisProfiler.response.statusCode gte 400>class="cbd-bg-light-red"</cfif>
			>

				<!--- TIMESTAMP + IP --->
				<td align="left">
					<div>
						#timeformat( thisProfiler.timestamp, "hh:mm:ss.l tt" )#
					</div>

					<div class="cbd-text-muted">
						<small>#dateformat( thisProfiler.timestamp, "mmm.dd.yyyy" )#</small>
					</div>

					<div class="mt5">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
						</svg>
						<a
							href="https://www.whois.com/whois/#thisProfiler.ip#"
							target="_blank"
							title="Open whois for this ip address"
						>
							#thisProfiler.ip#
						</a>
					</div>
				</td>

				<!--- Machine Info + Thread Info --->
				<td>
					<div title="Machine Host">
						#thisProfiler.inetHost#
					</div>

					<div class="mt5" title="Thread Info">
						#thisProfiler.threadInfo.replaceNoCase( "Thread", "" )#
					</div>

					<div class="mt5" title="Local IP">
						#thisProfiler.localIp#
					</div>
				</td>

				<!--- Response & Content TYPE --->
				<td align="left">
					<div>
						<cfif thisProfiler.response.statusCode gte 200 && thisProfiler.response.statusCode lt 300 >
							<span class="cbd-text-green">
								#thisProfiler.response.statusCode#
							</span>
						<cfelseif thisProfiler.response.statusCode gte 300 && thisProfiler.response.statusCode lt 400 >
							<span class="cbd-text-blue">
								#thisProfiler.response.statusCode#
							</span>
						<cfelseif thisProfiler.response.statusCode gte 400>
							<span class="cbd-text-red">
								#thisProfiler.response.statusCode#
								<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
							</span>
						</cfif>
					</div>
					<div class="mt5 cbd-text-muted">
						#thisProfiler.response.contentType.listFirst( ";" )#
					</div>
				</td>

				<!--- FULL URL + EVENT --->
				<td>
					<div>
						#thisProfiler.requestData.method#>#thisProfiler.fullUrl#
					</div>
					<div class="mt10 cbd-text-blue">
						<strong>
							Event:
						</strong>
						#thisProfiler.coldbox.event#
					</div>
				</td>

				<!--- Free Memory in MB --->
				<td align="right">
					<cfset diff = numberFormat( ( thisProfiler.endFreeMemory - thisProfiler.startFreeMemory ) / 1048576 )>
					<cfif diff gt 0>
						<span class="cbd-text-green">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
								<path fill-rule="evenodd" d="M12 7a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0V8.414l-4.293 4.293a1 1 0 01-1.414 0L8 10.414l-4.293 4.293a1 1 0 01-1.414-1.414l5-5a1 1 0 011.414 0L11 10.586 14.586 7H12z" clip-rule="evenodd" />
							</svg>
							#diff#MB
						</span>
					<cfelse>
						<span class="cbd-text-red">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
								<path fill-rule="evenodd" d="M12 13a1 1 0 100 2h5a1 1 0 001-1V9a1 1 0 10-2 0v2.586l-4.293-4.293a1 1 0 00-1.414 0L8 9.586 3.707 5.293a1 1 0 00-1.414 1.414l5 5a1 1 0 001.414 0L11 9.414 14.586 13H12z" clip-rule="evenodd" />
							</svg>
							#diff#MB
						</span>
					</cfif>
				</td>

				<!--- CBORM Time --->
				<cfif args.debuggerConfig.cborm.enabled>
					<td align="right">
						<cfset timerClass = thisProfiler.cborm.totalExecutionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold ? "cbd-text-red" : "">
						<span class="#timerClass#">
							#numberFormat( thisProfiler.cborm.totalExecutionTime )# ms
							<br>
							<span title="Percentage of total request time">
								#numberFormat( (thisProfiler.cborm.totalExecutionTime / thisProfiler.executionTime) * 100, "0.00" )#%
							</span>
						</span>
					</td>
				</cfif>

				<!--- CFSQL Time --->
				<cfif args.debuggerConfig.acfSql.enabled>
					<td align="right">
						<cfset timerClass = thisProfiler.cfQueries.totalExecutionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold ? "cbd-text-red" : "">
						<span class="#timerClass#">
							#numberFormat( thisProfiler.cfQueries.totalExecutionTime )# <br>
							<span title="Percentage of total request time">
								#numberFormat( thisProfiler.cfQueries.totalExecutionTime / thisProfiler.executionTime, "00.00" )#%
							</span>
						</span>
					</td>
				</cfif>

				<!--- QB Time --->
				<cfif args.debuggerConfig.qb.enabled>
					<td align="right">
						<cfset timerClass = thisProfiler.qbQueries.totalExecutionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold ? "cbd-text-red" : "">
						<span class="#timerClass#">
							#numberFormat( thisProfiler.qbQueries.totalExecutionTime )# <br>
							<span title="Percentage of total request time">
								#numberFormat( thisProfiler.qbQueries.totalExecutionTime / thisProfiler.executionTime, "00.00" )#%
							</span>
						</span>
					</td>
				</cfif>

				<!--- Execution Time --->
				<td align="right">
					<cfset timerClass = thisProfiler.executionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold ? "cbd-text-red" : "">
					<span class="#timerClass#">
						#numberFormat( thisProfiler.executionTime )#
					</span>
				</td>

				<!--- ACTIONS --->
				<td align="center">
					<button
						title="Show Request"
						class="pt5 pb5 cbd-rounded"
						@click="loadProfilerReport( '#thisProfiler.id#' )"
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="none"
							viewBox="0 0 24 24"
							stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 21h7a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v11m0 5l4.879-4.879m0 0a3 3 0 104.243-4.242 3 3 0 00-4.243 4.242z" />
						</svg>
					</button>
				</td>
			</tr>
		</cfloop>
	</table>

	<cfif !arrayLen( args.profilers )>
		<div class="m10 cbd-text-red">
			<em>No profilers found just yet! Go execute your app!</em>
		</div>
	</cfif>
</div>
</cfoutput>
