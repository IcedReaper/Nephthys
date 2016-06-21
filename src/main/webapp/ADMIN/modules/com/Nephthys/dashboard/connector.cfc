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
        include "/ADMIN/themes/" & request.user.getAdminTheme().getFolderName() & "/modules/com/Nephthys/dashboard/templates/index.cfm";
    }
}