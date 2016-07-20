interface {
    public permissionManager function init();
    public array function loadForUserId(required numeric userId);
    public array function loadForModuleId(required numeric moduleId, required numeric roleId = 0, required numeric roleValue = 0);
    public array function loadUserForModule(required numeric moduleId);
    public struct function loadRole(required numeric roleId);
}