<!--- This Layout is used as a standalone debugger monitor --->
<cfoutput>
<!--- Incoming Refresh Frequency --->
<cfparam name="args.refreshFrequency" default="0">
<!--- If we are in standalone mode, produce the full HTML Layout --->
<html>
	<head>
		<title>#args.pageTitle#</title>
		<!--- Head Assets --->
		<style>
			body {
				margin: 0px;
				font-family: Arial, sans-serif;
			}
		</style>
		<cfinclude template="includes/head.cfm">
	</head>
	<body>

			<!--- Event --->
			#announce( "beforeDebuggerPanel", {
				debuggerConfig : args.debuggerConfig,
				debuggerService : args.debuggerService
			} )#

			<!--- Rendering --->
				#view()#

			<!--- Event --->
			#announce( "afterDebuggerPanel", {
				debuggerConfig : args.debuggerConfig,
				debuggerService : args.debuggerService
			} )#

		<!--- JS Assets --->
		<cfinclude template="includes/footer.cfm">

	</body>
</html>
</cfoutput>
