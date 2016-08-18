component extends="ADMIN.abstractClasses.connector" {
    public connector function init() {
        variables.moduleName = "com.Nephthys.dashboard";
        
        return this;
    }
    
    public boolean function checkPermission(required user user) {
        return true;
    }
}