component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.error.*";
    
    public filter function init() {
        variables.fromDate = null;
        variables.toDate   = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setFromDate(required date fromDate) {
        variables.fromDate = arguments.fromDate;
        return this;
    }
    public filter function setToDate(required date toDate) {
        variables.toDate = arguments.toDate;
        return this;
    }
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "SELECT errorId
                     FROM nephthys_error ";
        
        var where = "";
        if(variables.fromDate != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "errorDate >= :fromDate";
            qryFilter.addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date");
        }
        if(variables.toDate != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "errorDate < :toDate";
            qryFilter.addParam(name = "toDate", value = variables.toDate, cfsqltype = "cf_sql_date");
        }
        
        sql &= where & " ORDER BY errorId ASC";
        
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
                variables.results.append(new error(variables.qRes.errorId[i]));
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