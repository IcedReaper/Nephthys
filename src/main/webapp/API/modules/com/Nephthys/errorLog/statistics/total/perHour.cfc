component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null) {
            var qPageRequests = new Query();
            
            var sql = "SELECT dateRange.d _date, 
                                       CASE
                                         WHEN errors.errorCount IS NOT NULL THEN
                                           errors.errorCount
                                         ELSE
                                           0
                                       END errorCount
                                  FROM (SELECT i d 
                                          FROM generate_series(0, 23) i) dateRange
                       LEFT OUTER JOIN (    SELECT COUNT(*) errorCount, date_part('Hour', errorDate) _date 
                                              FROM nephthys_error s
                                             WHERE date_trunc('day', errorDate) = :date
                                          GROUP BY date_part('Hour', errorDate) ) errors ON dateRange.d = errors._date
                              ORDER BY dateRange.d  " & variables.sortOrder;
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "date", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}