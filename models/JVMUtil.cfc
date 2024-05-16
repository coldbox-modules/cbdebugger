component singleton {

	/**
	 * Get the current request's thread stack
	 */
	array function getThreadInfo(){
		// Get the ThreadMXBean instance
		var threadMXBean = createObject( "java", "java.lang.management.ManagementFactory" ).getThreadMXBean();
		// Set the option to include locked monitors and synchronizers
		threadMXBean.setThreadContentionMonitoringEnabled( true );
		// Get the thread information for each thread ID
		var threadInfo = [];
		return threadInfo.append(
			threadMXBean.getThreadInfo(
				threadMXBean.getAllThreadIds(),
				createObject( "java", "java.lang.Integer" ).MAX_VALUE
			),
			true
		);
	}

	/**
	 * Generate a heap dump and store it at the given directory path
	 * The generated heap dump will be named with the following pattern: <pre>cbdebugger-heapdump-mmm-dd-yyyy_HHnnss_l.hprof</pre>
	 *
	 * @directoryPath The directory path to store the heap dump, must be absolute. Defaults to the temporary directory
	 *
	 * @return The absolute path to the generated heap dump
	 */
	string function generateHeapDump( directoryPath = getTempDirectory() ){
		// Create it if it doesn't exist
		if ( !directoryExists( arguments.directoryPath ) ) {
			directoryCreate( arguments.directoryPath );
		}

		// Get the HotSpotDiagnosticMXBean instance
		var ManagementFactory            = createObject( "java", "java.lang.management.ManagementFactory" );
		var HotSpotDiagnosticMXBeanClass = createObject( "java", "com.sun.management.HotSpotDiagnosticMXBean" ).getClass();
		var mBeanServer                  = ManagementFactory.getPlatformMBeanServer();
		var dumpFilePath                 = arguments.directoryPath & "/cbdebugger-heapdump-#dateTimeFormat( now(), "mmm-dd-yyyy_HHnnss_l" )#.hprof";

		ManagementFactory
			.newPlatformMXBeanProxy(
				mBeanServer,
				"com.sun.management:type=HotSpotDiagnostic",
				HotSpotDiagnosticMXBeanClass
			)
			.dumpHeap( dumpFilePath, javacast( "boolean", true ) );

		return dumpFilePath;
	}

}
