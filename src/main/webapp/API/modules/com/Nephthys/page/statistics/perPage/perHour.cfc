component extends="abstractPerPage" {
    public statistic function execute() {
        // Get pageRequestCount per pageId and hour for a specific date
        if(variables.fromDate != null) {
            var qPageRequests = new Query();
            
            sql = "         SELECT CASE
                                     WHEN stats.requestCount IS NOT NULL THEN
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   page._date,
                                   page.pageId
                              FROM (  SELECT COUNT(s.*) requestCount,
                                             date_part('Hour', s.visitDate) _date,
                                             s.pageId
                                        FROM nephthys_page_statistics s
                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                    GROUP BY date_part('Hour', s.visitDate), s.pageId
                                   ) stats
                   FULL OUTER JOIN (SELECT i _date, page.pageId
                                      FROM generate_series(0, 23) i,
                                           nephthys_page_page page
                                   ) page ON stats.pageId = page.pageId AND page._date = stats._date
                          ORDER BY page._date " & variables.sortOrder & ", page.pageId ASC";
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}