<div id="cbdebugger">
	<div id="cbdebug-dock">
		<object-panel></object-panel>
	</div>
</div>

<!--- <cfparam name="args.refreshFrequency" default="0">
<cfparam name="args.isVisualizer" default="false">
<cfoutput>
<div
	id="cbd-request-tracker"
	x-data = "cbdRequestTrackerPanel(
		#args.isVisualizer ? 'true' : 'false'#,
		#args.refreshFrequency#,
		#controller.getSetting( 'ReinitPassword' ).length() ? 'true' : 'false'#,
		#args.isVisualizer ? 'true' : 'false'#
	)"
>
	<!--- Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		<div class="cbd-flex ml5">
			<div>
				<img src="#args.moduleRoot#/includes/images/coldbox_16.png" class="">
			</div>

			<div class="ml5">
				<cfif args.isVisualizer>
					ColdBox Request Tracker
				</cfif>

				<!--- If not expanded and not in visualizer mode --->
				<cfif !args.currentProfiler.isEmpty()>
					<span
						x-show="!isVisualizer"
						x-cloak
						x-transition
					>
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
						</svg>

						#args.currentProfiler.requestData.method#

						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
						</svg>

						#args.currentProfiler.coldbox.event#

						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
						</svg>

						#args.currentProfiler.response.statusCode#

						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
						</svg>

						#numberFormat( args.currentProfiler.executionTime )# ms
					</span>
				</cfif>
			</div>
		</div>
	</div>

	<!--- Panel --->
	<div
		class="cbd-contentView"
		x-show="panelOpen"
		x-cloak
		x-transition
	>

		<!--- Toolbar --->
		<div class="cbd-floatRight">

			<!--- ************************************************ --->
			<!--- Visualizer Toolbar --->
			<!--- ************************************************ --->
			<cfif args.isVisualizer>

				<!--- Auto Refresh Frequency --->
				<select
					@change="startDebuggerMonitor( $el.value )"
					x-model="refreshFrequency"
				>
					<option value="0">No Auto-Refresh</option>
					<option value="2">2 Seconds</option>
					<option value="3">3 Seconds</option>
					<cfloop from="5" to="30" index="i" step="5">
						<option value="#i#">#i# Seconds</option>
					</cfloop>
				</select>

				<!--- Refresh Profilers --->
				<button
					type="button"
					title="Refresh the profilers"
					@click="refreshProfilers()"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						x-ref="refreshLoader"
						stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
					</svg>
				</button>

				<!--- Clear Profilers --->
				<button
					type="button"
					title="Clear the profilers"
					@click="clearProfilers"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						x-ref="clearLoader"
						stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
					</svg>
				</button>

				<!--- Reinit --->
				<button
					title="Reinitialize the framework."
					@click="reinitFramework"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						x-ref="reinitLoader"
						stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
					</svg>
				</button>

				<!--- Heap Dump --->
				<button
					title="Download Heap Dump Snapshot"
					onClick="window.location='#args.urlBase#cbdebugger/heapdump'"
				>
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sd-card" viewBox="0 0 16 16">
						<path d="M6.25 3.5a.75.75 0 0 0-1.5 0v2a.75.75 0 0 0 1.5 0v-2zm2 0a.75.75 0 0 0-1.5 0v2a.75.75 0 0 0 1.5 0v-2zm2 0a.75.75 0 0 0-1.5 0v2a.75.75 0 0 0 1.5 0v-2zm2 0a.75.75 0 0 0-1.5 0v2a.75.75 0 0 0 1.5 0v-2z"/>
						<path fill-rule="evenodd" d="M5.914 0H12.5A1.5 1.5 0 0 1 14 1.5v13a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 14.5V3.914c0-.398.158-.78.44-1.06L4.853.439A1.5 1.5 0 0 1 5.914 0zM13 1.5a.5.5 0 0 0-.5-.5H5.914a.5.5 0 0 0-.353.146L3.146 3.561A.5.5 0 0 0 3 3.914V14.5a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5v-13z"/>
					</svg>
				</button>

				<!--- Turn Debugger Off --->
				<button
					title="Turn the ColdBox Debugger Off"
					onClick="window.location='#args.urlBase#?debugmode=false'"
				>
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
					</svg>
				</button>

			<!--- ************************************************ --->
			<!--- NON Visualizer Toolbar --->
			<!--- ************************************************ --->
			<cfelse>
				<a
					class="cbd-button"
					title="Open Debugger Visualizer"
					href="#event.buildLink( "cbdebugger" )#"
					target="_blank"
				>
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
					</svg></a>
			</cfif>
		</div>

		<!--- General Information --->
		<div>
			<!--- Machine Info --->
			<div class="cbd-titleCell">
				Framework Info:
			</div>
			<div class="cbd-contentCell">
				#controller.getColdboxSettings().codename#
				#controller.getColdboxSettings().version#
				#controller.getColdboxSettings().suffix#
			</div>

			<!--- App Name + Environment --->
			<div class="cbd-titleCell">
				Application Name:
			</div>
			<div class="cbd-contentCell">
				#controller.getSetting( "AppName" )#
				<span class="cbd-text-purple">
					(environment=#controller.getSetting( "Environment" )#)
				</span>
			</div>

			<!--- App Name + Environment --->
			<div class="cbd-titleCell">
				CFML Engine:
			</div>
			<div class="cbd-contentCell">
				#args.environment.cfmlEngine#
				#args.environment.cfmlVersion#
				/
				Java #args.environment.javaVersion#
			</div>
		</div>

		<!---**********************************************************************--->
		<!--- RENDER PROFILERS OR PROFILER REPORT, DEPENDING ON VISUALIZER FLAG --->
		<!---**********************************************************************--->

		<a name="cbd-profilers"></a>
		<table class="cbd-tables">
			<tr>
				<th width="50">Event Type</th>
				<th width="100">Start</th>
				<th width="50" >Duration(ms)</th>
				<th>Details</th>
				<th>Extra</th>
			</tr>
			<cfloop array=#args.DEBUGGERSERVICE.getEvents()# index="event">
				<tr>
					<td>#event.eventType#</td>
					<td>#timeformat(event.timestamp,"hh:mm tt")#</td>
					<td>#event.executionTimeMillis#</td>
					<td>#event.details#</td>
					<td><cfdump var=#event.extraInfo# expand=false ></td>
				</tr>
			</cfloop>
		</table>
		 <div
			id="cbd-profilers"
			x-ref="cbd-profilers"
		>
			<!--- If visualizer, show all the profilers--->
			<cfif args.isVisualizer>
				<h2>Request History</h2>
				#view(
					view : "main/partials/profilers",
					module : "cbdebugger",
					args : {
						environment : args.environment,
						profilers : args.profilers,
						debuggerConfig : args.debuggerConfig,
						debuggerService : args.debuggerService
					},
					prePostExempt : true
				)#
			<!--- Else it's a single report request --->
			<cfelse>
				#view(
					view : "main/partials/profilerReport",
					module : "cbdebugger",
					args : {
						debuggerService : args.debuggerService,
						environment : args.environment,
						profiler       : args.currentProfiler,
						debuggerConfig : args.debuggerConfig,
						isVisualizer : args.isVisualizer
					},
					prePostExempt : true
				)#
			</cfif>
		</div>

	</div>
</div>
<!--- **************************************************************--->
</cfoutput>
 --->