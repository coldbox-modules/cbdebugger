<cfif args.debuggerConfig.showTracerPanel and arrayLen( args.tracers )>
	<cfoutput>
		<div class="fw_titles" onClick="fw_toggle( 'fw_tracer' )">
			&nbsp;ColdBox Tracer Messages
		</div>
		<div class="fw_debugContent<cfif args.debuggerConfig.expandedTracerPanel>View</cfif>" id="fw_tracer">
			<cfloop array="#args.tracers#" index="thisTracer">
				<div class="fw_tracerMessage">
					<!--- Message --->
					<div>
						#thisTracer.message#
					</div>

					<!--- Extra Information --->
					<div>
						<cfif not isSimpleValue( thisTracer.extrainfo )>
							<strong>ExtraInformation:<br></strong>
							<cfdump var="#thisTracer.extrainfo#">
						<cfelseif thisTracer.extrainfo neq "">
							<strong>ExtraInformation:<br></strong>
							#thisTracer.extrainfo#
						</cfif>
					</div>

				</div>
			</cfloop>
		</div>
	</cfoutput>
</cfif>