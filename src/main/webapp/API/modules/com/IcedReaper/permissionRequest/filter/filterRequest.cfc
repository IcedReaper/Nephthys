component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.permissionRequest.*";
    
    public filter function init() {
        variables.userId        = null;
        variables.requestsSince = null;
        variables.status        = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public filter function setSince(required date requestsSince) {
        variables.requestsSince = arguments.requestsSince;
        return this;
    }
    public filter function setStatus(required numeric status) {
        variables.status = arguments.status;
        return this;
    }
    
    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql = "";
        var where = "";
        
        if(variables.userId != null) {
            where = (where == "" ? " WHERE " : " AND ") & " userId = :userId ";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.requestsSince != null) {
            where = (where == "" ? " WHERE " : " AND ") & " creationDate >= :requestsSince ";
            qryFilter.addParam(name = "requestsSince", value = variables.requestsSince, cfsqltype = "cf_sql_date");
        }
        if(variables.status != null) {
            where = (where == "" ? " WHERE " : " AND ") & " status = :status ";
            qryFilter.addParam(name = "status", value = variables.status, cfsqltype = "cf_sql_numeric");
        }
        
        sql = "   SELECT pr.requestId
                    FROM IcedReaper_permissionRequest_request pr "
            & where
            & " ORDER BY pr.requestId DESC";
        
        qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        variables.results = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
            variables.results.append(new request(variables.qRes.requestId[i]));
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