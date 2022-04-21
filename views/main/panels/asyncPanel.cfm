<cfscript>
	asyncManager = controller.getAsyncManager();
	executors = asyncManager.getExecutors();
	executorKeys = executors.keyArray();
	arraySort( executorKeys, "textnocase" );
</cfscript>
<cfoutput>
<div
	id="cbd-async"
	x-data="{
		panelOpen : #args.debuggerConfig.async.expanded ? 'true' : 'false'#,
		showExecutor : '',
		toggleTasks( executor ){
			if( this.showExecutor == executor ){
				this.showExecutor = ''
			} else {
				this.showExecutor = executor
			}
		}
	}"
>
	<!--- Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
		</svg>
		ColdBox Async Manager
	</div>

	<!--- Panel --->
	<div
		class="cbd-contentView"
		x-show="panelOpen"
		x-cloak
		x-transition
	>

		<!--- Info Bar --->
		<div class="mt10 mb10">
			<div>
				<strong>Total Executors:</strong>
				<div class="cbd-badge-light">
					#executors.count()#
				</div>
			</div>
		</div>

		<!--- Executor Reports --->
		<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
			<tr>
				<th align="left" >Name</th>
				<th width="200" align="left" >Type</th>
				<th width="75" align="center" >Pool Size</th>
				<th width="75" align="center" >Core Size</th>
				<th width="75" align="center" >Active Tasks</th>
				<th width="75" align="center" >Scheduled Tasks</th>
				<th width="75" align="center" >Completed Tasks</th>
				<th width="50" align="center" >Actions</th>
			</tr>

			<cfloop array="#executorKeys#" index="executorName">
				<cfset thisExecutor = executors[ executorName ]>
				<cfset stats = thisExecutor.getStats()>
				<tr>
					<td>
						#executorName#
					</td>
					<td>
						#listLast( thisExecutor.getNative().getClass().getName(), "." )#
					</td>
					<td align="center">
						#stats.poolSize#
					</td>
					<td align="center">
						#stats.corePoolSize#
					</td>
					<td align="center">
						#stats.activeCount#
					</td>
					<td align="center">
						#stats.taskCount#
					</td>
					<td align="center">
						#numberFormat( stats.completedTaskCount )#
					</td>
					<td align="center">
						<button
							title="View Tasks"
							@click="toggleTasks( '#executorName#' )"

						>
							<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16l2.879-2.879m0 0a3 3 0 104.243-4.242 3 3 0 00-4.243 4.242zM21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
							</svg>
						</button>
					</td>
				</tr>

				<!--- Task Report --->
				<tr
					class="cbd-bg-gray"
					data-executor="#encodeForHTMLAttribute( executorName )#"
					x-show="showExecutor == $el.dataset.executor"
					x-cloak
					x-transition
				>
					<td colspan="8" class="p20">
						<cfset queue = thisExecutor.getQueue().toArray()>
						<cfif arrayLen( queue )>
							<table border="0" align="center" cellpadding="0" cellspacing="1" class="cbd-tables">
								<tr>
									<th align="left" >Task Id</th>
									<th align="left" width="75">Periodic</th>
									<th align="left" width="75">Delay (sec)</th>
									<th align="left" width="75">Done</th>
									<th align="left" width="75">Cancelled</th>
								</tr>

								<cfloop array="#queue#" index="thisTask">
									<cfset isScheduledFuture = findNoCase( "ScheduledFuture", thisTask.getClass().getName() )>
									<tr>
										<td>
											#thisTask.hashCode()#
										</td>

										<!--- Periodic? --->
										<td>
											<cfif isScheduledFuture>
												#yesNoFormat( thisTask.isPeriodic() )#
											<cfelse>
												<em>n/a</em>
											</cfif>
										</td>
										<!--- Get Delay --->
										<td>
											<cfif isScheduledFuture>
												#numberFormat( thisTask.getDelay( thisExecutor.$timeUnit.get( "seconds" ) ) )#
											<cfelse>
												<em>n/a</em>
											</cfif>
										</td>
										<!--- Done --->
										<td>
											#yesNoFormat( thisTask.isDone() )#
										</td>
										<!--- Cancelled --->
										<td>
											#yesNoFormat( thisTask.isCancelled() )#
										</td>
									</tr>
								</cfloop>

							</table>
						<cfelse>
							<em class="cbd-text-red">
								No running tasks
							</em>
						</cfif>
					</td>
				</tr>
			</cfloop>

		</table>

	</div>
</div>
</cfoutput>
