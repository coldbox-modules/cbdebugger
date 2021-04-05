<cfscript>
allModules = getSetting( "modules" );
totalTimes = allModules.reduce( function( total, key, thisModuleConfig ){
	if( !isNull( arguments.thisModuleConfig.registrationTime ) ){
		arguments.total.registration += arguments.thisModuleConfig.registrationTime;
	}
	if( !isNull( arguments.thisModuleConfig.activationTime ) ){
		arguments.total.activation += arguments.thisModuleConfig.activationTime;
	}
	return arguments.total;
}, {
	"registration" : 0,
	"activation" : 0
} );
rootModules = allModules.filter( function( module, config ){
	return arguments.config.parent.len() == 0;
} );
</cfscript>
<cfoutput>
<!--- Panel Header --->
<div class="cbd-titles" onClick="cbdToggle( 'cbdModules' )" >
	&nbsp;
	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
		<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
	</svg>
	ColdBox Modules (#structCount( allModules )#)
</div>

<!--- Panel Content --->
<div
	class="cbd-contentView<cfif args.debuggerConfig.modules.expanded> cbd-show<cfelse> cbd-hide</cfif>"
	id="cbdModules"
>

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

	<!--- Info Bar --->
	<div class="mt10 mb10">
		<div>
			<strong>Total Registration Time:</strong>
			<div class="cbd-badge-light">
				#numberFormat( totalTimes.registration )# ms
			</div>
		</div>

		<div class="mt5">
			<strong>Total Activation Time:</strong>
			<div class="cbd-badge-light">
				#numberFormat( totalTimes.activation )# ms
			</div>
		</div>
	</div>

	#renderView(
		view  : "main/partials/modules",
		module : "cbdebugger",
		args : {
			modules : rootModules
		},
		prePostExempt : true
	)#

</div>
</cfoutput>