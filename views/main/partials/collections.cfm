<cfset collectionKeys = args.collection.keyArray()>
<cfset collectionKeys.sort( "textnocase" )>
<cfoutput>
<!--- Public Collection --->
<table border="0" cellpadding="0" cellspacing="1" class="cbd-tables" width="100%">
	<tr>
		<th colspan="2">#args.collectionType# Collection</th>
	</tr>
	<cfloop array="#collectionKeys#" index="thisKey">
		<!--- Identify Value or null --->
		<cfif !isNull( args.collection[ thisKey ] )>
			<cfset thisValue = args.collection[ thisKey ]>
		<cfelse>
			<cfset thisValue = "<em>NULL</em>">
		</cfif>
		<tr>
			<td align="right" width="15%">
				<strong>#encodeForHTML( thisKey )#:</strong>
			</td>
			<td>
				<!--- Simple Value --->
				<cfif isSimpleValue( thisValue ) >
					<cfif thisValue eq "">
						<span class="cbd-text-red">N/A</span>
					<cfelse>
						#encodeForHTML( thisValue )#
					</cfif>
				<cfelse>
					<!--- Max Display For Queries  --->
					<cfif isQuery( thisValue ) and ( thisValue.recordCount gt args.debuggerConfig.collections.maxQueryRows )>
						<cfquery name="thisValue" dbType="query" maxrows="#args.debuggerConfig.collections.maxQueryRows#">
							select * from thisValue
						</cfquery>
						<cfdump
							var="#thisValue#"
							label="Query Truncated to #args.debuggerConfig.collections.maxQueryRows# records. Click to expand"
							expand="false"
							>
					<!--- Objects --->
					<cfelseif isObject( thisValue )>
						<cfdump
							var="#thisValue#"
							expand="false"
							label="Click to expand"
							top="#args.debuggerConfig.collections.maxDumpTop#">
					<!--- Anything Else --->
					<cfelse>
						<cfdump
							var="#thisValue#"
							expand="false"
							label="Click to expand"
							top="#args.debuggerConfig.collections.maxDumpTop#">
					</cfif>
				</cfif>
			</td>
		</tr>
	</cfloop>
</table>
</cfoutput>
