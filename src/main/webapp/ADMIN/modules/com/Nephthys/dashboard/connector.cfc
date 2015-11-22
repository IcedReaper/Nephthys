component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.Nephthys.dashboard';
    }
    
    public boolean function checkPermission(required user user) {
        return true;
    }
    
    public void function render() {
        var qHeapMemory = getMemoryUsage('heap');
        var totalHeapMemory = 0;
        var totalUsedMemory = 0;
        for(var i = 1; i <= qHeapMemory.getRecordCount(); i++) {
            totalHeapMemory += qHeapMemory.max[i];
            totalUsedMemory += qHeapMemory.used[i];
        }
        
        // from bytes to megabytes
        totalHeapMemory = ceiling(totalHeapMemory / (1024 * 1024));
        totalUsedMemory = ceiling(totalUsedMemory / (1024 * 1024));
        
        var memory = {
            total          = totalHeapMemory,
            used           = totalUsedMemory,
            percentageUsed = ceiling((totalUsedMemory / totalHeapMemory) * 100)
        };
        
        module template     = "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/dashboard/templates/index.cfm"
               serverStatus = createObject("component", "API.com.Nephthys.classes.system.settings").init()
               memory       = memory;
    }
    
    public void function sidebar() {
        var moduleCtrl = createObject("component", "API.com.Nephthys.controller.modules.overview").init();
        var installedModules = moduleCtrl.getList();
        
        for(var i = 1; i <= installedModules.len(); i++) {
            if(! installedModules[i].getActiveStatus()) {
                installedModules.deleteAt(i);
                i--;
            }
        }
        
        module template = "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/dashboard/templates/sidebar.cfm"
               modules  = installedModules;
    }
}