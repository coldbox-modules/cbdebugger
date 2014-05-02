<cfparam name="url.version" default="0">
<cfparam name="url.path" 	default="#expandPath( "./Debugger-APIDocs" )#">
<cfscript>
	docName = "Debugger-APIDocs";
	base = expandPath( "/debugger" );

	colddoc 	= new ColdDoc();
	strategy 	= new colddoc.strategy.api.HTMLAPIStrategy( url.path, "Debugger v#url.version#" );
	colddoc.setStrategy( strategy );

	colddoc.generate( inputSource=base, outputDir=url.path, inputMapping="debugger" );
</cfscript>

<!---
<cfzip action="zip" file="#expandPath('.')#/#docname#.zip" source="#expandPath( docName )#" overwrite="true" recurse="yes">
<cffile action="move" source="#expandPath('.')#/#docname#.zip" destination="#url.path#">
--->

<cfoutput>
<h1>Done!</h1>
<a href="#docName#/index.html">Go to Docs!</a>
</cfoutput>

