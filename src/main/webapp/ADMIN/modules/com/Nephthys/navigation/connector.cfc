component extends="ADMIN.abstractClasses.connector" {
    import "API.modules.com.Nephthys.moduleManager.*";
    
    public connector function init() {
        variables.moduleName = "com.Nephthys.navigation";
        
        return this;
    }
    
    public void function render() {
        var filterCtrl = new filter().for("module");
        
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