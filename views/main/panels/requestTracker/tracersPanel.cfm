<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
	function getSeverityColor( severity ){
		switch( arguments.severity ){
			case "info" : {
				return "cbd-text-blue";
			}
			case "debug" : {
				return "cbd-text-green";
			}
			case "warn" : {
				return "cbd-text-orange";
			}
			case "error" : case "fatal" : {
				return "cbd-text-red";
			}

		}
	}
</cfscript>
<cfoutput>
<div
	id="cbd-coldbox-tracers-panel"
	x-data="{
		panelOpen : #args.debuggerConfig.tracers.expanded ? 'true' : 'false'#
	}"
>
	<!--- Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
			<path fill-rule="evenodd" d="M5.05 3.636a1 1 0 010 1.414 7 7 0 000 9.9 1 1 0 11-1.414 1.414 9 9 0 010-12.728 1 1 0 011.414 0zm9.9 0a1 1 0 011.414 0 9 9 0 010 12.728 1 1 0 11-1.414-1.414 7 7 0 000-9.9 1 1 0 010-1.414zM7.879 6.464a1 1 0 010 1.414 3 3 0 000 4.243 1 1 0 11-1.415 1.414 5 5 0 010-7.07 1 1 0 011.415 0zm4.242 0a1 1 0 011.415 0 5 5 0 010 7.072 1 1 0 01-1.415-1.415 3 3 0 000-4.242 1 1 0 010-1.415zM10 9a1 1 0 011 1v.01a1 1 0 11-2 0V10a1 1 0 011-1z" clip-rule="evenodd" />
		</svg>
		ColdBox Tracer Messages

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
		</svg>

		<!--- Count --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
		</svg>
		#arrayLen( args.tracers )#
	</div>

	<!--- Panel --->
	<div
		class="cbd-contentView"
		id="cbd-tracersData"
		x-transition
		x-cloak
		x-show="panelOpen"
	>
		<cfloop array="#args.tracers#" index="thisTracer">
			<div class="cbd-tracerMessage">

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

				<div class="ml20">
					#thisTracer.message#
				</div>

				<!--- Extra Information --->
				<cfif !isSimpleValue( thisTracer.extraInfo ) or len( thisTracer.extraInfo )>
					<div class="ml20">
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

		<cfif !arrayLen( args.tracers )>
			<em>No tracers found</em>
		</cfif>
	</div>

</div>
</cfoutput>
