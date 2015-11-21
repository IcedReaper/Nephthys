component {
    remote struct function getList() {
        var userListCtrl = createObject("component", "API.com.Nephthys.controller.user.userList").init();
        
        var userArray = userListCtrl.getList();
        
        var data = [];
        
        for(var i = 1; i <= userArray.len(); i++) {
            data.append({
                    "userId"   = userArray[i].getUserId(),
                    "username" = userArray[i].getUserName(),
                    "email"    = userArray[i].getEmail(),
                    "active"   = userArray[i].getActiveStatus()/*,
                    "actions" = [
                        "activeStatus" = true,
                        "permissions"  = false
                    ]*/
                });
        }
        
        return {
            "success" = true,
            "data"    = data
        };
    }
    
    remote struct function getDetails(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        
        return {
            "success" = true,
            "data" = prepareDetailStruct(user)
        };
    }
    
    remote struct function save(required numeric userId,
                                required string  userName,
                                required string  eMail,
                                required numeric active,
                                required string  password) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        
        if(arguments.userId == 0) {
            user.setUsername(arguments.userName);
        }
        
        user.setEmail(arguments.eMail)
            .setActiveStatus(arguments.active);
        
        if(trim(arguments.password) != "") {
            user.setPassword(encrypt(arguments.password,
                                     application.system.settings.getEncryptionKey(),
                                     application.system.settings.getEncryptionAlgorithm()));
        }
        
        user.save();
        
        return {
            "success" = true,
            "data"    = prepareDetailStruct(createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId))
        };
    }
    
    remote struct function delete(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        fileDelete(expandPath("/upload/com.Nephthys.user/avatar/") & user.getAvatarFilename());
        user.delete();
        
        return {
            "success" = true
        };
    }
    
    remote struct function activate(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        user.setActiveStatus(1)
            .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivate(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        user.setActiveStatus(0)
            .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function uploadAvatar(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        
        if(user.getUserId() == request.user.getUserId()) {
            user.uploadAvatar()
                .save();
            
            return {
                "success" = true,
                "avatar"  = "/upload/com.Nephthys.user/avatar/" & user.getAvatarFilename()
            };
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "It is only allowed to upload an avatar for yourself");
        }
    }
    
    remote struct function getPermissions(required numeric userId) {
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
                "permissionId" = toString(qGetUserPermissions.permissionId[i] != null ? qGetUserPermissions.permissionId[i] : 0),
                "roleId"       = toString(qGetUserPermissions.roleId[i] != null ? qGetUserPermissions.roleId[i] : 0)
            });
        }
        
        
        return {
            "success"     = true,
            "permissions" = permissions
        };
    }
    
    remote struct function getRoles() {
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
        
        return {
            "success" = true,
            "roles"   = roles
        };
    }
    
    remote struct function savePermissions(required numeric userId, required array permissions) {
        transaction {
            for(var i = 1; i <= arguments.permissions.len(); i++) {
                if(arguments.permissions[i].roleId == 0) continue;
                
                if(arguments.permissions[i].permissionId == 0) {
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
                               .addParam(name = "userId",           value = arguments.userId,                  cfsqltype = "cf_sql_numeric")
                               .addParam(name = "roleId",           value = arguments.permissions[i].roleId,   cfsqltype = "cf_sql_numeric")
                               .addParam(name = "moduleId",         value = arguments.permissions[i].moduleId, cfsqltype = "cf_sql_numeric")
                               .addParam(name = "creatorUserId",    value = request.user.getUserId(),          cfsqltype = "cf_sql_numeric")
                               .addParam(name = "lastEditorUserId", value = request.user.getUserId(),          cfsqltype = "cf_sql_numeric")
                               .execute();
                }
                else {
                    new Query().setSQL("UPDATE nephthys_permission
                                           SET roleId           = :roleId,
                                               lastEditorUserId = :lastEditorUserId
                                         WHERE permissionId = :permissionId")
                               .addParam(name = "roleId",           value = arguments.permissions[i].roleId,       cfsqltype = "cf_sql_numeric")
                               .addParam(name = "lastEditorUserId", value = request.user.getUserId(),              cfsqltype = "cf_sql_numeric")
                               .addParam(name = "permissionId",     value = arguments.permissions[i].permissionId, cfsqltype = "cf_sql_numeric")
                               .execute();
                }
            }
            
            transactionCommit();
        }
        return {
            "success" = true
        };
    }
    
    // P R I V A T E   M E T H O D S
    
    private struct function prepareDetailStruct(required user userObject) {
        return {
            "userId"     = arguments.userObject.getUserId(),
            "username"   = arguments.userObject.getUserName(),
            "email"      = arguments.userObject.getEmail(),
            "active"     = toString(arguments.userObject.getActiveStatus()),
            "password"   = "      ",
            "avatar"     = "/upload/com.Nephthys.user/avatar/" & arguments.userObject.getAvatarFilename(),
            "actualUser" = arguments.userObject.getUserId() == request.user.getUserId()
        };
    }
}