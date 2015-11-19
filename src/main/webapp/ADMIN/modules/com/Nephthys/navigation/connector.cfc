component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.Nephthys.navigation';
    }
    
    public void function render() {
        var moduleCtrl = createObject("component", "API.com.Nephthys.controller.modules.overview").init();
        var installedModules = moduleCtrl.getList();
        
        for(var i = 1; i <= installedModules.len(); i++) {
            if(! installedModules[i].getActiveStatus()) {
                installedModules.deleteAt(i);
                i--;
            }
        }
        
        module template = "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/templates/sidebar.cfm"
               modules  = installedModules;
    }
}