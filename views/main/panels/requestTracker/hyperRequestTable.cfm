<cfoutput>
<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
	<thead>
		<tr>
			<th width="125">Status</th>
			<th width="125">Timestamp</th>
			<th width="125">Execution Time</th>
			<th>Request</th>
		</tr>
	</thead>
	<tbody>
		<cfloop collection="#args.requestData#" index="requestId">
			<cfset thisRequest = args.requestData[ requestId ]>
			<tr>
				<td>
					<div>
						<cfif thisRequest.status eq "started">
							<span class="cbd-text-red" title="Started but never finished">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-exclamation-octagon" viewBox="0 0 16 16">
									<path d="M4.54.146A.5.5 0 0 1 4.893 0h6.214a.5.5 0 0 1 .353.146l4.394 4.394a.5.5 0 0 1 .146.353v6.214a.5.5 0 0 1-.146.353l-4.394 4.394a.5.5 0 0 1-.353.146H4.893a.5.5 0 0 1-.353-.146L.146 11.46A.5.5 0 0 1 0 11.107V4.893a.5.5 0 0 1 .146-.353L4.54.146zM5.1 1 1 5.1v5.8L5.1 15h5.8l4.1-4.1V5.1L10.9 1H5.1z"/>
									<path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
								</svg>
							</span>
						<cfelse>
							<span class="cbd-text-green" title="completed">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
									<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
									<path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
								</svg>
							</span>
						</cfif>
						#thisRequest.response.statusCode#
						<small>#thisRequest.response.statusText#</small>
					</div>
				</td>

				<td>
					#TimeFormat( thisRequest.timestamp,"hh:MM:SS.l tt" )#
				</td>

				<td>
					#numberFormat( thisRequest.executionTime )# ms
				</td>

				<td
					x-data ="{
						infoPanelOpen: false
					}"
				>
					<div class="mb10 mt10 cbd-params cbd-flex">
						<span class="mr5">
							<button
								type="button"
								class="cbd-button cbd-floatRight"
								title="Open Request/Response Details"
								@click="infoPanelOpen = !infoPanelOpen"
							>
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-circle" viewBox="0 0 16 16">
									<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
									<path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
							  	</svg>
							</button>
						</span>

						<span>
							#thisRequest.request.method#>#thisRequest.request.url#
						</span>
					</div>

					<div x-show="infoPanelOpen">
						<p><strong>Request:</strong></p>
						<code>
							<cfset prettyJson = args.formatter.prettyJson( serializeJSON( thisRequest.request ) )>
							<pre>#prettyJson#</pre>
						</code>

						<p><strong>Response:</strong></p>
						<code>
							<cfset prettyJson = args.formatter.prettyJson( serializeJSON( thisRequest.response ) )>
							<pre>#prettyJson#</pre>
						</code>

						<div class="mb10 mt10 cbd-params">
							<!--- Title --->
							<strong>Called From: </strong>
							<!--- Open in Editor--->
							<cfif args.debuggerService.openInEditorURL( event, thisRequest.caller ) NEQ "">
								<div class="cbd-floatRight">
									<a
										class="cbd-button"
										target="_self"
										rel   ="noreferrer noopener"
										title="Open in Editor"
										href="#args.debuggerService.openInEditorURL( event, thisRequest.caller )#"
									>
										<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
										</svg>
									</a>
								</div>
							</cfif>
							<!--- Line --->
							<div>
								<strong>
									#replaceNoCase( thisRequest.caller.template, args.appPath, "" )#:#thisRequest.caller.line#
								</strong>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>
