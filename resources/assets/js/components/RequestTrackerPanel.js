export default ( isExpanded, refreshFrequency, hasReinitPassword, isVisualizer ) => {
	return {
		panelOpen           : isExpanded,
		refreshFrequency    : refreshFrequency,
		usingReinitPassword : hasReinitPassword,
		isVisualizer        : isVisualizer,
		currentProfileId    : "",
		refreshMonitor      : null,

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
			this.stopDebuggerMonitor();
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
					history.pushState( { profileId: id }, null, "#" + id );
					this.$refs[ "cbd-profilers" ].innerHTML = html;
					coldboxDebugger.scrollTo( "cbd-request-tracker" );
				} );
		},

		clearState(){
			history.pushState( {}, null, "#" );
			this.currentProfileId = "";
		},

		refreshProfilers( sortBy = '', sortOrder = '' ){
			this.$refs.refreshLoader.classList.add( "cbd-spinner" );
			fetch(
				`${this.appUrl}cbDebugger/renderProfilers?sortBy=${sortBy}&sortOrder=${sortOrder}`,
				{ headers: { "x-Requested-With": "XMLHttpRequest" } }
			)
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
			// stop only if loaded
			if ( this.refreshMonitor != null ){
				clearInterval( this.refreshMonitor );
				this.refreshFrequency = 0;
				console.info( "Stopped ColdBox Debugger Profiler Refresh" );
			}
		},

		startDebuggerMonitor( frequency ){
			// Ensure monitor is stopped just in case we are switching frequencies
			this.stopDebuggerMonitor();
			this.refreshFrequency = frequency;
			if ( this.refreshFrequency == 0 ){
				return;
			}
			this.refreshMonitor = setInterval( () => this.refreshProfilers(), this.refreshFrequency * 1000 );
			console.info( "Started ColdBox Debugger Profiler Refresh using " + this.refreshFrequency + " seconds" );
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
