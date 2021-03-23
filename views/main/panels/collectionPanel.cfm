<cfoutput>
<!--- Public Collection --->
<table border="0" cellpadding="0" cellspacing="1" class="fw_debugTables" width="100%">
	<tr>
		<th colspan="2">#thisCollectionType# Collection</th>
	</tr>
	<cfloop collection="#thisCollection#" item="vars">
		<cfif structKeyExists(thisCollection, vars)>
			<cfset varVal = thisCollection[vars]>
		<cfelse>
			<cfset varVal = "Null">
		</cfif>
		<tr>
			<td align="right" width="15%" class="fw_debugTablesTitles"><strong>#lcase( htmlEditFormat( vars ) )#:</strong></td>
			<td  class="fw_debugTablesCells">
			<cfif isSimpleValue( varVal ) >
				<cfif varVal eq "">
					<span class="fw_redText">N/A</span>
				<cfelse>
					#htmlEditFormat( varVal )#
				</cfif>
			<cfelse>
				<!--- Max Display For Queries  --->
				<cfif isQuery(varVal) and (varVal.recordCount gt args.debuggerConfig.maxRCPanelQueryRows )>
					<cfquery name="varVal" dbType="query" maxrows="#args.debuggerConfig.maxRCPanelQueryRows#">
						select * from varVal
					</cfquery>
					<cfdump var="#varVal#" label="Query Truncated to #args.debuggerConfig.maxRCPanelQueryRows# records" expand="false">
				<cfelseif isObject(varVal)>
					<cfdump var="#varVal#" expand="false" top="2">
				<cfelse>
					<cfset setLabel="">
					<cfif isArray(varVal)>
						<cfset setLabel="Limited Array length of #arrayLen(varVal)# to 2 entries">
					</cfif>
					<cfdump var="#varVal#" expand="false" top="2" label="#setLabel#">
				</cfif>
			</cfif>
			</td>
		</tr>
	</cfloop>
</table>
</cfoutput>