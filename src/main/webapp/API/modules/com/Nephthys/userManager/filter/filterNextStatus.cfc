component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.userManager.*";
    
    public filter function init() {
        variables.status = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setStatus(required status status) {
        variables.status = arguments.status
        
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "SELECT nextStatusId
                 FROM nephthys_user_statusFlow s ";
        
        where = "";
        if(! isNull(variables.status)) {
            where &= (where == "" ? " WHERE " : " AND ") & "s.statusId = :statusId";
            qryFilter.addParam(name = "statusId", value = variables.status.getStatusId(), cfsqltype = "cf_sql_numeric");
        }
        
        orderBy = " ORDER BY nextStatusId";
        
        variables.qRes = qryFilter.setSQL(sql & where & orderBy)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(variables.results == null) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new status(variables.qRes.nextStatusId[i]));
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