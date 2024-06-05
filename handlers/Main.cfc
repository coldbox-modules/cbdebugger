/**
 * Main ColdBox Debugger Visualizer Handler
 */
component extends="coldbox.system.RestHandler" {

	// DI
	property name="debuggerService" inject="debuggerService@cbdebugger";
	property name="timerService"    inject="timer@cbdebugger";
	property name="debuggerConfig"  inject="coldbox:modulesettings:cbdebugger";

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Global params
		event.paramValue( "frequency", 0 ).paramValue( "isVisualizer", false );

		// Don't show cf debug on ajax calls
		if ( event.isAjax() ) {
			setting showdebugoutput=false;
		}

		// If not enabled, just 404 it
		if ( !variables.debuggerService.getDebugMode() || !variables.debuggerConfig.enabled ) {
			event.overrideEvent( "cbdebugger:main.disabled" );
		}
	}

	/**
	 * Debugger disabled event
	 */
	function disabled( event, rc, prc ){
		event.renderData(
			statusCode = 404,
			statusText = "Not Found",
			type       = "text",
			data       = "Page Not Found"
		);
	}

	/**
	 * Visualize the request tracker
	 */
	any function index( event, rc, prc ){
		paramSorting( rc );
		return renderDebugger( argumentCollection = arguments );
	}

	function renderRequestPanelDock( event, rc, prc ){
		// Return the debugger layout+view
		// We pass in all the variables needed, to avoid prc/rc conflicts
		try {
			return layout(
				layout    : "Dock",
				module    : "cbdebugger",
				view      : "main/panels/requestTrackerPanel",
				viewModule: "cbdebugger",
				args      : {
					// Get the current profiler for the current request. Basically the first in the stack
					currentProfiler : variables.debuggerService.getCurrentProfiler(),
					// Module Config
					debuggerConfig  : variables.debuggerConfig,
					// Service pointer
					debuggerService : variables.debuggerService,
					// When debugging starts
					debugStartTime  : getTickCount(),
					// Env struct
					environment     : variables.debuggerService.getEnvironment(),
					// Manifest Root
					manifestRoot    : event.getModuleRoot( "cbDebugger" ) & "/includes",
					// Module Root
					moduleRoot      : event.getModuleRoot( "cbDebugger" ),
					// All Module Settings
					moduleSettings  : getSetting( "modules" ),
					// Profilers storage to display
					profilers       : variables.debuggerService.getProfilerStorage(),
					// Url build base
					urlBase         : event.buildLink( "" )
				}
			);
		} catch ( any e ) {
			writeDump( var = e, top = 5 );
			abort;
		}
	}

	/**
	 * This action renders out the debugger back to the caller as HTML widget
	 */
	function renderDebugger( event, rc, prc ){
		// are we in visualizer mode?
		var isVisualizer       = event.getCurrentEvent() eq "cbdebugger:main.index";
		setting showdebugoutput=false;
		// Return the debugger layout+view
		// We pass in all the variables needed, to avoid prc/rc conflicts
		try {
			return layout(
				layout    : isVisualizer ? "Visualizer" : "Dock",
				module    : "cbdebugger",
				view      : "main/debugger",
				viewModule: "cbdebugger",
				args      : {
					// Get the current profiler for the current request. Basically the first in the stack
					currentProfiler  : variables.debuggerService.getCurrentProfiler(),
					// Module Config
					debuggerConfig   : variables.debuggerConfig,
					// Service pointer
					debuggerService  : variables.debuggerService,
					// When debugging starts
					debugStartTime   : getTickCount(),
					// Env struct
					environment      : variables.debuggerService.getEnvironment(),
					// Visualizer mode or panel at bottom mode
					isVisualizer     : isVisualizer,
					// Manifest Root
					manifestRoot     : event.getModuleRoot( "cbDebugger" ) & "/includes",
					// Module Root
					moduleRoot       : event.getModuleRoot( "cbDebugger" ),
					// All Module Settings
					moduleSettings   : getSetting( "modules" ),
					// Rendering page title
					pageTitle        : "ColdBox Debugger",
					// Profilers storage to display
					profilers        : variables.debuggerService.getProfilerStorage(),
					// Incoming frequency if in visualizer mode
					refreshFrequency : rc.frequency,
					// Url build base
					urlBase          : event.buildLink( "" )
				}
			);
		} catch ( any e ) {
			writeDump( var = e, top = 5 );
			abort;
		}
	}

	/**
	 * Download a heapdump snapshot
	 */
	function heapDump( event, rc, prc ){
		event.sendFile( file: getInstance( "JVMUtil@cbdebugger" ).generateHeapDump(), deleteFile: true );
	}

	/**
	 * This action renders out the caching panel only
	 */
	function renderCacheMonitor( event, rc, prc ){
		return view(
			view  : "main/panels/cacheBoxPanel",
			module: "cbdebugger",
			args  : { debuggerConfig : variables.debuggerConfig }
		);
	}

	/**
	 * Clear the profilers via ajax
	 */
	function clearProfilers( event, rc, prc ){
		variables.debuggerService.resetProfilers();
		event.getResponse().addMessage( "Profilers reset!" );
	}

	/**
	 * Clear the profilers via ajax
	 */
	function clearEvents( event, rc, prc ){
		variables.debuggerService.resetEvents();
		event.getResponse().addMessage( "Events reset!" );
	}

	/**
	 * Get the profilers via ajax
	 */
	function renderProfilers( event, rc, prc ){
		return paramSorting( rc ).view(
			view  : "main/partials/profilers",
			module: "cbdebugger",
			args  : {
				environment    : variables.debuggerService.getEnvironment(),
				profilers      : variables.debuggerService.getProfilers( rc.sortBy, rc.sortOrder ),
				debuggerConfig : variables.debuggerConfig
			},
			prePostExempt: true
		);
	}

	/**
	 * Get a profiler report via ajax
	 */
	function renderProfilerReport( event, rc, prc ){
		var profilerReport = variables.debuggerService.getProfilerById( rc.id );

		if ( profilerReport.isEmpty() ) {
			return "<h3 class='cbd-text-red cbd-bg-light-red'>Profiler Id: #encodeForHTML( rc.id )# doesn't exist</h3>";
		}

		return view(
			view  : "main/partials/profilerReport",
			module: "cbdebugger",
			args  : {
				debuggerService : variables.debuggerService,
				environment     : variables.debuggerService.getEnvironment(),
				profiler        : profilerReport,
				debuggerConfig  : variables.debuggerConfig,
				isVisualizer    : rc.isVisualizer
			},
			prePostExempt: true
		);
	}

	/**
	 * Get a profiler report via ajax
	 */
	function getDebuggerRequests( event, rc, prc ){
		var requestIndex = variables.debuggerService.getEvents(  )
		.filter((row)=> {return row.eventType == 'request'})
		.map((row)=>{
			var temp = duplicate(row);
			temp['time'] = timeFormat(temp.timestamp,'HH:mm:ss tt');
			temp['statusCode'] = temp.extraInfo.response.statusCode;
			temp.delete('extraInfo');
			temp['stats'] = variables.debuggerService.getEvents(  )
			.filter((row)=> {return row.transactionId == temp.transactionId})
			.reduce((acc,row)=>{
				if(!acc.keyExists(row.eventType)) acc[row.eventType] = {
					"count": 0,
					"first": row.timestamp,
					"last": row.timestamp,
					"duration": 0
				};
				acc[row.eventType].count++;
				acc[row.eventType].last = timeformat(max(acc[row.eventType].last,row.timestamp  + row.executionTimeMillis),'hh:mm:ss tt');
				acc[row.eventType].first = timeformat(min(acc[row.eventType].first,row.timestamp),'hh:mm:ss tt');
				acc[row.eventType].duration += row.executionTimeMillis;
				return acc;
			},{})
			return temp;
		});
		arguments.event.getResponse().setData( requestIndex );
	}

	/**
	 * Get a profiler report via ajax
	 */
	function getDebuggerEvents( event, rc, prc ){
		var transactionEvents = variables.debuggerService.getEvents(  );
		if(rc.keyExists('id')){
			transactionEvents = transactionEvents.filter((row)=> {return row.transactionId == rc.id  })
		}
		else if (rc.keyExists('type')) {
			transactionEvents = transactionEvents
				.filter((row)=> {return row.eventType == rc.type  })
				.sort((a,b)=>{
					if(rc.sortDir == 'asc'){
						return a[rc.sortKey] - b[rc.sortKey];
					}
					return b[rc.sortKey] - a[rc.sortKey];
				})
				.filter((row,idx)=> {return idx < 10  })

		}
		transactionEvents = transactionEvents.map((row)=>{
			row['linkToFile'] = '';
			if(row.keyExists('extraInfo') && row.extraInfo.keyExists('caller')){
				row['linkToFile'] = variables.debuggerService.openInEditorURL(event,row.extraInfo.caller);
			}
			return row;
		})
		arguments.event.getResponse().setData( transactionEvents );
	}


	/**
	 * Get a profiler report via ajax
	 */
	function getDebuggerRequestEvents( event, rc, prc ){
		var transactionEvents = variables.debuggerService.getEvents(  )
					.filter((row)=> {return row.eventType == 'request'  });

		 if (rc.keyExists('type')) {
			transactionEvents = transactionEvents
				.filter((row)=> {return row.extraInfo.response.statusCode == rc.type  })

		}
		transactionEvents = transactionEvents.map((row)=>{
			var temp = duplicate(row);
			temp['time'] = timeFormat(temp.timestamp,'HH:mm:ss tt');
			temp['statusCode'] = temp.extraInfo.response.statusCode;
			temp['method'] = temp.extraInfo.requestData.method;
			temp.delete('extraInfo');
			return temp;
		})
		.reduce((acc,row)=>{
			if(!acc.keyExists(row.details)) {
				acc[row.details] = duplicate(row);
				acc[row.details]['count'] = 0;
			}
			acc[row.details]['count']++;
			return acc;
		},{})

		transactionEvents = StructValueArray(transactionEvents)
		.sort((a,b)=>{
			if(rc.sortDir == 'asc'){
				return a[rc.sortKey] - b[rc.sortKey];
			}
			return b[rc.sortKey] - a[rc.sortKey];
		})
		.filter((row,idx)=> {return idx < 10  })
		arguments.event.getResponse().setData( transactionEvents );
	}

	/**
	 * Get a scheduled task report via ajax
	 */
	function getJVMReport( event, rc, prc ){

			var runtime    = createObject( "java", "java.lang.Runtime" ).getRuntime();
			var ManagementFactory            = createObject( "java", "java.lang.management.ManagementFactory" );
			var osBean = ManagementFactory.getOperatingSystemMXBean();
			var memoryBean = ManagementFactory.getMemoryMXBean();
			var heapMemory = memoryBean.getHeapMemoryUsage();
			var nonHeapMemory = memoryBean.getNonHeapMemoryUsage();

			// JVM Data
			var JVMRuntime     = runtime.getRuntime();
			var JVMFreeMemory  = JVMRuntime.freeMemory() / 1024;
			var JVMTotalMemory = JVMRuntime.totalMemory() / 1024;
			var JVMMaxMemory   = JVMRuntime.maxMemory() / 1024;

			event.getResponse().setData( {
				"JVM": {
					"freeMemory": JVMFreeMemory,
					"totalMemory": JVMTotalMemory,
					"maxMemory": JVMMaxMemory,
					"usedMemory": (JVMTotalMemory - JVMFreeMemory),
					"processors": runtime.availableProcessors(),
					"heapMemory" = {
						"init" = heapMemory.getInit(),
						"used" = heapMemory.getUsed(),
						"committed" = heapMemory.getCommitted(),
						"max" = heapMemory.getMax()
					},
					"nonHeapMemory" = {
						"init" = nonHeapMemory.getInit(),
						"used" = nonHeapMemory.getUsed(),
						"committed" = nonHeapMemory.getCommitted(),
						"max" = nonHeapMemory.getMax()
					}
				}
			} );

			/* stats = {
				"getName" = osBean.getName(),
				"getVersion" = osBean.getVersion(),
				"getArch" = osBean.getArch(),
				"availableProcessors" = osBean.getAvailableProcessors(),
				"systemLoadAverage"   = osBean.getSystemLoadAverage(),
				"heapMemory" = {
					"init" = heapMemory.getInit(),
					"used" = heapMemory.getUsed(),
					"committed" = heapMemory.getCommitted(),
					"max" = heapMemory.getMax()
				},
				"nonHeapMemory" = {
					"init" = nonHeapMemory.getInit(),
					"used" = nonHeapMemory.getUsed(),
					"committed" = nonHeapMemory.getCommitted(),
					"max" = nonHeapMemory.getMax()
				}
			}; */

	}
	function getCacheReport( event, rc, prc ){
		//dump(cacheBox.getCache('default').getStats().getCacheProvider()); abort;
		var cacheInfo = {
				"names" : cacheBox.getCacheNames(),
				"registration": cacheBox.getScopeRegistration(),
				"id": cacheBox.getFactoryID(),
				"stats": {}
		};
		cacheInfo.names.each( function( name ) {
			var cacheProvider = cacheBox.getCache( name );
			// Cache Data

			var cacheStats	   = cacheProvider.getStats();
			var cacheMetadata    = cacheProvider.getStoreMetadataReport();
			var cacheMDKeyLookup = cacheProvider.getStoreMetadataKeyMap();
			var cacheKeys        = cacheProvider.getKeys();


			cacheInfo.stats[name] = {
				"config": cacheProvider.getConfiguration(),
				"size": cacheProvider.getSize(),
				"hits": cacheStats.getHits(),
				"misses": cacheStats.getMisses(),
				"evictions": cacheStats.getEvictionCount(),
				"lastReap": cacheStats.getLastReapDateTime(),
				"gcCount": cacheStats.getGarbageCollections(),
				"performanceRatio": cacheStats.getCachePerformanceRatio(),
				"cacheMetadata": cacheMetadata,
				"cacheMDKeyLookup": cacheMDKeyLookup,
				"cacheKeys": cacheKeys
			};
		} );
		event.getResponse().setData( cacheInfo );

	}

	function buildDependencyTree ( modules, moduleLibrary ){
		var base = [];
		modules.each(( moduleName ) => {
			var moduleInstance = moduleLibrary[moduleName];
			var moduleInfo = {
				"name": moduleName,
				"outdated": false,
				"version": moduleInstance.version,
				"activate": moduleInstance.activate,
				"activated": moduleInstance.activated,
				"activationTime": moduleInstance.activationTime,
				"loadTime": moduleInstance.loadTime,
				"cfMapping": moduleInstance.cfMapping,
				"interceptors": moduleInstance.interceptors,
				"path": moduleInstance.path,
				"settings": variables.debuggerService.makeCollectionSafe(moduleInstance.settings),
				"parent": moduleInstance.parent,
				"disabled": moduleInstance.disabled,
				"entryPoint": moduleInstance.entryPoint,
				"author": moduleInstance.author,
				"aliases": moduleInstance.aliases,
				"autoMapModels": moduleInstance.autoMapModels,
				"autoProcessModels": moduleInstance.autoProcessModels,
				"dependencies": buildDependencyTree( moduleInstance.DEPENDENCIES, moduleLibrary)
			};
			var endpoint = 'https://www.forgebox.io/api/v1/entry/#moduleInfo.name#/latest';
			try {
				cfhttp (url = endpoint	method = "get",	result = "result", timeout="30" cachedWithin="#createTimespan(1,0,0,0)#");
				if(result.status_code == 200){
					var forgeboxInfo = deserializeJSON(result.fileContent).data;
					moduleInfo['forgebox'] = {
						"version": forgeboxinfo.version,
						"installs": forgeboxinfo.installs,
						"updatedDate": forgeboxinfo.updatedDate,
						"publisher": forgeboxinfo.publisher,
						"downloadURL": forgeboxinfo.downloadURL
					};
					if(forgeboxInfo.version != moduleInfo.version){
						moduleInfo['outdated'] = true;
					}
				}
			} catch (any e) {
				moduleInfo['forgebox'] = {
					"error": e.message
				};
			}
			base.append( moduleInfo );
		} );
		return base;
	}

	function getModuleReport( event, rc, prc ){
		var modules = getSetting( "modules" );
		var rootModules = modules.reduce( function( acc, moduleName, module ) {
			if(module.parent == "") acc.append(moduleName);
			return acc;
		},[] );
		var moduleTree = buildDependencyTree( rootModules, modules );
		event.getResponse().setData( moduleTree );

	}
	function getScheduledTaskReport( event, rc, prc ){
		var tasks = [];
		var rootTasks = wirebox.getInstance( "appScheduler@coldbox" ).getTasks();
		rootTasks.each( function( key, value ) {
			value[ "module" ] = "";
			tasks.append( value );
		} );

		// get all loaded modules
		var loadedModules = controller.getModuleService().getLoadedModules();

		// loop through each loaded module, if the cbscheduler mapping exists, get it.
		loadedModules.each( function( item, index ) {

			if ( wirebox.getBinder().mappingExists( "cbScheduler@#item#" ) ) {
				var scheduler = wirebox.getInstance( "cbScheduler@#item#" ).getTasks();
				scheduler.each( function( key, taskConfig ) {
					var stats = taskConfig.task.getStats();
					tasks.append({
						"name": stats.name,
						"lastRun": stats.lastRun,
						"nextRun": stats.nextRun,
						"totalRuns": stats.totalRuns,
						"totalFailures": stats.totalFailures,
						"totalSuccess": stats.totalSuccess,
						"lastResult": stats.lastResult.toString(),
						"lastExecutionTime": stats.lastExecutionTime,
						"registeredAt": taskConfig.registeredAt,
						"scheduledAt": taskConfig.scheduledAt,
						"disabled": taskConfig.disabled,
						"error": taskConfig.error,
						"errorMessage": taskConfig.errorMessage,
						"inetHost": taskConfig.inetHost,
						"localIp": taskConfig.localIp,
						"module": taskConfig.module ?: 'core'
					});
				} );
			};

		} );
		event.getResponse().setData( tasks );
	}

	/**
	 * Get a profiler report via ajax
	 */
	function getDebuggerConfig( event, rc, prc ){
		arguments.event.getResponse().setData( variables.debuggerConfig );
	}

	/**
	 * Export a profiler report as json
	 */
	function exportProfilerReport( event, rc, prc ){
		return variables.debuggerService.getProfilerById( rc.id );
	}

	/**
	 * Unload a module
	 */
	function unloadModule( event, rc, prc ){
		event.paramValue( "module", "" );
		// variables.controller.getModuleService().unload( rc.module );
		event.getResponse().addMessage( "Module #rc.module# Unloaded!" );
	}

	/**
	 * Reload a module
	 */
	function reloadModule( event, rc, prc ){
		event.paramValue( "module", "" );
		variables.controller.getModuleService().reload( rc.module );
		event.getResponse().addMessage( "Module #rc.module# reloaded!" );
	}

	/**
	 * Get runtime environment
	 */
	function environment( event, rc, prc ){
		event.getResponse().setData( variables.debuggerService.getEnvironment() );
	}

	// ################################################# PRIVATE ######################################################//

	/**
	 * Internal param sorting defaults
	 */
	private function paramSorting( rc ){
		param rc.sortBy    = "timestamp";
		param rc.sortOrder = "desc";
		if ( !len( rc.sortBy ) ) {
			rc.sortby = "timestamp";
		}
		if ( !len( rc.sortOrder ) ) {
			rc.sortOrder = "desc";
		}
		return this;
	}

}
