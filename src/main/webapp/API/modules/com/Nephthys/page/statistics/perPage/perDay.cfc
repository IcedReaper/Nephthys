component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function execute() {
        // Get pageRequestCount per pageId and date for a specific month
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            sql = "         SELECT page._date,
                                   CASE 
                                     WHEN stats.requestCount IS NOT NULL THEN 
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   page.pageId
                              FROM (  SELECT COUNT(s.*) requestCount,
                                             date_trunc('day', s.visitDate) _date,
                                             s.pageId
                                        FROM nephthys_page_statistics s
                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                         AND date_trunc('day', s.visitDate) <= :toDate
                                    GROUP BY date_trunc('day', s.visitDate), s.pageId
                                   ) stats
                   FULL OUTER JOIN (SELECT i :: date _date,
                                           page.pageId
                                      FROM generate_series(:fromDate, :toDate, '1 day' :: interval) i,
                                           nephthys_page_page page
                                   ) page ON stats.pageId = page.pageId AND page._date = stats._date
                          ORDER BY page._date " & variables.sortOrder & ", page.pageId ASC";
            
            variables.prq = qPageRequests.setSQL(sql)
                                         .addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                         .addParam(name = "toDate",   value = variables.toDate,   cfsqltype = "cf_sql_date")
                                         .execute();
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}