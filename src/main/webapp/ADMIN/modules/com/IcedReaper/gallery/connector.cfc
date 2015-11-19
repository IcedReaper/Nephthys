component interface="ADMIN.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return 'com.IcedReaper.gallery';
    }
    
    public void function render() {
        include "/ADMIN/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/index.cfm";
    }
}