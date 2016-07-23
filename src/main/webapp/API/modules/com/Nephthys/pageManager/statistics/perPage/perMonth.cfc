component extends="abstractPerPage" {
    public statistic function execute() {
        // Get pageRequestCount per pageId and date for a specific month
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            // the truncated dates are required for the series as they have to be on the first of every month
            var fromDateTruncated = createDate(year(variables.fromDate), month(variables.fromDate), 1);
            var toDateTruncated   = createDate(year(variables.toDate), month(variables.toDate), 1);
            
            sql = "         SELECT page._date,
                                   CASE 
                                     WHEN stats.requestCount IS NOT NULL THEN 
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   page.pageId
                              FROM (SELECT i :: date _date,
                                           page.pageId
                                      FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 month' :: interval) i,
                                           (    SELECT DISTINCT p.pageId
                                                  FROM nephthys_page_page p
                                            INNER JOIN nephthys_page_sitemapPage sp ON p.pageId     = sp.pageId
                                            INNER JOIN nephthys_page_sitemap     sm ON sp.sitemapId = sm.sitemapId
                                            INNER JOIN nephthys_page_region      r  ON sp.regionId  = r.regionId
                                                 WHERE r.showInStatistics = true
                                           ) page
                                   ) page
                   LEFT OUTER JOIN (    SELECT COUNT(s.*) requestCount,
                                               date_trunc('month', s.visitDate) _date,
                                               s.pageId
                                          FROM nephthys_page_statistics s
                                    INNER JOIN nephthys_page_region r ON s.regionId = r.regionId
                                         WHERE date_trunc('day', s.visitDate) >= :fromDate
                                           AND date_trunc('day', s.visitDate) <= :toDate
                                           AND r.showInStatistics = true
                                      GROUP BY date_trunc('month', s.visitDate), s.pageId
                                   ) stats ON page.pageId = stats.pageId AND page._date = stats._date
                          ORDER BY page._date " & variables.sortOrder & ", page.pageId ASC";
            
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