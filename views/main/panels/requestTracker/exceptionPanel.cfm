<cfset exceptionKeys = args.profiler.exception.keyArray()>
<cfset exceptionKeys.sort( "textnocase" )>
<cfoutput>
<div
	id="cbd-exception-panel"
	x-data="{
		panelOpen : true
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
		Exception Data
	</div>

	<div
		class="cbd-contentView"
		id="cbd-exceptionData"
		x-transition
		x-cloak
		x-show="panelOpen"
	>
		<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
			<cfloop array="#exceptionKeys#" item="thisItem" >
				<cfif !isSimpleValue( args.profiler.exception[ thisItem ] ) OR len( args.profiler.exception[ thisItem ] )>
					<tr>
						<th width="100" align="right">
							#thisItem# :
						</th>
						<td class="cbd-cellBreak">
							<div>
								<!--- Simple value Exceptions --->
								<cfif isSimpleValue( args.profiler.exception[ thisItem ] )>

									<cfif thisItem eq "stacktrace">
										<code><pre>#args.debuggerService.processStackTrace( args.profiler.exception[ thisItem ] )#</pre></code>
									<cfelse>
										#args.profiler.exception[ thisItem ]#
									</cfif>

								<!--- Complex Value Exception data --->
								<cfelse>
									<!--- Tag Context Rendering --->
									<cfif thisItem eq "tagContext">
										<cfset appPath = getSetting( "ApplicationPath" )>
										<cfloop array="#args.profiler.exception[ thisItem ]#" item="thisTagContext">
											<div class="mb10 mt10 cbd-params">

												<!--- Open in Editor--->
												<cfif args.debuggerService.openInEditorURL( event, thisTagContext ) NEQ "">
													<div class="cbd-floatRight">
														<a
															class="cbd-button"
															target="_self"
															rel   ="noreferrer noopener"
															title="Open in Editor"
															href="#args.debuggerService.openInEditorURL( event, thisTagContext )#"
														>
															<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
																<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
															</svg>
														</a>
													</div>
												</cfif>

												<!--- Line --->
												<div>
													<strong>
														#replaceNoCase( thisTagContext.template, appPath, "" )#:#thisTagContext.line#
													</strong>
												</div>

												<!--- Code Print --->
												<cfif thisTagContext.keyExists( "codePrintPlain" )>
													<div class="mt5 cbd-text-muted">
														<code><pre>#thisTagContext.codePrintPlain#</pre></code>
													</div>
												</cfif>
											</div>
										</cfloop>
									<!--- Other Rendering --->
									<cfelse>
										<cfdump var="#args.profiler.exception[ thisItem ]#">
									</cfif>
								</cfif>
							</div>
						</td>
					</tr>
				</cfif>
			</cfloop>
		</table>
	</div>
</div>
</cfoutput>
