export default ( isExpanded, refreshFrequency, hasReinitPassword, isVisualizer ) => {
	return {
		panelOpen           : isExpanded,
		refreshFrequency    : refreshFrequency,
		usingReinitPassword : hasReinitPassword,
		isVisualizer        : isVisualizer,
		currentProfileId    : "",

		reinitFramework(){
			this.$refs.reinitLoader.classList.add( "cbd-spinner" );
			let reinitPass = this.usingReinitPassword ? prompt( "Reinit Password?" ) : "1";
			fetch( `${this.appUrl}?fwreinit=${reinitPass}`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
				.then( response => {
					if ( response.ok ){
						alert( "Framework Reinitted!" );
						this.refreshProfilers();
					} else {
						alert( "HTTP Call Error" + response.status );
					}
					this.$refs.reinitLoader.classList.remove( "cbd-spinner" );
				} );
		},
		loadProfilerReport( id ){
			fetch( `${this.appUrl}cbDebugger/renderProfilerReport`, {
				method  : "POST",
				headers : { "x-Requested-With": "XMLHttpRequest" },
				body    : JSON.stringify( {
					id           : id,
					isVisualizer : this.isVisualizer
				} )
			} )
				.then( response => response.text() )
				.then( html => {
					history.pushState( { profileId: id }, null, "##" + id );
					this.$refs[ "cbd-profilers" ].innerHTML = html;
					coldboxDebugger.scrollTo( "cbd-request-tracker" );
				} );
		},
		clearState(){
			history.pushState( {}, null, "##" );
			this.currentProfileId = "";
		},
		refreshProfilers(){
			this.$refs.refreshLoader.classList.add( "cbd-spinner" );
			fetch( `${this.appUrl}cbDebugger/renderProfilers`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
				.then( response => response.text() )
				.then( html => {
					this.clearState();
					this.$refs[ "cbd-profilers" ].innerHTML = html;
					this.$refs.refreshLoader.classList.remove( "cbd-spinner" );
				} );
		},
		clearProfilers(){
			this.$refs.clearLoader.classList.add( "cbd-spinner" );
			fetch( `${this.appUrl}cbDebugger/clearProfilers`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
				.then( response => response.json() )
				.then( data => {
					this.clearState();
					if ( data.error ){
						alert( data.messages.toString() );
					} else {
						this.refreshProfilers();
					}
					this.$refs.clearLoader.classList.remove( "cbd-spinner" );
				} );
		},
		stopDebuggerMonitor(){
			if ( "cbdRefreshMonitor" in window ){
				clearInterval( window.cbdRefreshMonitor );
				console.log( "Stopped ColdBox Debugger Profiler Refresh" );
			}
		},
		startDebuggerMonitor( frequency ){
			if ( frequency == 0 ){
				return this.stopDebuggerMonitor();
			}
			window.cbdRefreshMonitor = setInterval( this.refreshProfilers, frequency * 1000 );
			console.log( "Started ColdBox Debugger Profiler Refresh using " + frequency + " seconds" );
		},
		init(){
			window.addEventListener( "popstate", e => {
				if ( e.state && e.state.profileId ){
					this.currentProfileId = e.state.profileId;
					this.loadProfilerReport( e.state.profileId );
				} else {
					this.refreshProfilers();
				}
			} );
			// Detect if an incoming profile id hash is detected
			if ( location.hash ){
				this.currentProfileId = location.hash.substr( 1 );
				this.loadProfilerReport( this.currentProfileId );
			}
		}
	};
};
