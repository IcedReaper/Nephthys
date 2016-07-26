component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.userManager.*";
    
    public filter function init() {
        variables.namepart = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setNamepart(required string namepart) {
        variables.namepart = arguments.namepart;
        return this;
    }
    
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "SELECT blacklistId
                     FROM nephthys_user_blacklist ";
        var where = "";
        var sortBy = " ORDER BY blacklistId ASC";
        
        if(variables.namepart != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " namepart = :namepart";
            qryFilter.addParam(name = "namepart", value = variables.namepart, cfsqltype = "cf_sql_varchar");
        }
        
        sql &= where & sortBy;
        
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
                variables.results.append(new blacklist(variables.qRes.blacklistId[i]));
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