component accessors=true{

    property name="javaloader" inject="loader@cbjavaloader";
    property name="filesystem" inject="FileSystem";
    property name="systeminfo";
    property name="hardware";
    property name="platform";
    property name="os";

    // byte units
    variables.TB = 1024 * 1024 * 1024 * 1024;
    variables.GB = 1024 * 1024 * 1024;
    variables.MB = 1024 * 1024;
    variables.KB = 1024;

    function init(){
        return this;
    }

    function onDIComplete(){
		javaloader.appendPaths( filesystem.resolvePath( 'lib' ) );
        var si = javaloader.create('oshi.SystemInfo' );
        var hal = si.getHardware();
        var platform = si.getCurrentPlatform();
        var os = si.getOperatingSystem();

        this.setSystemInfo(si);
        this.setHardware(hal);
        this.setPlatform(platform);
        this.setOS(os);
        return this;
    }

    function getProcessList(){
        var totalRam = getHardware().getMemory().getTotal();
        return getOS().getProcesses().filter( (p)=>p.getProcessID()>0 )
                .reduce((acc,p,idx)=>{
                    try{

                        var threads = [
                            "PID": p.getProcessID(),
                            "Name": p.getName(),
                            //"ev": p.getEnvironmentVariables().toString(),
                            "CWD":p.getCurrentWorkingDirectory(),
                            "CPU %": round(p.getProcessCpuLoadCumulative() * 100) & '%',
                            "MEM %": (round(p.getResidentSetSize()*100/totalRam)) & '%',
                            //"Folder": listLast(p.getCurrentWorkingDirectory(),'/\x'),
                            "State": p.getState().toString(),
                            "Disk R/W": "(" & getSize(p.getBytesRead()) & "/" & getSize(p.getBytesWritten()) &")"
                        ];
                        acc.append(threads);
                    } catch (any e){

                    }
                    return acc;
                },[]).sort((a,b)=>{
                    var key = "CPU %";
                    return replace(b[key],"%","","All") - replace(a[key],"%","","All")
                })
    }

    function getNetwork() {
        var internetProtocolStats = getOS().getInternetProtocolStats();
        var tcp4 = internetProtocolStats.getTCPv4Stats();
        var tcp6 = internetProtocolStats.getTCPv6Stats();
        return {
            'tcp4_send': getSize(tcp4.getSegmentsSent()),
            'tcp4_recieve': getSize(tcp4.getSegmentsReceived()),
            'tcp6_send': getSize(tcp6.getSegmentsSent()),
            'tcp6_recieve': getSize(tcp6.getSegmentsReceived())
        };
    }

    function getCpu(processor) {
        var cpuInfo = [=];
        var processor = variables.getHardware().getPRocessor();
        cpuInfo["name"]= processor.getProcessorIdentifier().getName();
        //cpuInfo["package"]= processor.getPhysicalPackageCount();
        //cpuInfo["core"]= processor.getPhysicalProcessorCount();
        cpuInfo["coreNumber"]= processor.getPhysicalProcessorCount();
       // cpuInfo["logic"]= processor.getLogicalProcessorCount();
        var prevTicks = processor.getSystemCpuLoadTicks();
        sleep(1000);
        var ticks = processor.getSystemCpuLoadTicks();
        var user =      ticks[1] - prevTicks[1];
        var nice =      ticks[2] - prevTicks[2];
        var sys =       ticks[3] - prevTicks[3];
        var idle =      ticks[4] - prevTicks[4];
        var iowait =    ticks[5] - prevTicks[5];
        var irq =       ticks[6] - prevTicks[6];
        var softirq =   ticks[7] - prevTicks[7];
        var steal =     ticks[8] - prevTicks[8];
        var totalCpu = user + nice + sys + idle + iowait + irq + softirq + steal;
        cpuInfo["used"] = decimalFormat((100 * user / totalCpu) + (100 * sys / totalCpu));
        cpuInfo["idle"] = decimalFormat((100 * idle / totalCpu));
        return cpuInfo;
    }

    function getService(os) {
        // DO 5 each of running and stopped
        var i = 0;
        var services = [];
        var service_list = os.getServices();
        for (var i=1; i<=15; i++) {
            var s = service_list[i];
            services.append({
                'pid': s.getProcessID(),
                'name': s.getName(),
                'state': s.getState().toString()
            });
        }
        return services;
    }

    function getCores(required coreid){
       var prevTicks =  getHardware().getProcessor().getProcessorCpuLoadTicks();
       sleep(1000);
       var ticks =  getHardware().getProcessor().getProcessorCpuLoadTicks();
       return arrayReduce(prevTicks,(acc,prevTick,idx)=>{
            var cpuInfo = [=];
            var user =      ticks[idx][1] - prevTick[1];
            var nice =      ticks[idx][2] - prevTick[2];
            var sys =       ticks[idx][3] - prevTick[3];
            var idle =      ticks[idx][4] - prevTick[4];
            var iowait =    ticks[idx][5] - prevTick[5];
            var irq =       ticks[idx][6] - prevTick[6];
            var softirq =   ticks[idx][7] - prevTick[7];
            var steal =     ticks[idx][8] - prevTick[8];
            var totalCpu = user + nice + sys + idle + iowait + irq + softirq + steal;
            cpuInfo["name"] = "Core #idx#";
            cpuInfo["used"] = decimalFormat((100 * user / totalCpu) + (100 * sys / totalCpu));
            cpuInfo["idle"] = decimalFormat((100 * idle / totalCpu));
            acc.append(cpuInfo);
            return acc;
       },[])[coreid];

    }

    function getMemory() {
        var memoryInfo = {};
        var memory = variables.getHardware().getMemory();
        memoryInfo["total"] = getSize(memory.getTotal());
        memoryInfo["available"] = getSize(memory.getAvailable());
        memoryInfo["used"] = getSize(memory.getTotal() - memory.getAvailable());
        memoryInfo["usageRate"] = decimalFormat((memory.getTotal() - memory.getAvailable())/memory.getTotal() * 100);
        return memoryInfo;
    }

    function getDisk(os) {
        var fileSystem = variables.getOS().getFileSystem();
        var fsArray = fileSystem.getFileStores();
        return fsArray.filter((fs)=>{ return fs.getMount() == 'C:\' || fs.getMount() == '/'})
            .reduce((acc,fs)=>{

            var diskInfo = {};
            var available = fs.getUsableSpace();
            var total = fs.getTotalSpace();
            var used = total - available;
            diskInfo["Directory Name"] = fs.getMount();
            diskInfo["Name"] = fs.getName();
            diskInfo["Total Space"] = total > 0 ? getSize(total) : "?";
            diskInfo["Free Space"] = getSize(available);
            diskInfo["Used Space"] = getSize(used);
            if(total != 0){
                diskInfo["Used"] = decimalFormat(used/total * 100) & '%';
            } else {
                diskInfo["Used"]=  0 & '%';
            }
            acc[fs.name] = diskInfo;
            return acc;
        },{})
    }

    private function getSize(size) {
        var resultSize = "";
        if (size / TB >= 1) {
            resultSize = decimalFormat(size / TB) & "TB";
        } else if (size / GB >= 1) {
            resultSize = decimalFormat(size / GB) & "GB";
        } else if (size / MB >= 1) {
            //1MB
            resultSize = decimalFormat(size /  MB) & "MB";
        } else if (size / KB >= 1) {
            //1KB
            resultSize = decimalFormat(size / KB) & "KB";
        } else {
            resultSize = size & "B";
        }
        return resultSize;
    }



}