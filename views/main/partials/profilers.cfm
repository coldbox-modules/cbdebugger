<cfoutput>
<div
	id="cbd-profilers"
	x-data="{
		sortBy : '#encodeForJavaScript( rc.sortBy ?: 'timestamp' )#',
		sortOrder : '#encodeForJavaScript( rc.sortOrder ?: 'desc' )#',
		sort( by ){
			this.sortBy = by
			this.sortOrder = ( this.sortOrder === 'asc' ? 'desc' : 'asc' )
			refreshProfilers( this.sortBy, this.sortOrder )
		}
	}"
	x-cloak
	x-show="!currentProfileId"
>
	<table border="0" cellpadding="0" cellspacing="1" class="cbd-tables mt10">
		<tr class="cbdHeader">
			<th
				align="left"
				width="125"
				@click="sort( 'timestamp' )"
				class="cbd-sortable"
				title="Sort by timestamp"
			>

				<span
					class="cbd-floatRight"
					x-show="sortBy == 'timestamp'"
				>
					<!--- Desc --->
					<svg x-show="sortOrder == 'desc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4"></path></svg>
					<!--- Asc --->
					<svg x-show="sortOrder == 'asc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12"></path></svg>
				</span>

				Timestamp<br>
				Ip
			</th>

			<th align="left" width="150" @click="sort( 'inethost' )">
				<span
					class="cbd-floatRight"
					x-show="sortBy == 'inethost'"
					class="cbd-sortable"
					title="Sort by host"
				>
					<!--- Desc --->
					<svg x-show="sortOrder == 'desc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4"></path></svg>
					<!--- Asc --->
					<svg x-show="sortOrder == 'asc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12"></path></svg>
				</span>

				Server Info
			</th>

			<th align="left"
				width="75"
				@click="sort( 'statusCode' )"
				class="cbd-sortable"
				title="Sort by status code"
			>
				<span
					class="cbd-floatRight"
					x-show="sortBy == 'statusCode'"
					class="cbd-sortable"
					title="Sort by status code"
				>
					<!--- Desc --->
					<svg x-show="sortOrder == 'desc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4"></path></svg>
					<!--- Asc --->
					<svg x-show="sortOrder == 'asc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12"></path></svg>
				</span>
				Response
			</th>

			<th align="left"
				@click="sort( 'event' )"
				class="cbd-sortable"
				title="Sort by ColdBox Event"
			>
				<span
					class="cbd-floatRight"
					x-show="sortBy == 'event'"
				>
					<!--- Desc --->
					<svg x-show="sortOrder == 'desc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4"></path></svg>
					<!--- Asc --->
					<svg x-show="sortOrder == 'asc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12"></path></svg>
				</span>
				Request
			</th>

			<th width="100"
				@click="sort( 'memoryDiff' )"
				class="cbd-sortable"
				title="Sort by Free memory difference between start and end of the request"
			>
				<span
					class="cbd-floatRight"
					x-show="sortBy == 'memorydiff'"
					class="cbd-sortable"
					title="Sort by memory diff"
				>
					<!--- Desc --->
					<svg x-show="sortOrder == 'desc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4"></path></svg>
					<!--- Asc --->
					<svg x-show="sortOrder == 'asc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12"></path></svg>
				</span>
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

			<th width="65"
				@click="sort( 'executionTime' )"
				class="cbd-sortable"
				title="Sort by execution time"
			>
				<span
					class="cbd-floatRight"
					x-show="sortBy == 'executionTime'"
				>
					<!--- Desc --->
					<svg x-show="sortOrder == 'desc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4"></path></svg>
					<!--- Asc --->
					<svg x-show="sortOrder == 'asc'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12"></path></svg>
				</span>
				Time<br>
				(ms)
			</th>

			<th width="75">
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

					<!--- Open Request Profiler --->
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

					<!--- Export Profiler as JSON --->
					<a
						href="#event.buildLink( 'cbdebugger:exportProfilerReport', { id : thisProfiler.id } )#"
						target="_blank"
						class="pt5 pb5 cbd-button cbd-rounded"
						title="Export Profiler to JSON"
					><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3V10"></path></svg></a>
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
