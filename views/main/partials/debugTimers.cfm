<cfoutput>
<!--- Title --->
<div class="fw_titles" onClick="fw_toggle( 'cbd-executionTimers' )">
	&nbsp;
	<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
		<path fill-rule="evenodd" d="M5.05 3.636a1 1 0 010 1.414 7 7 0 000 9.9 1 1 0 11-1.414 1.414 9 9 0 010-12.728 1 1 0 011.414 0zm9.9 0a1 1 0 011.414 0 9 9 0 010 12.728 1 1 0 11-1.414-1.414 7 7 0 000-9.9 1 1 0 010-1.414zM7.879 6.464a1 1 0 010 1.414 3 3 0 000 4.243 1 1 0 11-1.415 1.414 5 5 0 010-7.07 1 1 0 011.415 0zm4.242 0a1 1 0 011.415 0 5 5 0 010 7.072 1 1 0 01-1.415-1.415 3 3 0 000-4.242 1 1 0 010-1.415zM10 9a1 1 0 011 1v.01a1 1 0 11-2 0V10a1 1 0 011-1z" clip-rule="evenodd" />
	</svg>
	Execution Timers
</div>

<div class="fw_debugContent" id="cbd-executionTimers">
	<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
		<tr>
		<th width="125" align="center" >Started At</th>
		<th width="125" align="center" >Finished At</th>
		<th width="125" align="center" >Execution Time</th>
		<th >Framework Method</th>
		</tr>
		<!--- Show Timers if any are found --->
		<cfif arrayLen( args.timers )>
			<cfloop array="#args.timers#" index="thisTimer">
				<cfif findnocase( "render", thisTimer.method )>
					<cfset color = "fw_greenText">
				<cfelseif findnocase( "interception", thisTimer.method )>
					<cfset color = "fw_blackText">
				<cfelseif findnocase( "runEvent",  thisTimer.method )>
					<cfset color = "fw_blueText">
				<cfelseif findnocase( "pre", thisTimer.method ) or findnocase( "post", thisTimer.method )>
					<cfset color = "fw_purpleText">
				<cfelse>
					<cfset color = "fw_greenText">
				</cfif>
				<tr style="border-bottom:1px solid ##eaeaea">
				<td align="center" >
					#timeFormat( thisTimer.startedAt, "hh:MM:SS.l tt" )#
				</td>
				<td align="center" >
					#timeFormat( thisTimer.stoppedAt, "hh:MM:SS.l tt" )#
				</td>
				<td align="center" >
					<cfif thisTimer.executionTime gt args.debuggerConfig.slowExecutionThreshold>
						<span class="fw_redText">
							#numberFormat( thisTimer.executionTime )#ms
						</span>
					<cfelse>
						#numberFormat( thisTimer.executionTime )#ms
					</cfif>
				</td>
				<td>
					<span class="#color#">#thisTimer.method#</span>
				</td>
				</tr>
			</cfloop>
		<cfelse>
		<tr>
			<td colspan="5">No Timers Found...</td>
		</tr>
		</cfif>

		<cfscript>
			param name="args.executionTime" default="0";
			if( isNull( args.executionTime ) && structKeyExists( request, "fwExecTime" ) ){
				args.executionTime = request.fwExecTime;
			}
		</cfscript>
		<tr>
			<th colspan="5">Total ColdBox Request Execution Time: #numberFormat( args.executionTime )# ms</th>
		</tr>
	</table>
</div>
</cfoutput>