component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.IcedReaper.teamOverview';
    }
    
    public boolean function checkPermission(required user user) {
        return true;//arguments.user.hasPermission(moduleName = getName(), roleName = 'user');
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getAdminTheme().getFolderName() & "/modules/com/IcedReaper/teamOverview/templates/index.cfm";
    }
}