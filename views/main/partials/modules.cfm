<cfscript>
	moduleKeys = args.modules.keyArray();
	arraySort( moduleKeys, "textnocase" );
</cfscript>
<cfoutput>
<table border="0" cellpadding="0" cellspacing="1" class="cbd-tables">
	<tr>
		<th align="left">Module / Version</th>
		<th align="center" width="100">Registration</th>
		<th align="center" width="100">Activation</th>
		<th align="center" width="100">CMDS</th>
	</tr>

	<cfloop array="#moduleKeys#" index="thisModule">
		<cfset moduleId = createUUID()>
		<cfset thisModuleConfig = args.modules[ thisModule ]>
		<tr
			x-ref="module-row-#thisModule#"
		>
			<td title="Invocation Path: #thisModuleConfig.invocationPath#">

				<div>
					<cfif len( thisModuleConfig.entryPoint )>
						<a href="#event.buildLink( thisModuleConfig.entryPoint )#" title="Open Module Entry Point">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
							</svg>
						</a>
					</cfif>

					<!--- Title --->
					<strong>#thisModuleConfig.title#</strong>

					<!--- Version --->
					<cfif len( thisModuleConfig.version )>
						<span class="cbd-badge-light">
							#thisModuleConfig.version#
						</span>
					</cfif>
				</div>

				<div class="mt5 mb10">
					#thisModuleConfig.description#
				</div>

				<!--- Are we recursing down? --->
				<cfif thisModuleConfig.childModules.len()>
					<cfscript>
						childModules = getSetting( "modules" ).filter( function( moduleKey, config ){
							return arrayContainsNoCase( thisModuleConfig.childModules, moduleKey );
						} );
					</cfscript>
					<!--- Child Modules --->
					<cbd-child-module
						x-data = "{
							childModule : '',
							toggleChildModule( moduleId ){
								if( this.childModule == moduleId ){
									this.childModule = ''
								} else {
									this.childModule = moduleId
								}
							}
						}"
					>
						<div
							class="cbd-titles"
							title="Toggle Children Panel"
							@click="toggleChildModule( '#moduleId#' )"
						>
							&nbsp;
							<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
							</svg>
							Child Modules (#structCount( childModules )#)
						</div>

						<!--- Panel Content --->
						<div
							class="cbd-contentView"
							x-show="childModule == '#moduleId#'"
							x-duration
						>
							#view(
								view  : "main/partials/modules",
								module : "cbdebugger",
								args : {
									modules : childModules
								},
								prePostExempt : true
							)#
						</div>
					</cbd-child-module>
				</cfif>

			</td>

			<td>
				<cfif !isNull( thisModuleConfig.registrationTime )>
					#numberFormat( thisModuleConfig.registrationTime )# ms
				<cfelse>
					<em>Upgrade to the latest ColdBox 6</em>
				</cfif>
			</td>

			<td>
				<cfif !isNull( thisModuleConfig.activationTime )>
					#numberFormat( thisModuleConfig.activationTime )# ms
				<cfelse>
					<em>Upgrade to the latest ColdBox 6</em>
				</cfif>
			</td>

			<!--- Actions --->
			<td align="center">
				<button
					type="button"
					title="Unloads This Module!"
					@click="unloadModule( '#thisModule#' )"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
						:class="{ 'cbd-spinner' : isLoading}"
					>
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
					</svg>
				</button>

				<button
					type="button"
					title="Reload This Module!"
					@click="reloadModule( '#thisModule#' )"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
						:class="{ 'cbd-spinner' : isLoading && targetAction == 'reload-#thisModule#' }"
						>
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
					</svg>
				</button>
			</td>
		</tr>
	</cfloop>

</table>
</cfoutput>
