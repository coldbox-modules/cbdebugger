<cfoutput>
<!--- Panel Header --->
<div class="cbd-titles"  onClick="cbdToggle('fw_modules')" >
	&nbsp;
	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
		<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
	</svg>
	ColdBox Modules (#arrayLen( args.loadedModules )#)
</div>

<!--- Panel Content --->
<div class="cbd-contentView<cfif args.debuggerConfig.expandedModulesPanel> cbd-show<cfelse> cbd-hide</cfif>" id="fw_modules">

	<!--- Toolbar --->
	<div class="cbd-floatRight">
		<!--- Reload All Modules --->
		<button
			type="button"
			title="Reload All Modules"
			id="cbd-buttonReloadAllModules"
			onClick="cbdReloadAllModules()"
		>
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
			</svg>
		</button>
	</div>

	<p>
		Below you can see the registered and activated application modules.
	</p>

	<!--- Module Charts --->
	<table border="0" cellpadding="0" cellspacing="1" class="cbd-tables">
		<tr >
			<th align="left">Module / Version</th>
			<th align="left" width="300">Mapping</th>
			<th align="center" width="100" >CMDS</th>
		</tr>

		<cfloop array="#args.loadedModules#" index="thisModule">
			<cfset thisModuleConfig = getModuleConfig( thisModule )>
			<tr id="cbd-modulerow-#thisModule#">
				<td title=" Invocation Path: #thisModuleConfig.invocationPath#">

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

					<div class="mt5">
						#thisModuleConfig.description#
					</div>
				</td>

				<!--- Mapping --->
				<td align="left">
					<div class="cbd-badge-light mt5">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
						</svg>
						#thisModuleConfig.mapping#
					</div>
				</td>

				<!--- Actions --->
				<td align="center">
					<button
						type="button"
						title="Unloads This Module!"
						onClick="cbdUnloadModule( '#thisModule#', this )"
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
						</svg>
					</button>

					<button
						type="button"
						title="Reload This Module!"
						onClick="cbdReloadModule( '#thisModule#', this )"
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
						</svg>
					</button>
				</td>
			</tr>
		</cfloop>

	</table>

</div>
</cfoutput>