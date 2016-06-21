component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        variables.moduleName = "";
        return this;
    }
    
    public string function getName() {
        return variables.moduleName;
    }
    
    public boolean function checkPermission(required user user) {
        return arguments.user.hasPermission(moduleName = variables.moduleName, roleName = 'user');
    }
    
    public void function render() {
        var modulePath = "";
        if(variables.keyExists("folder")) {
            modulePath = variables.folder;
        }
        else {
            modulePath = getName().replace(".", "/", "ALL");
        }
        
        include "/ADMIN/themes/" & request.user.getAdminTheme().getFolderName() & "/modules/" & modulePath & "/templates/index.cfm";
    }
}