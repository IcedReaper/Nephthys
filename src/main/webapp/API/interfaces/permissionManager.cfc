interface {
    public permissionManager function init();
    public array function loadForUserId(required numeric userId);
    public array function loadForModuleId(required numeric moduleId, required numeric roleId = 0, required numeric roleValue = 0);
    public array function loadUserForModule(required numeric moduleId);
    public struct function loadRole(required numeric roleId);
    public struct function loadRoleByName(required string roleName);
    public array function loadRoles();
    public void function setPermission(required numeric permissionId, required numeric userId, required numeric roleId, required numeric moduleId);
    public void function removePermission(required numeric permissionId);
    public boolean function hasPermission(required numeric userId, required string moduleName, required string roleName);
}