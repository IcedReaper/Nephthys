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
        var memoryUsageCtrl = createObject("component", "API.modules.com.Nephthys.dashboard.memoryUsage").init();
        
        var memory = {
            total          = memoryUsageCtrl.getTotal(),
            used           = memoryUsageCtrl.getUsed(),
            percentageUsed = memoryUsageCtrl.getUsedPercentage()
        };
        
        module template     = "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/dashboard/templates/index.cfm"
               serverStatus = createObject("component", "API.modules.com.Nephthys.system.settings").init()
               memory       = memory;
    }
    
    public void function sidebar() {
        var moduleCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
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