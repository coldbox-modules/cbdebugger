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
			class="cbd-debugger"
			id="cbd-debugger"
			data-appurl="#event.buildLink( '' )#">

			<!--- Event --->
			#announce( "beforeDebuggerPanel", {
				debuggerConfig : args.debuggerConfig
			} )#

			<!--- Rendering --->
			<div class="mt5">
				#renderView()#
			</div>

			<!--- Event --->
			#announce( "afterDebuggerPanel", {
				debuggerConfig : args.debuggerConfig
			} )#
		</div>

		<!--- JS Assets --->
		<cfinclude template="includes/footer.cfm">

	</body>
</html>
</cfoutput>