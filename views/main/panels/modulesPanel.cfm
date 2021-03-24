<cfoutput>
<div class="fw_titles"  onClick="fw_toggle('fw_modules')" >
	&nbsp;
	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
		<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
	</svg>
	ColdBox Modules
</div>
<div class="fw_debugContent<cfif args.debuggerConfig.expandedModulesPanel>View</cfif>" id="fw_modules">

	<div>
		<!--- Module Commands --->
		<input type="button" value="Reload All"
			   name="cboxbutton_reloadModules"
			   style="font-size:10px"
			   title="Reload All Modules"
			   onClick="location.href='#args.URLBase#?cbox_command=reloadModules'" />
		<input type="button" value="Unload All"
			   name="variables."
			   style="font-size:10px"
			   title="Unload all modules from the application"
			   onClick="location.href='#args.URLBase#?cbox_command=unloadModules'" />

	</div>

	<p>
		Below you can see the loaded application modules.
	</p>

	<div>
		<!--- Module Charts --->
		<table border="0" cellpadding="0" cellspacing="1" class="fw_debugTables">
			<tr >
				<th>Module</th>
				<th width="15%">Author</th>
				<th width="50">Version</th>
				<th width="50">V.P.L</th>
				<th width="50">L.P.L</th>
				<th width="75">Load Time</th>
				<th align="center" width="130" >CMDS</th>
			</tr>
			<cfloop array="#args.loadedModules#" index="thisModule">
				<cfset thisModuleConfig = getModuleConfig( thisModule )>
			<tr>
				<td title=" Invocation Path: #thisModuleConfig.invocationPath#">
					<strong>#thisModuleConfig.title#</strong>
					<br />
					#thisModuleConfig.description#
					<br /><br />
					<cfif len( thisModuleConfig.entryPoint )>
						<a
							href="#event.buildLink( thisModuleConfig.entryPoint )#"
							title="#event.buildLink( thisModuleConfig.entryPoint )#">
							Open
						</a>
					<cfelse>
						<em>No Entry Point Defined</em>
					</cfif>
				</td>
				<td align="center">
					<a href="#thisModuleConfig.webURL#" title="#thisModuleConfig.webURL#">#thisModuleConfig.Author#</a>
				</td>
				<td align="center">
					#thisModuleConfig.Version#
				</td>
				<td align="center">
					#yesNoFormat( thisModuleConfig.viewParentLookup )#
				</td>
				<td align="center">
					#yesNoFormat( thisModuleConfig.layoutParentLookup )#
				</td>
				<td align="center">
					#dateFormat( thisModuleConfig.loadTime, "mmm-dd" )# <br />
					#timeFormat( thisModuleConfig.loadTime, "hh:mm:ss tt" )#
				</td>
				<td align="center">
				<input type="button" value="Unload"
					   name="cboxbutton_unloadModule"
				  	   style="font-size:10px"
					   title="Unloads This Module Only!"
				   	   onClick="location.href='#args.URLBase#?cbox_command=unloadModule&module=#thisModule#'">
				&nbsp;
				<input type="button" value="Reload"
					   name="cboxbutton_unloadModule"
				  	   style="font-size:10px"
					   title="Reloads This Module Only!"
				   	   onClick="location.href='#args.URLBase#?cbox_command=reloadModule&module=#thisModule#'">
				</td>
			</tr>
			</cfloop>

		</table>

		<p>
		  <em>
			  * V.P.L = View Parent Lookup Order <br />
		  	  * L.P.L = Layout Parent Lookup Order
		  </em>
		</p>

	</div>

</div>
</cfoutput>