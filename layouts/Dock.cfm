<!--- This Layout is used as an embedded layout for the debugger --->
<cfoutput>
<!--- Head Assets --->
<cfinclude template="includes/head.cfm">

<div id="cbdebug-dock" :baselink="#encodeForJavaScript( event.buildLink( '' ) )#">
	hello
</div>

<!--- JS Assets --->
<cfinclude template="includes/footer.cfm">
</cfoutput>
