component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.system";
    }
    
    public boolean function checkPermission(required user user) {
        return arguments.user.hasPermission(moduleName = getName(), roleName = 'user');
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getAdminTheme().getFolderName() & "/modules/com/Nephthys/system/templates/index.cfm";
    }
}