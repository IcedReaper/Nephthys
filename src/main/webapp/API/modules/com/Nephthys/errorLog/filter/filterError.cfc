component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.errorLog.*";
    
    public filter function init() {
        variables.fromDate = null;
        variables.toDate   = null;
        variables.fromDatetime = null;
        variables.toDatetime   = null;
        
        variables.errorCode = null;
        
        variables.minErrorId = null;
        variables.maxErrorId = null;
        variables.limit = null;
        
        variables.sortOrder = "ASC";
        
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
    public filter function setFromDatetime(required date fromDatetime) {
        variables.fromDatetime = arguments.fromDatetime;
        return this;
    }
    public filter function setToDatetime(required date toDatetime) {
        variables.toDatetime = arguments.toDatetime;
        return this;
    }
    public filter function setErrorCode(required string errorCode) {
        variables.errorCode = arguments.errorCode;
        return this;
    }
    public filter function setSortOrder(required string sortOrder) {
        switch(lCase(arguments.sortOrder)) {
            case "asc":
            case "desc": {
                variables.sortOrder = arguments.sortOrder;
                break;
            }
        }
        
        return this;
    }
    public filter function setMinErrorId(required numeric minErrorId) {
        variables.minErrorId = arguments.minErrorId;
        return this;
    }
    public filter function setMaxErrorId(required numeric maxErrorId) {
        variables.maxErrorId = arguments.maxErrorId;
        return this;
    }
    public filter function setLimit(required numeric limit) {
        variables.limit = arguments.limit;
        return this;
    }
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "SELECT errorId
                     FROM nephthys_error ";
        
        var where = "";
        var limit = "";
        if(variables.fromDate != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "date_trunc('day', errorDate) >= :fromDate";
            qryFilter.addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date");
        }
        if(variables.toDate != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "date_trunc('day', errorDate) <= :toDate";
            qryFilter.addParam(name = "toDate", value = variables.toDate, cfsqltype = "cf_sql_date");
        }
        if(variables.fromDatetime != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " errorDate >= :fromDatetime";
            qryFilter.addParam(name = "fromDatetime", value = variables.fromDatetime, cfsqltype = "cf_sql_date");
        }
        if(variables.toDatetime != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " errorDate <= :toDatetime";
            qryFilter.addParam(name = "toDatetime", value = variables.toDatetime, cfsqltype = "cf_sql_date");
        }
        if(variables.errorCode != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "errorCode = :errorCode";
            qryFilter.addParam(name = "errorCode", value = variables.errorCode, cfsqltype = "cf_sql_varchar");
        }
        if(variables.minErrorId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "errorId > :minErrorId";
            qryFilter.addParam(name = "minErrorId", value = variables.minErrorId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.maxErrorId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "errorId < :maxErrorId";
            qryFilter.addParam(name = "maxErrorId", value = variables.maxErrorId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.limit != null) {
            limit = " LIMIT " & variables.limit;
        }
        
        sql &= where & " ORDER BY errorId " & variables.sortOrder & limit;
        
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