component extends="abstractTotal" {
    public statistic function execute() {
        var qPageRequests = new Query();
        
        var sql = "";
        sql = "         SELECT dateRange.d _date, 
                               CASE
                                 WHEN errors.errorCount IS NOT NULL THEN
                                   errors.errorCount
                                 ELSE
                                   0
                               END errorCount
                          FROM (SELECT i d
                                  FROM generate_series(cast(extract(hour FROM now())+1 as integer), 23) i
                                UNION ALL
                                SELECT i d
                                  FROM generate_series(0, cast(extract(hour FROM now()) as integer)) i) dateRange
               LEFT OUTER JOIN (    SELECT COUNT(s.*) errorCount, date_part('Hour', s.errorDate) _date 
                                      FROM nephthys_error s
                                     WHERE s.errorDate >= now() - '1 day' :: interval
                                  GROUP BY date_part('Hour', s.errorDate)) errors ON dateRange.d = errors._date";
        
        variables.qRes = qPageRequests.setSQL(sql)
                                      .addParam(name = "date", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                      .execute()
                                      .getResult();
        
        return this;
    }
}