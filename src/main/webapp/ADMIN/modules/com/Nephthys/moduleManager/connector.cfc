component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.Nephthys.moduleManager';
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/moduleManager/templates/index.cfm";
    }
}