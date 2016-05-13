component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.Nephthys.navigation';
    }
    
    public void function render() {
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
        
        var installedModules = filterCtrl.setAvailableAdmin(true)
                                         .execute()
                                         .getResult();
        
        for(var i = 1; i <= installedModules.len(); i++) {
            var moduleConnector = createObject("component", "ADMIN.modules." & installedModules[i].getModuleName() & ".connector").init();
            if(! installedModules[i].getActiveStatus() || ! moduleConnector.checkPermission(request.user)) {
                installedModules.deleteAt(i);
                i--;
            }
        }
        
        module template = "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/templates/sidebar.cfm"
               modules  = installedModules;
    }
}