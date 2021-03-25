<!--- This Layout is used as an embedded layout for the debugger --->
<cfoutput>
<!--- Head Assets --->
<cfinclude template="includes/head.cfm">

<div class="cbDebugger">
	<!--- Event --->
	#announce( "beforeDebuggerPanel" )#
	<!--- Rendering --->
	#renderView()#
	<!--- Event --->
	#announce( "afterDebuggerPanel" )#
</div>

<!--- JS Assets --->
<cfinclude template="includes/footer.cfm">
</cfoutput>