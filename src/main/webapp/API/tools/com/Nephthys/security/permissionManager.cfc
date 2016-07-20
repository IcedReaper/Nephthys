component interface="APi.interface.permissionManager" {
    import "API.modules.com.Nephthys.user.*";
    
    public permissionManager function init() {
        return this;
    }
    
    public array function loadForUserId(required numeric userId) {
        var qGetUserPermissions = new Query().setSQL("         SELECT m.moduleId, m.moduleName, m.description, p.permissionId, p.roleId, p.value roleValue
                                                                 FROM nephthys_module m
                                                      LEFT OUTER JOIN (SELECT perm.*, r.value
                                                                         FROM nephthys_user_permission perm
                                                                       INNER JOIN nephthys_user_permissionRole r ON perm.roleId = r.roleId
                                                                        WHERE perm.userId = :userId) p ON m.moduleId = p.moduleId
                                                             ORDER BY m.sortOrder ASC")
                                            .addParam(name = "userId", value = arguments.userId, cfsqltype = "cf_sql_numeric", null = ! isNumeric(arguments.userId))
                                            .execute()
                                            .getResult();
        
        var permissions = [];
        for(var i = 1; i <= qGetUserPermissions.getRecordCount(); i++) {
            permissions.append({
                "moduleId"     = qGetUserPermissions.moduleId[i],
                "moduleName"   = qGetUserPermissions.moduleName[i],
                "description"  = qGetUserPermissions.description[i],
                "permissionId" = qGetUserPermissions.permissionId[i],
                "roleId"       = qGetUserPermissions.roleId[i],
                "roleValue"    = qGetUserPermissions.roleValue[i]
            });
        }
        
        return permissions;
    }
    
    public array function loadForModuleId(required numeric moduleId, required numeric roleId = 0, required numeric roleValue = 0) {
        var qryGetModuleUser = new Query();
        var sql = "    SELECT p.permissionId, p.userId, r.roleId, r.name roleName, r.value roleValue
                         FROM nephthys_user_permission p
                   INNER JOIN nephthys_user_permissionRole r ON p.roleId = r.roleId
                        WHERE p.moduleId = :moduleId ";
        
        if(arguments.roleId != 0) {
            sql &= " AND p.roleId = :roleId ";
            qryGetModuleUser.addParam(name = "roleId", value = arguments.roleId, cfsqltype = "cf_sql_numeric");
        }
        if(arguments.roleValue != 0) {
            sql &= " AND r.value = :roleValue ";
            qryGetModuleUser.addParam(name = "roleValue", value = arguments.roleValue, cfsqltype = "cf_sql_numeric");
        }
        
        sql &= "ORDER BY r.value ASC";
        qryGetModuleUser.setSQL(sql)
                        .addParam(name = "moduleId", value = arguments.moduleId, cfsqltype = "cf_sql_numeric");
        var qGetModuleUser = qryGetModuleUser.execute()
                                             .getResult();
        
        var userArray = [];
        for(var i = 1; i <= qGetModuleUser.getRecordCount(); i++) {
            userArray.append({
                "permissionId" = qGetModuleUser.permissionId[i],
                "user"         = new user(qGetModuleUser.userId[i]),
                "roleId"       = qGetModuleUser.roleId[i],
                "roleName"     = qGetModuleUser.roleName[i],
                "roleValue"    = qGetModuleUser.roleValue[i]
            });
        }
        
        return userArray;
    }
    
    public array function loadUserForModule(required numeric moduleId) {
        var qGetUser = new Query().setSQL("         SELECT u.userId, p.roleId, p.permissionId
                                                      FROM nephthys_user u
                                           LEFT OUTER JOIN (SELECT perm.*
                                                              FROM nephthys_user_permission perm
                                                             WHERE perm.moduleId = :moduleId) p ON u.userId = p.userId
                                                  ORDER BY u.userId")
                                  .addParam(name = "moduleId", value = arguments.moduleId, cfsqltype = "cf_sql_numeric")
                                  .execute()
                                  .getResult();
        
        var userArray = [];
        for(var i = 1; i <= qGetUser.getRecordCount(); i++) {
            userArray.append({
                "permissionId" = qGetUser.permissionId[i],
                "user"         = new user(qGetUser.userId[i]),
                "roleId"       = qGetUser.roleId[i]
            });
        }
        
        return userArray;
    }
}