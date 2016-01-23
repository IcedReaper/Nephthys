component interface="APi.interface.permissionManager" {
    public permissionManager function init() {
        return this;
    }
    
    public array function loadForUserId(required numeric userId) {
        var qGetUserPermissions = new Query().setSQL("         SELECT m.moduleId, m.moduleName, m.description, p.permissionId, p.roleId
                                                                 FROM nephthys_module m
                                                      LEFT OUTER JOIN (SELECT *
                                                                         FROM nephthys_permission perm
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
                "roleId"       = qGetUserPermissions.roleId[i]
            });
        }
        
        return permissions;
    }
    
    public array function loadForModuleId(required numeric moduleId, required numeric roleId = 0, required numeric roleValue = 0) {
        var qryGetModuleUser = new Query();
        var sql = "    SELECT p.permissionId, p.userId, r.roleId, r.name roleName, r.value roleValue
                         FROM nephthys_permission p
                   INNER JOIN nephthys_role r ON p.roleId = r.roleId
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
                "user"         = createObject("component", "API.modules.com.Nephthys.user.user").init(qGetModuleUser.userId[i]),
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
                                                              FROM nephthys_permission perm
                                                             WHERE perm.moduleId = :moduleId) p ON u.userId = p.userId
                                                  ORDER BY u.userId")
                                  .addParam(name = "moduleId", value = arguments.moduleId, cfsqltype = "cf_sql_numeric")
                                  .execute()
                                  .getResult();
        
        var userArray = [];
        for(var i = 1; i <= qGetUser.getRecordCount(); i++) {
            userArray.append({
                "permissionId" = qGetUser.permissionId[i],
                "user"         = createObject("component", "API.modules.com.Nephthys.user.user").init(qGetUser.userId[i]),
                "roleId"       = qGetUser.roleId[i]
            });
        }
        
        return userArray;
        
    }
    
    public struct function loadRole(required numeric roleId) {
        var qRole = new Query().setSQL("SELECT *
                                          FROM nephthys_role
                                         WHERE roleId = :roleId")
                               .addParam(name = "roleId", value = arguments.roleId, cfsqltype = "cf_sql_numeric")
                               .execute()
                               .getResult();
        
        if(qRole.getRecordCount() == 1) {
            return {
                "roleId" = qRole.roleId[1],
                "name"   = qRole.name[1],
                "value"  = qRole.value[1]
            };
        }
        else {
            throw(type = "nephthys.notFound.role", message = "Could not find a role with the ID " & arguments.roleId, detail = arguments.roleId);
        }
    }
    
    public struct function loadRoleByName(required string roleName) {
        var qRole = new Query().setSQL("SELECT *
                                          FROM nephthys_role
                                         WHERE name = :roleName")
                               .addParam(name = "roleName", value = arguments.roleName, cfsqltype = "cf_sql_varchar")
                               .execute()
                               .getResult();
        
        if(qRole.getRecordCount() == 1) {
            return {
                "roleId" = qRole.roleId[1],
                "name"   = qRole.name[1],
                "value"  = qRole.value[1]
            };
        }
        else {
            throw(type = "nephthys.notFound.role", message = "Could not find a role with Name " & arguments.roleName, detail = arguments.roleName);
        }
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
        if(arguments.userId == 0 || arguments.userId == null) {
            throw(type = "nephthys.application.notAllowed", message = "It is not allowed to set permissions for a user with ID 0");
        }
        // check if the user exists. If not the component will throw an error.
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        
        if(arguments.permissionId == 0 || arguments.permissionId == null) {
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
    
    public boolean function hasPermission(required numeric userId, required string moduleName, required string roleName) {
        if(arguments.userId     == 0  || arguments.userId     == null ||
           arguments.moduleName == "" || arguments.moduleName == null ||
           arguments.roleName   == "" || arguments.roleName   == null)
            return false;
        
        return new Query().setSQL("    SELECT p.permissionId
                                         FROM nephthys_permission p
                                   INNER JOIN nephthys_module m ON p.moduleId = m.moduleId AND m.moduleName = :moduleName
                                   INNER JOIN nephthys_role r ON p.roleId = r.roleId AND r.value > (SELECT r2.value
                                                                                                      FROM nephthys_role r2
                                                                                                     WHERE r2.name = :roleName)
                                        WHERE p.userId = :userId")
                          .addParam(name = "userId",     value = arguments.userId,     cfsqltype = "cf_sql_numeric")
                          .addParam(name = "moduleName", value = arguments.moduleName, cfsqltype = "cf_sql_varchar")
                          .addParam(name = "roleName",   value = arguments.roleName,   cfsqltype = "cf_sql_varchar")
                          .execute()
                          .getResult()
                          .getRecordCount() > 0;
    }
}