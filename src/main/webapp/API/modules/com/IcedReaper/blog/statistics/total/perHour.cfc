component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null) {
            var qPageRequests = new Query();
            
            var sql = "";
            var innerQuery = "SELECT COUNT(*) requestCount, date_part('Hour', visitDate) _date 
                                FROM IcedReaper_blog_statistics
                               WHERE date_trunc('day', visitDate) >= :date ";
            
            if(variables.blogpostId != null) {
                innerQuery &= " AND blogpostId = :blogpostId ";
                qPageRequests.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
            }
            
            innerQuery &= " GROUP BY date_part('Hour', visitDate)";
            
            sql = "         SELECT dateRange.d _date, 
                                   CASE
                                     WHEN pageRequests.requestCount IS NOT NULL THEN
                                       pageRequests.requestCount
                                     ELSE
                                       0
                                   END requestCount
                              FROM (SELECT i d
                                      FROM generate_series(0, 23) i) dateRange
                   LEFT OUTER JOIN ( " & innerQuery & " ) pageRequests ON dateRange.d = pageRequests._date
                          ORDER BY dateRange.d " & variables.sortOrder;
            
            
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