component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            // the truncated dates are required for the series as they have to be on the first of every month
            var fromDateTruncated = createDate(year(variables.fromDate), month(variables.fromDate), 1);
            var toDateTruncated   = createDate(year(variables.toDate), month(variables.toDate), 1);
            
            var sql = "         SELECT dateRange.d _date,
                                       CASE
                                         WHEN errors.errorCount IS NOT NULL THEN
                                           errors.errorCount
                                         ELSE
                                           0
                                       END errorCount
                                  FROM (SELECT i :: date d 
                                          FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 Month' :: interval) i) dateRange
                       LEFT OUTER JOIN (    SELECT COUNT(*) errorCount, date_trunc('Month', errorDate) _date
                                              FROM nephthys_error s
                                             WHERE date_trunc('day', errorDate) >= :fromDate
                                               AND date_trunc('day', errorDate) <= :toDate
                                          GROUP BY date_trunc('Month', errorDate) ) errors ON dateRange.d = errors._date
                              ORDER BY dateRange.d  " & variables.sortOrder;
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromDateTruncated", value = fromDateTruncated,  cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDateTruncated",   value = toDateTruncated,    cfsqltype = "cf_sql_date")
                                          .addParam(name = "fromDate",          value = variables.fromDate, cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDate",            value = variables.toDate,   cfsqltype = "cf_sql_date")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}