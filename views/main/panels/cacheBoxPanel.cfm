<cfoutput>
<cfmodule
	template     = "/coldbox/system/cache/report/monitor.cfm"
	cacheFactory = #variables.controller.getCacheBox()#
	expandedPanel="#args.debuggerConfig.cachebox.expanded#"
>
</cfoutput>