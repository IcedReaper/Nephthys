component {
    public permissionSubGroup function init(required numeric permissionSubGroupId) {
        variables.permissionSubGroupId = arguments.permissionSubGroupId;
        
        load();
        
        return this;
    }
    
    
    
    private void function load() {
        
    }
}