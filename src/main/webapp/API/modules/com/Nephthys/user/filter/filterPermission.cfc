component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.user.*";
    
    public filter function init() {
        variables.userId = null;
        
        variables.permissionSubGroupId = null;
        variables.permissionSubGroupName = null;
        
        variables.moduleId = null;
        variables.moduleName = null;
        
        variables.permissionRoleId = null;
        variables.roleValue = null;
        variables.roleName = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public filter function setPermissionSubGroupId(required numeric permissionSubGroupId) {
        variables.permissionSubGroupId = arguments.permissionSubGroupId;
        return this;
    }
    public filter function setPermissionSubGroupName(required numeric permissionSubGroupName) {
        variables.permissionSubGroupName = arguments.permissionSubGroupName;
        return this;
    }
    
    public filter function setModuleId(required numeric moduleId) {
        variables.moduleId = arguments.moduleId;
        return this;
    }
    public filter function setModuleName(required string moduleName) {
        variables.moduleName = arguments.moduleName;
        return this;
    }
    
    public filter function setPermissionRoleId(required numeric permissionRoleId) {
        variables.permissionRoleId = arguments.permissionRoleId;
        return this;
    }
    public filter function setRoleValue(required numeric roleValue) {
        variables.roleValue = arguments.roleValue;
        return this;
    }
    public filter function setRoleName(required string roleName) {
        variables.roleName = arguments.roleName;
        return this;
    }
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "";
        var where = "";
        
        var moduleSubQuery = "";
        if(variables.moduleId != null || variables.moduleName != null) {
            if(variables.moduleId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " p.moduleId = :moduleId ";
                qryFilter.addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric");
            }
            else {
                moduleSubQuery = " INNER JOIN nephthys_module m ON p.moduleId = m.moduleId AND m.moduleName = :moduleName "
                qryFilter.addParam(name = "moduleName", value = variables.moduleName, cfsqltype = "cf_sql_varchar");
            }
        }
        
        var roleSubQuery = "";
        if(variables.permissionRoleId != null || variables.roleValue != null || variables.roleName != null) {
            roleSubQuery = "INNER JOIN nephthys_user_permissionRole r ON p.permissionRoleId = r.permissionRoleId
                                                                      AND r.value >= (SELECT r2.value
                                                                                        FROM nephthys_user_permissionRole r2 ";
            if(variables.permissionRoleId != null) {
                roleSubQuery &= "WHERE r2.permissionRoleId = :permissionRoleId) ";
                qryFilter.addParam(name = "permissionRoleId", value = variables.permissionRoleId, cfsqltype = "cf_sql_numeric");
            }
            else if(variables.roleValue != null) {
                roleSubQuery &= " WHERE r2.value = :roleValue) ";
                qryFilter.addParam(name = "roleValue", value = variables.roleValue, cfsqltype = "cf_sql_varchar");
            }
            else {
                roleSubQuery &= " WHERE r2.name = :roleName) ";
                qryFilter.addParam(name = "roleName", value = variables.roleName, cfsqltype = "cf_sql_varchar");
            }
        }
        
        if(variables.userId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " p.userId = :userId ";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
            
        if(variables.permissionSubGroupId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " p.permissionSubGroupId = :permissionSubGroupId ";
            qryFilter.addParam(name = "permissionSubGroupId", value = variables.permissionSubGroupId, cfsqltype = "cf_sql_numeric");
        }
        else if(variables.permissionSubGroupName != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " p.permissionSubGroupId = (SELECT psg.permissionSubGroupId
                                                                                         FROM nephthys_user_permissionSubGroupId psg
                                                                                        WHERE psg.name = :permissionSubGroupName) ";
            qryFilter.addParam(name = "permissionSubGroupName", value = variables.permissionSubGroupName, cfsqltype = "cf_sql_numeric");
        }
        
        sql = "SELECT p.permissionId
                 FROM nephthys_user_permission p "
            & moduleSubQuery
            & roleSubQuery
            & where;
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(isNull(variables.results)) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new permission(variables.qRes.permissionId[i]));
            }
        }
        return variables.results;
    }
    
    public numeric function getResultCount() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        return variables.qRes.getRecordCount();
    }
}