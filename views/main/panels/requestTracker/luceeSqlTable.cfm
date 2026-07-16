<cfoutput>
<table
	border="0"
	align="center"
	cellpadding="0"
	cellspacing="1"
	class="cbd-tables"
	>
	<thead>
		<tr>
			<th width="125" align="center">Timestamp</th>
			<th width="65" align="center" title="Execution Time">Time</th>
			<th width="75" align="center">Records</th>
			<th width="100" align="center">Datasource</th>
			<th>Query</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#args.sqlData#" item="q">
			<cfset rowId = createUUID()>
			<cfset functionName = q.src.len() ? args.debuggerService.getFunctionNameForSource( q.src ) : "">
			<cfset displaySource = q.src.replace( "\root\", "\", "one" ).replace( "/root/", "/", "one" )>
			<cfset editorSource = displaySource>
			<tr>
				<td align="center">
					#timeFormat(
						args.debuggerService.fromEpoch( q.startTime ),
						"hh:MM:SS.l tt"
					)#
				</td>

				<td align="center">
					#numberFormat( ( q.executionTime / 1000000 ) )# ms
				</td>

				<td align="center">
					#q.keyExists( "recordCount" ) ? numberFormat( q.recordCount ) : "-"#
				</td>

				<td align="center">
					#( q.datasource ?: "QoQ" )#
				</td>

				<td>
					<cfif q.src.len()>
						<div class="mb10 mt10 cbd-params" style="background: ##f8fbff; border-color: ##b7d7ff; color: ##1f2937; line-height: 1.35;">
							<!--- Title --->
							<strong>Called From:</strong>
							<!--- Open in Editor--->
							<cfif args.debuggerService.openInEditorURL( event, editorSource ) NEQ "">
								<div class="cbd-floatRight">
									<a
										class="cbd-button"
										target="_self"
										rel   ="noreferrer noopener"
										title="Open in Editor"
										href="#args.debuggerService.openInEditorURL( event, editorSource )#"
									>
										<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
										</svg>
									</a>
								</div>
							</cfif>
							<!--- Line --->
							<div title="#encodeForHTMLAttribute( q.src )#" style="font-family: Consolas, Monaco, monospace; font-size: 12px; margin-top: 2px; word-break: break-all;">
								#displaySource#
							</div>
							<cfif functionName.len()>
								<div class="mt5" style="display: flex; align-items: center; gap: 6px; flex-wrap: wrap;">
									<strong>Function: </strong>
									<span
										id="luceeSql-function-#rowId#"
										style="background: ##e0f2fe; border: 1px solid ##7dd3fc; border-radius: 4px; color: ##075985; font-family: Consolas, Monaco, monospace; font-size: 12px; font-weight: 700; padding: 2px 6px;"
									>#functionName#</span>
									<button
										type="button"
										class="cbd-button"
										title="Copy function name"
										style="font-size: 11px; padding: 2px 7px;"
										onclick="coldboxDebugger.copyToClipboard( 'luceeSql-function-#rowId#' )"
									>
										Copy
									</button>
								</div>
							</cfif>
						</div>
					</cfif>

					<!--- Sql Code --->
					<code id="luceeSql-timelinesql-#rowId#">
						<svg
							xmlns="http://www.w3.org/2000/svg"
							class="h-6 w-6 cbd-floatRight cbd-text-pre mt5"
							fill="none"
							viewBox="0 0 24 24"
							stroke="currentColor"
							title="Copy SQL to Clipboard"
							style="width: 50px; height: 50px; cursor: pointer;"
							onclick="coldboxDebugger.copyToClipboard( 'luceeSql-timelinesql-#rowId#' )"
						>
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
						</svg>
						<cfset withoutDumbWhitespace = args.formatter.prettySql( q.sql )>
						<pre>#withoutDumbWhitespace#</pre>
					</code>
				</td>
			</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>
