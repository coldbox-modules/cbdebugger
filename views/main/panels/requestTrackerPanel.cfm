<!--- Included by the debugger.cfm --->
<cfoutput>
<div
	id="cbd-request-tracker"
	x-data = "cbdRequestTrackerPanel(
		#args.debuggerConfig.requestTracker.expanded ? 'true' : 'false'#,
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
				ColdBox Request Tracker

				<!--- If not expanded and not in visualizer mode --->
				<cfif !args.currentProfiler.isEmpty()>
					<span
						x-show="!panelOpen && !isVisualizer"
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

			<!--- ************************************************ --->
			<!--- Global Toolbar --->
			<!--- ************************************************ --->

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

			<!--- Turn Debugger Off --->
			<button
				title="Turn the ColdBox Debugger Off"
				onClick="window.location='#args.urlBase#?debugmode=false'"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
				</svg>
			</button>
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
