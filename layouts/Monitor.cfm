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

		<div>
			<strong>Monitor Refresh Frequency: </strong>
			<select
				id="frequency"
				style="font-size:10px"
				onChange="fw_pollmonitor( '#args.currentPanel#', this.value, '#args.URLBase#' )">
					<option value="0">None</option>
					<option value="2" <cfif args.refreshFrequency eq 2>selected</cfif>>2 Seconds</option>
					<option value="3" <cfif args.refreshFrequency eq 3>selected</cfif>>3 Seconds</option>
					<cfloop from="5" to="30" index="i" step="5">
						<option value="#i#" <cfif args.refreshFrequency eq i>selected</cfif>>#i# Seconds</option>
					</cfloop>
			</select>
			<hr>
		</div>

		<!--- Rendering --->
		<div class="fw_debugPanel">
			#renderView()#
		</div>
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
			>
		</div>

		<!--- JS Assets --->
		<cfinclude template="includes/footer.cfm">

	</body>
</html>
</cfoutput>