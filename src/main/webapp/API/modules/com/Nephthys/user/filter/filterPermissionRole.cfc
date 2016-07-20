component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.user.*";
    
    public filter function init() {
        variables.roleValue = null;
        variables.roleName = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    public filter function setRoleValue(required numeric roleValue) {
        variables.roleValue = arguments.roleValue;
        return this;
    }
    public filter function setRoleName(required numeric roleValue) {
        variables.roleValue = arguments.roleValue;
        return this;
    }
    
    public filter function execute() {
        if(variables.userId != null) {
            variables.qRes = null;
            variables.results = null;
            
            var qryFilter = new Query();
            var sql = "";
            var where = "";
            
            var where = "";
            
            if(variables.roleValue != null) {
                where &= " WHERE r.value = :roleValue) ";
                qryFilter.addParam(name = "roleValue", value = variables.roleValue, cfsqltype = "cf_sql_varchar");
            }
            if(variables.roleName != null) {
                where &= " WHERE r.name = :roleName) ";
                qryFilter.addParam(name = "roleName", value = variables.roleName, cfsqltype = "cf_sql_varchar");
            }
                    
            where &= (where == "" ? " WHERE " : " AND ") & " p.userId = :userId ";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
            
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
            
            sql = "SELECT r.permissionRoleId
                     FROM nephthys_user_permissionRole r "
                & where;
            
            variables.qRes = qryFilter.setSQL(sql)
                                      .execute()
                                      .getResult();
        }
        else {
            throw(type = "nephthys.application.invalidResource", message = "Please specify the userId");
        }
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(isNull(variables.results)) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new permissionRole(variables.qRes.permissionRoleId[i]));
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