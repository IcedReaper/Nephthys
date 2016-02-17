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
               serverStatus = application.system.settings
               memory       = memory;
    }
}