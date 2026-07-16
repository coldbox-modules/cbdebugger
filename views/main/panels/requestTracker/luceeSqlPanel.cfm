<cfparam name="args.profiler">
<cfparam name="args.debuggerConfig">
<cfparam name="args.debuggerService">
<cfscript>
	totalExecutionTime = numberFormat( args.profiler.cfQueries.totalExecutionTime / 1000000 );
</cfscript>

<cfoutput>
<!--- Panel Component --->
	<div
	id="cbd-luceeSql-panel"
	data-profiler-id="#encodeForHTMLAttribute( args.profiler.id )#"
	x-data="{
		panelOpen : #args.debuggerConfig.luceeSql.expanded ? 'true' : 'false'#,
		queryView : 'none',
		loadedViews : {},
		loadingViews : {},
		switchView( viewType ){
			if( this.queryView === viewType ){
				this.queryView = 'none';
				return;
			}
			this.queryView = viewType;
			if( this.loadedViews[ viewType ] || this.loadingViews[ viewType ] ) return;
			this.loadingViews[ viewType ] = true;
			var self = this;
			var pid = this.$root.dataset.profilerId;
			fetch( this.appUrl + 'cbDebugger/renderLuceeSqlView', {
				method : 'POST',
				headers : { 'x-Requested-With' : 'XMLHttpRequest' },
				body : JSON.stringify({ id : pid, viewType : viewType })
			})
			.then( function( resp ){ return resp.text(); })
			.then( function( html ){
				self.$refs[ 'sqlView-' + viewType ].innerHTML = html;
				self.loadedViews[ viewType ] = true;
				self.loadingViews[ viewType ] = false;
			})
			.catch( function(){
				self.$refs[ 'sqlView-' + viewType ].innerHTML = 'Error loading SQL view';
				self.loadingViews[ viewType ] = false;
			});
		},
		isLoadingSql(){
			return !!this.loadingViews[ this.queryView ];
		}
	}"
>
	<!--- Panel Title --->
	<div
		class="cbd-titles"
		@click="panelOpen=!panelOpen"
	>
		&nbsp;
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
		</svg>
		Lucee Sql

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
		</svg>

		<!--- Count --->
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
		</svg>
		#args.profiler.cfQueries.totalQueries#

		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>
		#totalExecutionTime# ms
	</div>

	<!--- Panel Content --->
	<div
		class="cbd-contentView p20"
		id="cbd-acsqlData"
		x-show="panelOpen"
		x-cloak
		x-transition
	>

		<!--- Info Bar --->
		<div class="cbd-floatRight mr5 mt10 mb10">
			<div>
				<strong>Total Queries:</strong>
				<div class="cbd-badge-light">
					#args.profiler.cfQueries.totalQueries#
				</div>
			</div>

			<div>
				<strong>Total Execution Time:</strong>
				<div class="cbd-badge-light">
					#totalExecutionTime# ms
				</div>
			</div>
		</div>

		<!--- ToolBar --->
		<div class="p10">
			<!--- Grouped --->
			<button
				:class="{ 'cbd-selected' : queryView === 'grouped' }"
				@click="switchView('grouped')"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
				</svg>
				Grouped
			</button>
			<!--- Timeline --->
			<button
				:class="{ 'cbd-selected' : queryView === 'timeline' }"
				@click="switchView('timeline')"
			>
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" />
				</svg>
				Timeline
			</button>
			<!--- Slowest --->
			<button
				:class="{ 'cbd-selected' : queryView === 'slowest' }"
				@click="switchView('slowest')"
			>
				<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
				Slowest
			</button>

			<!--- Loading indicator --->
			<span x-show="isLoadingSql()" x-cloak class="cbd-text-muted" style="margin-left: 10px;">
				Loading...
			</span>
		</div>

		<!--- Are we Enabled --->
		<cfif !getPageContext().getConfig().debug() || !getPageContext().getConfig().hasDebugOptions( 1 )>
			<div>
				<strong>It seems you don't have Lucee debugging enabled, please enable it!</strong>
<pre>
"debuggingDBEnabled":"true",
"debuggingEnabled":"true",
</pre>
			</div>
		</cfif>

		<!--- Query Views (lazy loaded via AJAX) --->
		<cfif args.profiler.cfQueries.totalQueries EQ 0>
			<div class="cbd-text-muted">
				<em>No queries executed</em>
			</div>
		<cfelse>
			<!--- Hint when no view selected --->
			<div
				x-show="queryView === 'none'"
				class="cbd-text-muted mt10"
			>
				<em>Select a view above to load SQL queries</em>
			</div>

			<!--- Grouped Queries Container --->
			<div
				x-show="queryView === 'grouped'"
				x-transition
				x-ref="sqlView-grouped"
			></div>

			<!--- Timeline Queries Container --->
			<div
				x-show="queryView === 'timeline'"
				x-transition
				x-ref="sqlView-timeline"
			></div>

			<!--- Slowest Queries Container --->
			<div
				x-show="queryView === 'slowest'"
				x-transition
				x-ref="sqlView-slowest"
			></div>
		</cfif>
	</div>

</div>
<!--- End acfsql component --->
</cfoutput>
