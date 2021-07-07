<cfoutput>
	<!--- JS --->
	<script async="async" defer="defer" src="#event.getModuleRoot( "cbDebugger" )##html.elixirPath(
		fileName : "js/runtime.js",
		manifestRoot : args.manifestRoot
	)#"></script>
	<script async="async" defer="defer" src="#event.getModuleRoot( "cbDebugger" )##html.elixirPath(
		fileName : "js/vendor.js",
		manifestRoot : args.manifestRoot
	)#"></script>
	<script async="async" defer="defer" src="#event.getModuleRoot( "cbDebugger" )##html.elixirPath(
		fileName : "js/Cbdebugger.js",
		manifestRoot : args.manifestRoot
	)#"></script>
</cfoutput>