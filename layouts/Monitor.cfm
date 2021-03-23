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

		<!--- Event --->
		#announce( "beforeDebuggerPanel" )#
		<!--- Rendering --->
		#renderView()#
		<!--- Event --->
		#announce( "afterDebuggerPanel" )#

		<!--- Footer --->
		<div
			align="center"
			style="margin-top:10px">
			<input
				type="button"
				name="close"
				value="Close Monitor"
				onClick="window.close()"
				style="font-size:10px">
		</div>

		<!--- JS Assets --->
		<cfinclude template="includes/footer.cfm">

	</body>
</html>
</cfoutput>