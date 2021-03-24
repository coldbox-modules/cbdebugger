<cfscript>
	function getSeverityColor( severity ){
		switch( arguments.severity ){
			case "info" : {
				return "fw_blueText";
			}
			case "debug" : {
				return "fw_greenText";
			}
			case "warn" : {
				return "fw_orangeText";
			}
			case "error" : case "fatal" : {
				return "fw_redText";
			}

		}
	}
</cfscript>
<cfif args.debuggerConfig.showTracerPanel and arrayLen( args.tracers )>
	<cfoutput>
		<!--- Title --->
		<div class="fw_titles" onClick="fw_toggle( 'fw_tracer' )">
			&nbsp;
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
				<path d="M5 3a1 1 0 000 2c5.523 0 10 4.477 10 10a1 1 0 102 0C17 8.373 11.627 3 5 3z" />
				<path d="M4 9a1 1 0 011-1 7 7 0 017 7 1 1 0 11-2 0 5 5 0 00-5-5 1 1 0 01-1-1zM3 15a2 2 0 114 0 2 2 0 01-4 0z" />
			</svg>
			ColdBox Tracer Messages (#arrayLen( args.tracers )#)
		</div>
		<!--- Panel --->
		<div class="fw_debugContent<cfif args.debuggerConfig.expandedTracerPanel>View</cfif>" id="fw_tracer">
			<cfloop array="#args.tracers#" index="thisTracer">
				<div class="fw_tracerMessage">

					<!---
					<span class='#severityStyle#'><b>#severity#</b></span> #timeFormat( loge.getTimeStamp(), "hh:MM:SS.l tt" )# <b>#loge.getCategory()#</b> <br/> #loge.getMessage()#"
					--->

					<div class="#getSeverityColor( thisTracer.severity )#" title="#thistracer.severity.ucase()#">
						<span>
							<cfif listFindNoCase( "error,fatal", thisTracer.severity ) >
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
									<path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
								</svg>
							<cfelseif thisTracer.severity eq "warn">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
									<path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
								</svg>
							<cfelseif thisTracer.severity eq "info">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
									<path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
								</svg>
							<cfelseif thisTracer.severity eq "debug">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
									<path fill-rule="evenodd" d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z" clip-rule="evenodd" />
								</svg>
							</cfif>
						</span>

						<span>
							[
								#dateformat( thisTracer.timestamp,  "mmm.dd.yyyy" )#
								@
								#timeFormat( thisTracer.timestamp,  "hh:MM:SS.l tt" )#
							]
						</span>

						<cfif len( thisTracer.category )>
							<span>
								from:
								#thisTracer.category#
							</span>
						</cfif>
					</div>

					<div style="margin-left: 20px">
						#thisTracer.message#
					</div>

					<!--- Extra Information --->
					<cfif !isSimpleValue( thisTracer.extraInfo ) or len( thisTracer.extraInfo )>
						<div style="margin-left: 20px">
							<strong>Extra Information:</strong>
							<cfif !isSimpleValue( thisTracer.extrainfo )>
								<cfdump var="#thisTracer.extrainfo#">
							<cfelse>
								#thisTracer.extrainfo#
							</cfif>
						</div>
					</cfif>

				</div>
			</cfloop>
		</div>
	</cfoutput>

	<!--- Cleanup of tracers --->
	<cfif args.debuggerConfig.clearTracersUponRendering>
		<cfset getCBDebugger().resetTracers()>
	</cfif>
</cfif>