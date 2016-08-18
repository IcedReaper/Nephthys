component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        variables.moduleName = "";
        return this;
    }
    
    public string function getName() {
        return variables.moduleName;
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public boolean function checkPermission(required user user) {
        return arguments.user.hasPermission(moduleName = variables.moduleName, roleName = 'user');
    }
    
    public string function render() {
        var modulePath = "";
        if(variables.keyExists("folder")) {
            modulePath = variables.folder;
        }
        else {
            modulePath = getName().replace(".", "/", "ALL");
        }
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("index.cfm")
            .render();
    }
}