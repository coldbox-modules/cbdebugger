<cfoutput>
<div class="row">
	<div class="mb-5">
		<a href="/cbdebugger" class="btn btn-primary btn-lg px-4" target="_blank">
			<i class="bi bi-activity"></i>
			Open Request Tracker
		</a>
	</div>
</div>

<div class="row g-5">
	<div class="col-md-6">
		<h2 class="text-body-emphasis">Debugging Events</h2>
		<p>
			Use the links below to generate debugging data
		</p>
		<ul class="list-unstyled ps-0">
			<li>
				<a class="icon-link mb-1"
					href="#event.buildLink( 'main.embedded' )#"
					rel="noopener" target="_blank">
					<i class="bi bi-arrow-right-circle-fill"></i>
					Alpine Embedded Test
				</a>
			</li>
			<li>
				<a class="icon-link mb-1" href="#event.buildLink( 'main.noDebugger' )#"
					rel="noopener" target="_blank">
					<i class="bi bi-arrow-right-circle-fill"></i>
					No Debugger
				</a>
			</li>
			<li>
				<a class="icon-link mb-1" href="#event.buildLink( 'main.error' )#"
					rel="noopener" target="_blank">
					<i class="bi bi-arrow-right-circle-fill"></i>
					Produce an Error
				</a>
			</li>
			<li>
				<a class="icon-link mb-1" href="#event.buildLink( 'main.hyperData1' )#"
					rel="noopener" target="_blank">
					<i class="bi bi-arrow-right-circle-fill"></i>
					Hyper Data 1
				</a>
			</li>
			<li>
				<a class="icon-link mb-1" href="#event.buildLink( 'main.hyperData2' )#"
					rel="noopener" target="_blank">
					<i class="bi bi-arrow-right-circle-fill"></i>
					Hyper Data 2
				</a>
			</li>
			<li>
				<a class="icon-link mb-1" href="#event.buildLink( 'main.data' )#"
					rel="noopener" target="_blank">
					<i class="bi bi-arrow-right-circle-fill"></i>
					API Data
				</a>
			</li>
		</ul>
	</div>
</div>
</cfoutput>
