component {
    public loginLog function init() {
        variables.limit = null;
        variables.successful = null;
        
        variables.qRes = null;
        variables.results = [];
        return this;
    }
    
    public loginLog function setSuccessful(required boolean successful) {
        variables.successful = arguments.successful;
        return this;
    }
    
    public loginLog function setLimit(required numeric limit) {
        variables.limit = arguments.limit;
        return this;
    }
    
    public loginLog function execute() {
        variables.qRes = null;
        
        var qFilter = new Query();
        var sql = "";
        var where = "";
        var orderBy = "";
        var limit = "";
        
        sql = "  SELECT username, loginDate
                   FROM nephthys_user_statistics ";
        
        if(variables.successful != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " successful = :successful ";
            qFilter.addParam(name = "successful", value = variables.successful, cfsqltype = "cf_sql_bit")
        }
        
        orderBy = " ORDER BY loginDate DESC ";
        
        if(variables.limit != null) {
            limit = " LIMIT :limit ";
            qFilter.addParam(name = "limit",   value = variables.limit, cfsqltype = "cf_sql_integer")
        }
        
        variables.qRes = qFilter.setSQL(sql & where & orderBy & limit)
                                .execute()
                                .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        var logins = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
            logins.append({
                username  = variables.qRes.username[i],
                loginDate = variables.qRes.loginDate[i]
            });
        }
        
        return logins;
    }
}