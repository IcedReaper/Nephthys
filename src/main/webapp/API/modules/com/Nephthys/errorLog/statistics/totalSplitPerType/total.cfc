component extends="API.modules.com.Nephthys.errorLog.statistics.abstractStatistic" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "  SELECT errorCode, COUNT(*) count
                           FROM nephthys_error
                          WHERE date_trunc('day', errorDate) >= :fromDate
                            AND date_trunc('day', errorDate) <= :toDate
                       GROUP BY errorCode
                       ORDER BY COUNT(*) DESC";
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDate",   value = variables.toDate,   cfsqltype = "cf_sql_date")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        var errorList = [];
        
        for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
            errorList.append({
                "errorCode" = variables.qRes.errorCode[i],
                "count"     = variables.qRes.count[i]
            });
        }
        return errorList;
    }
}