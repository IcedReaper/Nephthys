component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "SELECT dateRange.d _date, 
                                       CASE
                                         WHEN errors.errorCount IS NOT NULL THEN
                                           errors.errorCount
                                         ELSE
                                           0
                                       END errorCount
                                  FROM (SELECT i d 
                                          FROM generate_series(:fromYear, :toYear) i) dateRange
                       LEFT OUTER JOIN (    SELECT COUNT(*) errorCount, date_part('Year', errorDate) _date 
                                              FROM nephthys_error s
                                             WHERE date_part('Year', errorDate) BETWEEN :fromYear AND :toYear
                                          GROUP BY date_part('Year', errorDate) ) errors ON dateRange.d = errors._date
                              ORDER BY dateRange.d  " & variables.sortOrder;
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromYear", value = year(variables.fromDate), cfsqltype = "cf_sql_integer")
                                          .addParam(name = "toYear",   value = year(variables.toDate),   cfsqltype = "cf_sql_integer")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}