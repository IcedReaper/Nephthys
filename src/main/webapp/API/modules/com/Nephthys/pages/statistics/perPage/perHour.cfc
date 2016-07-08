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
                              FROM (SELECT i _date, page.pageId
                                      FROM generate_series(0, 23) i,
                                           (    SELECT DISTINCT p.pageId
                                                  FROM nephthys_page_page p
                                            INNER JOIN nephthys_page_sitemapPage sp ON p.pageId     = sp.pageId
                                            INNER JOIN nephthys_page_sitemap     sm ON sp.sitemapId = sm.sitemapId
                                            INNER JOIN nephthys_page_region      r  ON sp.regionId  = r.regionId
                                                 WHERE r.showInStatistics = true
                                           ) page
                                   ) page
                   LEFT OUTER JOIN (    SELECT COUNT(s.*) requestCount,
                                               date_part('Hour', s.visitDate) _date,
                                               s.pageId
                                          FROM nephthys_page_statistics s
                                    INNER JOIN nephthys_page_region r ON s.regionId = r.regionId
                                         WHERE date_trunc('day', s.visitDate) >= :fromDate
                                           AND r.showInStatistics = true
                                      GROUP BY date_part('Hour', s.visitDate), s.pageId
                                   ) stats ON page.pageId = stats.pageId AND page._date = stats._date
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