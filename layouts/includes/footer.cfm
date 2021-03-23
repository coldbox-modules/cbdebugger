<cfoutput>
	<!--- JS --->
	<script src="#event.getModuleRoot( "cbDebugger" )##html.elixirPath(
		fileName : "js/runtime.js",
		manifestRoot : args.manifestRoot
	)#"></script>
	<script src="#event.getModuleRoot( "cbDebugger" )##html.elixirPath(
		fileName : "js/vendor.js",
		manifestRoot : args.manifestRoot
	)#"></script>
	<script src="#event.getModuleRoot( "cbDebugger" )##html.elixirPath(
		fileName : "js/App.js",
		manifestRoot : args.manifestRoot
	)#"></script>
</cfoutput>