<cfoutput>
<h2>Executions</h2>
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
</cfoutput>