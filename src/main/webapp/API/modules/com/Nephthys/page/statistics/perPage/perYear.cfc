component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function execute() {
        // Get pageRequestCount per pageId and year 
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
                                             date_part('year', s.visitDate) _date,
                                             s.pageId
                                        FROM nephthys_page_statistics s
                                       WHERE date_part('year', s.visitDate) BETWEEN :fromYear AND :toYear
                                    GROUP BY date_part('year', s.visitDate), s.pageId
                                   ) stats
                   FULL OUTER JOIN (SELECT i _date,
                                           page.pageId
                                      FROM generate_series(:fromYear, :toYear) i,
                                           nephthys_page_page page
                                   ) page ON stats.pageId = page.pageId AND page._date = stats._date
                          ORDER BY page._date ASC, page.pageId ASC";
            
            variables.prq = qPageRequests.setSQL(sql)
                                         .addParam(name = "fromYear", value = year(variables.fromDate), cfsqltype = "cf_sql_integer")
                                         .addParam(name = "toYear",   value = year(variables.fromDate), cfsqltype = "cf_sql_integer")
                                         .execute();
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}