component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.Nephthys.login';
    }
    
    public boolean function checkPermission(required user user) {
        return true;
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getAdminTheme().getFolderName() & "/modules/com/Nephthys/login/templates/index.cfm";
    }
}