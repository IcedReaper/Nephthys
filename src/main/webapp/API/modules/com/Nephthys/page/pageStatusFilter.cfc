component implements="API.interfaces.filter" {
    public filter function init() {
        variables.startStatus = null;
        variables.endStatus   = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setStartStatus(required boolean startStatus) {
        variables.startStatus = arguments.startStatus;
        
        return this;
    }
    
    public filter function setEndStatus(required boolean endStatus) {
        variables.endStatus = arguments.endStatus;
        
        return this;
    }
    
    public filter function execute() {
        var qFilter = new Query();
        var sql = "SELECT pageStatusId
                     FROM nephthys_pageStatus ";
        
        var where = "";
        if(variables.startStatus != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " startStatus = :startStatus";
            qFilter.addParam(name = "startStatus", value = variables.startStatus, cfsqltype = "cf_sql_bit");
        }
        if(variables.endStatus != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " endStatus = :endStatus";
            qFilter.addParam(name = "endStatus", value = variables.endStatus, cfsqltype = "cf_sql_bit");
        }
        
        var orderBy = " ORDER BY pageStatusId";
        
        variables.qRes = qFilter.setSQL(sql & where & orderBy)
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
                variables.results.append(new pageStatus(variables.qRes.pageStatusId[i]));
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