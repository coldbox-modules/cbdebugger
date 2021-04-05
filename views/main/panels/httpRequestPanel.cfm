<cfset jsonFormatter = getInstance( '@JSONPrettyPrint' )>
<cfoutput>
<!--- Title --->
<div class="cbd-titles" onClick="cbdToggle( 'cbd-requestInfo' )">
	&nbsp;
	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
		<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122" />
	</svg>
	HTTP Request
</div>

<!--- Panel --->
<div
	class="cbd-contentView<cfif args.debuggerConfig.requestTracker.httpRequest.expanded> cbd-show<cfelse> cbd-hide</cfif>"
	id="cbd-requestInfo"
>
	<h2>Request Information</h2>
	<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
		<!--- Method --->
		<tr>
			<th width="125" align="right">HTTP Method:</th>
			<td>#args.profiler.requestData.method#</td>
		</tr>
		<!--- Full URL --->
		<tr>
			<th width="125" align="right">HTTP URL:</th>
			<td>#args.profiler.fullUrl#</td>
		</tr>
		<!--- HTTP Host --->
		<tr>
			<th width="125" align="right">HTTP Host:</th>
			<td>#args.profiler.httpHost#</td>
		</tr>
		<!--- HTTP referer --->
		<tr>
			<th width="125" align="right">HTTP Referer:</th>
			<td>
				<cfif len( args.profiler.httpReferer )>
					#args.profiler.httpReferer#
				<cfelse>
					<em>n/a</em>
				</cfif>
			</td>
		</tr>
		<!--- User Agent --->
		<tr>
			<th width="125" align="right">User Agent:</th>
			<td>#args.profiler.userAgent#</td>
		</tr>
		<!--- Body Content --->
		<cfif !isNull( args.profiler.requestData.content )>
			<tr>
				<th width="125" align="right">HTTP Content:</th>
				<td>
					<div class="cbd-cellScroller">
						<cfif isSimpleValue( args.profiler.requestData.content )>
							<cfif !isBoolean( args.profiler.requestData.content ) && isJSON( args.profiler.requestData.content )>
								<code><pre>#getInstance( '@JSONPrettyPrint' ).formatJSON( args.profiler.requestData.content )#</pre></code>
							<cfelseif len( args.profiler.requestData.content )>
								#args.profiler.requestData.content#
							<cfelse>
								<em class="cbd-text-muted">empty</em>
							</cfif>
						<cfelse>
							<cfdump var="#args.profiler.requestData.content#">
						</cfif>
					</div>
				</td>
			</tr>
		</cfif>
		<!--- Form Params --->
		<cfif len( args.profiler.formData )>
			<tr>
				<th width="125" align="right">Form Params:</th>
				<td>
					<div class="cbd-cellScroller">
						<code>
							<pre>#jsonFormatter.formatJSON( args.profiler.formData )#</pre>
						</code>
					</div>
				</td>
			</tr>
		</cfif>
	</table>

	<cfset headerKeys = args.profiler.requestData.headers.keyArray()>
	<cfset headerKeys.sort( "textnocase" )>
	<h2>Headers</h2>
	<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
		<cfloop array="#headerKeys#" item="thisHeader" >
			<tr>
				<th width="175" align="right">
					#thisHeader#
				</th>
				<td >
					<cfif thisHeader eq "cookie">
						<div class="cbd-cellScroller">
							<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
								<tr>
									<th width="50%">
										Cookie Name
									</th>
									<th>
										Cookie Value
									</th>
								</tr>
								<!--- Sort Cookies --->
								<cfset cookieKeys = args.profiler.requestData.headers.cookie.listToArray( ";" )>
								<cfset cookieKeys.sort( "textnocase" )>
								<cfloop array="#cookieKeys#" index="thisCookie">
									<tr>
										<td class="cbd-cellBreak">
											<em class="textBlue">
												#getToken( thisCookie, 1, "=" )#
											</em>
										</td>
										<td class="cbd-cellBreak">
											<cfif !isBoolean( getToken( thisCookie, 2, "=" ) ) && isJSON( getToken( thisCookie, 2, "=" ) )>
												#getInstance( '@JSONPrettyPrint' ).formatJSON( getToken( thisCookie, 2, "=" ) )#
											<cfelse>
												#getToken( thisCookie, 2, "=" )#
											</cfif>
										</td>
									</tr>
								</cfloop>
							</table>
						</div>
					<cfelse>
						<div class="cbd-cellScroller">
							<code>
								#replace( args.profiler.requestData.headers[ thisHeader ], ";", "<br>", "all" )#
							</code>
						</div>
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>