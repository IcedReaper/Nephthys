component extends="abstractTotal" {
    public statistic function execute() {
        var qPageRequests = new Query();
        
        var sql = "";
        sql = "         SELECT dateRange.d _date, 
                               CASE
                                 WHEN pageRequests.requestCount IS NOT NULL THEN
                                   pageRequests.requestCount
                                 ELSE
                                   0
                               END requestCount
                          FROM (SELECT i d
                                  FROM generate_series(cast(extract(hour FROM now())+1 as integer), 23) i
                                UNION ALL
                                SELECT i d
                                  FROM generate_series(0, cast(extract(hour FROM now()) as integer)) i) dateRange
               LEFT OUTER JOIN (  SELECT COUNT(*) requestCount, date_part('Hour', visitDate) _date 
                                    FROM nephthys_page_statistics
                                   WHERE visitDate >= now() - '1 day' :: interval
                                GROUP BY date_part('Hour', visitDate)) pageRequests ON dateRange.d = pageRequests._date";
        
        variables.qRes = qPageRequests.setSQL(sql)
                                      .addParam(name = "date", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                      .execute()
                                      .getResult();
        
        return this;
    }
}