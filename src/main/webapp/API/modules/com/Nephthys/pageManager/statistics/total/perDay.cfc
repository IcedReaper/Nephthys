component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "";
            var innerQuery = "    SELECT COUNT(*) requestCount, date_trunc('day', visitDate) _date 
                                    FROM nephthys_page_statistics s
                              INNER JOIN nephthys_page_region r ON s.regionId = r.regionId
                                   WHERE date_trunc('day', visitDate) >= :fromDate
                                     AND date_trunc('day', visitDate) <= :toDate ";
            
            if(variables.pageId != null) {
                innerQuery &= " AND pageId = :pageId ";
                qPageRequests.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
            }
            else {
                innerQuery &= " AND r.showInStatistics = true ";
            }
            
            innerQuery &= " GROUP BY date_trunc('day', visitDate)";
            
            sql = "         SELECT dateRange.d _date, 
                                   CASE
                                     WHEN pageRequests.requestCount IS NOT NULL THEN
                                       pageRequests.requestCount
                                     ELSE
                                       0
                                   END requestCount
                              FROM (SELECT i :: date d 
                                      FROM generate_series(:fromDate, :toDate, '1 day' :: interval) i) dateRange
                   LEFT OUTER JOIN ( " & innerQuery & " ) pageRequests ON dateRange.d = pageRequests._date
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