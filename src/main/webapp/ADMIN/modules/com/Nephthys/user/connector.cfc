component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.Nephthys.user';
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/index.cfm";
    }
}