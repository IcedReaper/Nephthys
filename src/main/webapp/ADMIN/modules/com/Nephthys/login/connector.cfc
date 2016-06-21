component extends="ADMIN.abstractClasses.connector" {
    public connector function init() {
        variables.moduleName = "com.Nephthys.login";
        
        return this;
    }
    
    public boolean function checkPermission(required user user) {
        return true;
    }
}