component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "         SELECT dateRange.d _date,
                                       CASE
                                         WHEN errors.errorCount IS NOT NULL THEN
                                           errors.errorCount
                                         ELSE
                                           0
                                       END errorCount
                                  FROM (SELECT i :: date d 
                                          FROM generate_series('6/1/2016', '6/30/2016', '1 day' :: interval) i) dateRange
                       LEFT OUTER JOIN (    SELECT COUNT(*) errorCount, date_trunc('day', errorDate) _date
                                              FROM nephthys_error s
                                             WHERE date_trunc('day', errorDate) >= '6/1/2016'
                                               AND date_trunc('day', errorDate) <= '6/30/2016'
                                          GROUP BY date_trunc('day', errorDate) ) errors ON dateRange.d = errors._date
                              ORDER BY dateRange.d " & variables.sortOrder;
            
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
}