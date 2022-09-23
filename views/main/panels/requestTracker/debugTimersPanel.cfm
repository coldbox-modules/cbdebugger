<cfoutput>
<div
	id="cbd-debug-timers"
	x-data="{
		panelOpen : #args.debuggerConfig.requestTracker.executionTimers.expanded ? 'true' : 'false'#
	}"
>
	<!--- Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>

		Execution Timers
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
		</svg>

		<!--- Count --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
		</svg>
		#structCount( args.timers )#
	</div>

	<div
		class="cbd-contentView"
		id="cbd-debugTimersData"
		x-transition
		x-cloak
		x-show="panelOpen"
	>
		<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
			<tr>
				<th width="125" align="center" >Started</th>
				<th width="125" align="center" >Finished</th>
				<th width="125" align="center" >Execution Time</th>
				<th align="left">Label</th>
				<th width="100">Actions</th>
			</tr>

			<!--- Show Timers if any are found --->
			<cfif structCount( args.timers )>
				<cfloop collection="#args.timers#" item="timerKey">
					<cfset thisTimer = args.timers[ timerKey ]>

					<cfif findnocase( "[render", thisTimer.method )>
						<cfset color = "cbd-text-orange">
					<cfelseif findnocase( "[Interception]", thisTimer.method )>
						<cfset color = "cbd-text-black">
					<cfelseif findnocase( "[runEvent]",  thisTimer.method )>
						<cfset color = "cbd-text-blue">
					<cfelseif findnocase( "[pre", thisTimer.method ) or findnocase( "post", thisTimer.method )>
						<cfset color = "cbd-text-purple">
					<cfelse>
						<cfset color = "cbd-text-green">
					</cfif>

					<tr>
						<!--- Started --->
						<td align="center" >
							#timeFormat( thisTimer.startedAt, "hh:MM:SS.l tt" )#
						</td>

						<!--- Stopped --->
						<td align="center" >
							#timeFormat( thisTimer.stoppedAt, "hh:MM:SS.l tt" )#
						</td>

						<!--- Execution Time --->
						<td align="center" >
							<cfif thisTimer.executionTime gt args.debuggerConfig.requestTracker.executionTimers.slowTimerThreshold>
								<span class="cbd-text-red">
									#numberFormat( thisTimer.executionTime )#ms
								</span>
							<cfelse>
								#numberFormat( thisTimer.executionTime )#ms
							</cfif>
						</td>

						<!--- Label --->
						<td>
							<span class="#color#">#thisTimer.method#</span>
						</td>

						<!--- Open --->
						<td align="center" >
							<!--- View Render --->
							<cfparam name="thisTimer.metadata" default="#structNew()#">
							<cfparam name="thisTimer.metadata.path" default="">
							<cfif isSimpleValue( thisTimer.metadata.path ) && len( thisTimer.metadata.path )>
								<a
									href="#args.debuggerService.openInEditorURL( event, {
										template : thisTimer.metadata.path,
										line : thisTimer.metadata.line
									} )#"
									title="Open in Editor"
									class="cbd-button"
									target="_self"
									rel="noreferrer noopener"
								>
									<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
									</svg>
								</a>
							</cfif>
						</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr>
					<td colspan="4">No Timers Found...</td>
				</tr>
			</cfif>
		</table>
	</div>
</div>
</cfoutput>
