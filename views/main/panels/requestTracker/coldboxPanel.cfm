<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
	sqlFormatter = args.debuggerService.getSqlFormatter();
	jsonFormatter = args.debuggerService.getjsonFormatter();
	coldboxKeys = args.profiler.coldbox.keyArray();
	coldboxKeys.sort( "textnocase" );
</cfscript>
<cfoutput>
<div
	id="cbd-coldbox-panel"
	x-data="{
		panelOpen : #args.debuggerConfig.requestTracker.coldboxInfo.expanded ? 'true' : 'false'#
	}"
>
	<!--- Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
		</svg>
		ColdBox Event Information
	</div>

	<div
		class="cbd-contentView"
		id="cbd-coldboxData"
		x-transition
		x-cloak
		x-show="panelOpen"
	>
		<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
			<cfloop array="#coldboxKeys#" item="thisItem" >
				<tr>
					<th width="200" align="right">
						#thisItem# :
					</th>
					<td>
						<div class="cbd-cellScroller">
							<cfif isSimpleValue( args.profiler.coldbox[ thisItem ] )>
								<cfif !isBoolean( args.profiler.coldbox[ thisItem ] ) && isJSON( args.profiler.coldbox[ thisItem ] )>
									#jsonFormatter.formatJSON( args.profiler.coldbox[ thisItem ] )#
								<cfelse>
									<cfif len( args.profiler.coldbox[ thisItem ] )>
										#args.profiler.coldbox[ thisItem ]#
									<cfelse>
										<em class="cbd-text-muted">
											n/a
										</em>
									</cfif>
								</cfif>
							<cfelse>
								<cfdump
									var="#args.profiler.coldbox[ thisItem ]#"
									label="Click to expand..."
									expand="false">
							</cfif>
						</div>
					</td>
				</tr>
			</cfloop>
		</table>
	</div>
</div>
</cfoutput>
