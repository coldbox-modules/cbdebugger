<!--- This Layout is used as an embedded layout for the debugger --->
<cfoutput>
<!--- Head Assets --->
<cfinclude template="includes/head.cfm">

<div
	class="cbd-debugger"
	id="cbd-debugger"
	data-appurl="#event.buildLink( '' )#"
>
	<!--- Event --->
	#announce( "beforeDebuggerPanel", {
		debuggerConfig : args.debuggerConfig
	} )#
	<!--- Rendering --->
	#renderView()#
	<!--- Event --->
	#announce( "afterDebuggerPanel", {
		debuggerConfig : args.debuggerConfig
	} )#
</div>

<!--- JS Assets --->
<cfinclude template="includes/footer.cfm">
</cfoutput>