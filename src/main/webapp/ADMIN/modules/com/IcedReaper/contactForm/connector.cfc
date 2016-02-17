component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.IcedReaper.contactForm';
    }
    
    public boolean function checkPermission(required user user) {
        return true;//arguments.user.hasPermission(moduleName = getName(), roleName = 'user'); // todo...
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/contactForm/templates/index.cfm";
    }
}