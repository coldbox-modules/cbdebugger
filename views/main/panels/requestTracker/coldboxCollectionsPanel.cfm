<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
</cfscript>
<cfoutput>
<div
	id="cbd-coldbox-collections-panel"
	x-data="{
		panelOpen : #args.debuggerConfig.collections.expanded ? 'true' : 'false'#
	}"
>
	<!--- Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>
		ColdBox Request Structures
	</div>

	<div
		class="cbd-contentView"
		id="cbd-coldbox-collectionsData"
		x-transition
		x-cloak
		x-show="panelOpen"
	>
		<!--- Public Collection --->
		#view(
			view : "main/partials/collections",
			module : "cbdebugger",
			args : {
				collection : rc,
				collectionType : "Public",
				debuggerConfig : args.debuggerConfig,
				debuggerService : args.debuggerService
			},
			prePostExempt : true
		)#
		<!--- Private Collection --->
		#view(
			view : "main/partials/collections",
			module : "cbdebugger",
			args : {
				collection : prc,
				collectionType : "Private",
				debuggerConfig : args.debuggerConfig,
				debuggerService : args.debuggerService
			},
			prePostExempt : true
		)#
	</div>
</div>
</cfoutput>
