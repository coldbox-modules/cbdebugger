<cfoutput>
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
		<th width="50">
			Time<br>
			(ms)
		</th>
		<th width="50">
			Actions
		</th>
	</tr>

	<cfloop array="#args.profilers#" index="thisProfiler">
		<tr <cfif thisProfiler.response.statusCode gte 400>class="cbd-bg-light-red"</cfif>>

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

				<div class="mt5">
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
					#thisProfiler.requestData.method#:#thisProfiler.fullUrl#
				</div>
				<div class="mt10 cbd-text-blue">
					<strong>
						Event:
					</strong>
					#thisProfiler.coldbox.event#
				</div>
			</td>

			<!--- Execution Time --->
			<td align="right">
				<cfif thisProfiler.executionTime gt args.debuggerConfig.requestTracker.slowExecutionThreshold>
					<span class="cbd-text-red">
						#numberFormat( thisProfiler.executionTime )#
					</span>
				<cfelse>
					#numberFormat( thisProfiler.executionTime )#
				</cfif>
			</td>

			<!--- ACTIONS --->
			<td align="center">
				<button
					title="Show Request"
					class="pt5 pb5 cbd-rounded"
					id="cbd-buttonGetProfilerReport-#thisProfiler.id#"
					onClick="cbdGetProfilerReport( '#thisProfiler.id#', true )"
				>
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
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

</cfoutput>