<!--- This Layout is used as an embedded layout for the debugger --->
<cfoutput>
<!--- Head Assets --->
<cfinclude template="includes/head.cfm">

<div
	x-data = "{
		appUrl : '#encodeForJavaScript( event.buildLink( '' ) )#'
	}"
	class="cbd-debugger"
	id="cbd-debugger"
	data-appurl="#event.buildLink( '' )#"
>
	#announce( "beforeDebuggerPanel", {
		debuggerConfig : args.debuggerConfig,
		debuggerService : args.debuggerService
	} )#

	#view()#

	#announce( "afterDebuggerPanel", {
		debuggerConfig : args.debuggerConfig,
		debuggerService : args.debuggerService
	} )#
</div>

<!--- JS Assets --->
<cfinclude template="includes/footer.cfm">
</cfoutput>
