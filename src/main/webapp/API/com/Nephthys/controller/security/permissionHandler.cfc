component {
    public permissionHandler function init() {
        return this;
    }
    
    public array function loadForUserId(required numeric userId) {
        var qGetUserPermissions = new Query().setSQL("         SELECT m.moduleId, m.moduleName, m.description, p.permissionId, p.roleId
                                                                 FROM nephthys_module m
                                                      LEFT OUTER JOIN (SELECT *
                                                                         FROM nephthys_permission perm
                                                                        WHERE perm.userId = :userId) p ON m.moduleId = p.moduleId
                                                             ORDER BY m.sortOrder ASC")
                                            .addParam(name = "userId", value = arguments.userId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
        
        var permissions = [];
        for(var i = 1; i <= qGetUserPermissions.getRecordCount(); i++) {
            permissions.append({
                "moduleId"     = qGetUserPermissions.moduleId[i],
                "moduleName"   = qGetUserPermissions.moduleName[i],
                "description"  = qGetUserPermissions.description[i],
                "permissionId" = qGetUserPermissions.permissionId[i],
                "roleId"       = qGetUserPermissions.roleId[i]
            });
        }
        
        return permissions;
    }
    
    public array function loadForModuleId(required numeric moduleId) {
        var qGetModuleUser = new Query().setSQL("    SELECT p.permissionId, p.userId, r.roleId, r.name roleName, r.value roleValue
                                                       FROM nephthys_permission p
                                                 INNER JOIN nephthys_role r ON p.roleId = r.roleId
                                                      WHERE p.moduleId = :moduleId
                                                   ORDER BY r.value ASC")
                                            .addParam(name = "moduleId", value = arguments.moduleId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
        
        var userArray = [];
        for(var i = 1; i <= qGetModuleUser.getRecordCount(); i++) {
            userArray.append({
                "permissionId" = qGetUserPermissions.permissionId[i],
                "user"         = createComponent("component", "API.com.Nephthys.classes.user.user").init(qGetUserPermissions.userId[i]),
                "roleId"       = qGetUserPermissions.roleId[i],
                "roleName"     = qGetUserPermissions.roleName[i],
                "roleValue"    = qGetUserPermissions.roleValue[i]
            });
        }
        
        return userArray;
    }
    
    public array function loadRoles() {
        var qRoles = new Query().setSQL("  SELECT roleId, name, value
                                             FROM nephthys_role
                                         ORDER BY value")
                                .execute()
                                .getResult();
        
        var roles = [];
        for(var i = 1; i <= qRoles.getRecordCount(); i++) {
            roles.append({
                "roleId" = qRoles.roleId[i],
                "name"   = qRoles.name[i],
                "value"  = qRoles.value[i]
            });
        }
        
        return roles;
    }
    
    public void function setPermission(required numeric permissionId,
                                       required numeric userId,
                                       required numeric roleId,
                                       required numeric moduleId) {
        if(arguments.permissionId == 0) {
            new Query().setSQL("INSERT INTO nephthys_permission
                                            (
                                                userId,
                                                roleId,
                                                moduleId,
                                                creatorUserId,
                                                lastEditorUserId
                                            )
                                     VALUES (
                                                :userId,
                                                :roleId,
                                                :moduleId,
                                                :creatorUserId,
                                                :lastEditorUserId
                                            )")
                       .addParam(name = "userId",           value = arguments.userId,         cfsqltype = "cf_sql_numeric")
                       .addParam(name = "roleId",           value = arguments.roleId,         cfsqltype = "cf_sql_numeric")
                       .addParam(name = "moduleId",         value = arguments.moduleId,       cfsqltype = "cf_sql_numeric")
                       .addParam(name = "creatorUserId",    value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .execute();
        }
        else {
            new Query().setSQL("UPDATE nephthys_permission
                                   SET roleId           = :roleId,
                                       lastEditorUserId = :lastEditorUserId
                                 WHERE permissionId = :permissionId")
                       .addParam(name = "roleId",           value = arguments.roleId,         cfsqltype = "cf_sql_numeric")
                       .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .addParam(name = "permissionId",     value = arguments.permissionId,   cfsqltype = "cf_sql_numeric")
                       .execute();
        }
    }
    
    public void function removePermission(required numeric permissionId) {
        new Query().setSQL("DELETE FROM nephthys_permission WHERE permissionId = :permissionId")
                   .addParam(name = "permissionId", value = arguments.permissionId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
}