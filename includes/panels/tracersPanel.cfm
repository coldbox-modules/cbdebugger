<cfsetting enablecfoutputonly="true">
<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Template :  debug.cfm
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Debugging template for the application
----------------------------------------------------------------------->
<cfif variables.debuggerConfig.showTracerPanel and arrayLen( variables.tracers )>
<cfoutput>
	<div class="fw_titles" onClick="fw_toggle('fw_tracer')">&nbsp;ColdBox Tracer Messages </div>
	<div class="fw_debugContent<cfif variables.debuggerConfig.expandedTracerPanel>View</cfif>" id="fw_tracer">
		<cfloop from="1" to="#arrayLen( variables.tracers )#" index="i">
			<div class="fw_tracerMessage">

				<!--- Message --->
				<strong>Message:</strong><br>
				#variables.tracers[ i ].message#<br>

				<!--- Extra Information --->
				<cfif not isSimpleValue(variables.tracers[ i ].extrainfo)>
					<strong>ExtraInformation:<br></strong>
					<cfdump var="#variables.tracers[ i ].extrainfo#">
				<cfelseif variables.tracers[ i ].extrainfo neq "">
					<strong>ExtraInformation:<br></strong>
					#variables.tracers[ i ].extrainfo#
				</cfif>

			</div>
		</cfloop>
	</div>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false">