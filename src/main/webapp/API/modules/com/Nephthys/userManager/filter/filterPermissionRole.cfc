component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.userManager.*";
    
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
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "";
        var where = "";
        
        if(variables.roleValue != null) {
            where &= (where = "" ? " WHERE " : " AND ") & " r.value = :roleValue ";
            qryFilter.addParam(name = "roleValue", value = variables.roleValue, cfsqltype = "cf_sql_varchar");
        }
        if(variables.roleName != null) {
            where &= (where = "" ? " WHERE " : " AND ") & " r.name = :roleName ";
            qryFilter.addParam(name = "roleName", value = variables.roleName, cfsqltype = "cf_sql_varchar");
        }
        
        sql = "SELECT r.permissionRoleId
                 FROM nephthys_user_permissionRole r "
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