<!--- This Layout is used as a standalone debugger monitor --->
<cfoutput>
<!--- Incoming Refresh Frequency --->
<cfparam name="args.refreshFrequency" default="0">
<!--- If we are in standalone mode, produce the full HTML Layout --->
<html>
	<head>
		<title>#args.pageTitle#</title>
		<cfif args.refreshFrequency gt 0>
			<!--- Meta Tag Refresh --->
			<meta http-equiv="refresh" content="#args.refreshFrequency#">
		</cfif>
		<!--- Head Assets --->
		<cfinclude template="includes/head.cfm">
	</head>
	<body>
		<div
			x-data = "{
				appUrl : '#encodeForJavaScript( event.buildLink( '' ) )#'
			}"
			class="cbd-debugger"
			id="cbd-debugger"
		>
			<!--- Event --->
			#announce( "beforeDebuggerPanel", {
				debuggerConfig : args.debuggerConfig,
				debuggerService : args.debuggerService
			} )#

			<!--- Rendering --->
			<div class="mt5">
				#view()#
			</div>

			<!--- Event --->
			#announce( "afterDebuggerPanel", {
				debuggerConfig : args.debuggerConfig,
				debuggerService : args.debuggerService
			} )#
		</div>

		<!--- JS Assets --->
		<cfinclude template="includes/footer.cfm">

	</body>
</html>
</cfoutput>
