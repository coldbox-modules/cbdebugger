<!-----------------------------------------------------------------------
Template    : MessageBox.cfc
Author      	 : Luis Majano
Date            : 3/13/2007 8:28:31 AM
Description :
This is a Timer plugin
Modification History:
3/13/2007 - Created Template
---------------------------------------------------------------------->
<cfcomponent
	name  ="Timer"
	hint  ="This is the Timer Debugger Model. It is used to time executions. Facade for request variable"
	output="false"
	singleton
>
	<cfproperty name="debuggerService" inject="debuggerService@cbdebugger">

	<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="Timer" output="false" hint="Constructor">
		<cfscript>
		return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="start" access="public" returntype="void" output="false" hint="Start the Timer with label.">
		<cfargument name="Label" required="true" type="string">
		<!--- Create request Timer --->
		<cfset var timerStruct = structNew()>
		<cfset timerStruct.stime = getTickCount()>
		<cfset timerStruct.label = arguments.label>
		<!--- Place timer struct in request scope --->
		<cfset request[ hash( arguments.label ) ] = timerStruct>
	</cffunction>

	<cffunction name="stop" access="public" returntype="void" output="false" hint="Stop the timer with label">
		<cfargument name="Label" required="true" type="string">
		<cfset var stopTime = getTickCount()>
		<cfset var timerStruct = "">
		<cfset var labelhash = hash( arguments.label )>

		<!--- Check if the label exists --->
		<cfif structKeyExists( request, labelhash )>
			<cfset timerStruct = request[ labelhash ]>
			<cfset addRow( timerStruct.label, stopTime - timerStruct.stime )>
		<cfelse>
			<cfset addRow( "#arguments.label# invalid", 0 )>
		</cfif>
	</cffunction>

	<cffunction
		name      ="logTime"
		access    ="public"
		returntype="void"
		output    ="false"
		hint      ="Use this method to add a new timer entry to the timers."
	>
		<cfargument name="Label" required="true" type="string" hint="The lable of the timer.">
		<cfargument name="Tickcount" required="true" type="string" hint="The tickcounts of the time.">
		<cfset addRow( arguments.label, arguments.tickcount )>
	</cffunction>

	<cffunction
		name      ="getTimerScope"
		access    ="public"
		returntype="query"
		output    ="false"
		hint      ="Returns the entire timer query from the request scope."
	>
		<cfreturn debuggerService.getTimers()>
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="addRow" access="private" returntype="void" output="false" hint="Add a new timer row.">
		<cfargument name="label" required="true" type="string" hint="The lable of the timer.">
		<cfargument name="tickcount" required="true" type="string" hint="The tickcounts of the time.">
		<cfscript>
		var qTimers = getTimerScope();

		queryAddRow( qTimers, 1 );
		querySetCell(
			qTimers,
			"ID",
			hash( arguments.label & now() )
		);
		querySetCell( qTimers, "Method", arguments.label );
		querySetCell( qTimers, "Time", arguments.tickcount );
		querySetCell( qTimers, "Timestamp", now() );
		querySetCell( qTimers, "RC", "" );
		querySetCell( qTimers, "PRC", "" );
		</cfscript>
	</cffunction>
</cfcomponent>
