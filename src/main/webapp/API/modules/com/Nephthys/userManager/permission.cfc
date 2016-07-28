component {
    import "API.modules.com.Nephthys.moduleManager.module";
    
    public permission function init(required numeric permissionId) {
        variables.permissionId = arguments.permissionId;
        
        load();
        
        return this;
    }
    
    public permission function setUser(required user user) {
        if(variables.permissionId == null) {
            variables.user = arguments.user;
        }
        
        return this;
    }
    
    public permission function setPermissionRole(required permissionRole permissionRole) {
        variables.permissionRole = arguments.permissionRole;
        return this;
    }
    
    public permission function setModule(required module module) {
        if(variables.permissionId == null) {
            variables.module = arguments.module;
        }
        
        return this;
    }
    
    public permission function setPermissionSubGroup(required permissionSubGroup permissionSubGroup) {
        if(variables.permissionId == null) {
            variables.permissionSubGroup = arguments.permissionSubGroup;
        }
        
        return this;
    }
    
    
    public numeric function getPermissionId() {
        return variables.permissionId;
    }
    public user function getUser() {
        return variables.user;
    }
    public permissionRole function getPermissionRole() {
        return variables.permissionRole;
    }
    public module function getModule() {
        return variables.module;
    }
    public permisisonSubGroup function getPermissionSubGroup() {
        return variables.permisisonSubGroup;
    }
    
    
    public permission function save(required user user) {
        var qSave = new Query();
        qSave.addParam(name = "userId",           value = variables.user.getUserId(),                     cfsqltype = "cf_sql_numeric")
             .addParam(name = "permissionRoleId", value = variables.permissionRole.getPermissionRoleId(), cfsqltype = "cf_sql_numeric")
             .addParam(name = "moduleId",         value = variables.module.getModuleId(),                 cfsqltype = "cf_sql_numeric")
             .addParam(name = "userId",           value = variables.creator.getUserId(),                  cfsqltype = "cf_sql_numeric");
        
        if(variables.permissionSubGroup != null) {
            qSave.addParam(name = "permissionSubGroupId", value = variables.permissionSubGroup.getPermissionSubGroupId(), cfsqltype = "cf_sql_numeric");
        }
        else {
            qSave.addParam(name = "permissionSubGroupId", value = null, cfsqltype = "cf_sql_numeric", null = true);
        }
        
        if(variables.permissionId == null) {
            variables.permissionId = qSave.setSQL("INSERT INTO nephthys_user_permission
                                                               (
                                                                   userId,
                                                                   permissionRoleId,
                                                                   moduleId,
                                                                   permissionSubGroupId,
                                                                   creatorUserId,
                                                                   lastEditorUserId
                                                               )
                                                        VALUES (
                                                                   :userId,
                                                                   :permissionRoleId,
                                                                   :moduleId,
                                                                   :permissionSubGroupId,
                                                                   :userId,
                                                                   :userId
                                                               );
                                                   SELECT currval('nephthys_user_permission_permissionid_seq') newPermissionId;")
                                          .execute()
                                          .getResult()
                                          .newPermissionId[1];
        }
        else {
            qSave.setSQL("UPDATE nephthys_user_permission
                             SET permissionRoleId = :permissionRoleId
                           WHERE permissionId = :permissionId")
                 .addParam(name = "permissionId", value = variables.permissionId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE FROM nephthys_user_permission WHERE permissionId = :permissionId")
                   .addParam(name = "permissionId", value = variables.permissionId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.permissionId = null;
    }
    
    private void function load() {
        if(variables.permissionId != null) {
            var qGetPermission = new Query().setSQL("SELECT *
                                                       FROM nephthys_user_permission
                                                      WHERE permissionId = :permissionId")
                                            .addParam(name = "permissionId", value = variables.permissionId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
            
            if(qGetPermission.getRecordCount() == 1) {
                variables.user = new user(qGetPermission.userId[1]);
                variables.permissionRole = new permissionRole(qGetPermission.permissionRoleId[1]);
                variables.module = new module(qGetPermission.moduleId[1]);
                if(qGetPermission.permissionSubGroupId[1] == null) {
                    variables.permissionSubGroup = null;
                }
                else {
                    variables.permissionSubGroup = new setPermissionSubGroup(qGetPermission.permissionSubGroupId[1]);
                }
                
                variables.creator      = new user(qGetPermission.creatorUserId[1]);
                variables.creationDate = qGetPermission.creationDate[1];
                
                variables.lastEditor   = new user(qGetPermission.creatorUserId[1]);
                variables.lastEditDate = qGetPermission.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Could not find permission by ID ", detail = variables.permissionId);
            }
        }
        else {
            variables.user = null;
            variables.permissionRole = null;
            variables.module = null;
            variables.permissionSubGroup = null;
            
            variables.creator = request.user;
            variables.creationDate = now();
            
            variables.lastEditor = request.user;
            variables.lastEditDate = now();
        }
    }
}