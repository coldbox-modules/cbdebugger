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
			<th width="100" align="center">Execution Time</th>
			<th width="100" align="center">Datasource</th>
			<th>Query</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#args.sqlData#" item="q">
			<cfset rowId = createUUID()>
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
					#( q.datasource ?: "QoQ" )#
				</td>

				<td>
					<cfif q.src.len()>
						<div class="mb10 mt10 cbd-params">
							<!--- Title --->
							<strong>Called From: </strong>
							<!--- Open in Editor--->
							<cfif args.debuggerService.openInEditorURL( event, q.src ) NEQ "">
								<div class="cbd-floatRight">
									<a
										class="cbd-button"
										target="_self"
										rel   ="noreferrer noopener"
										title="Open in Editor"
										href="#args.debuggerService.openInEditorURL( event, q.src )#"
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
									#q.src#
								</strong>
							</div>
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
