component extends="abstractPerPage" {
    public statistic function execute() {
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
                              FROM (SELECT i _date,
                                           page.pageId
                                      FROM generate_series(:fromYear, :toYear) i,
                                           (    SELECT DISTINCT p.pageId
                                                  FROM nephthys_page_page p
                                            INNER JOIN nephthys_page_sitemapPage sp ON p.pageId     = sp.pageId
                                            INNER JOIN nephthys_page_sitemap     sm ON sp.sitemapId = sm.sitemapId
                                            INNER JOIN nephthys_page_region      r  ON sp.regionId  = r.regionId
                                                 WHERE r.showInStatistics = true
                                           ) page
                                   ) page
                   LEFT OUTER JOIN (    SELECT COUNT(s.*) requestCount,
                                               date_part('year', s.visitDate) _date,
                                               s.pageId
                                          FROM nephthys_page_statistics s
                                    INNER JOIN nephthys_page_region r ON s.regionId = r.regionId
                                         WHERE date_part('year', s.visitDate) BETWEEN :fromYear AND :toYear
                                           AND r.showInStatistics = true
                                      GROUP BY date_part('year', s.visitDate), s.pageId
                                   ) stats ON page.pageId = stats.pageId AND page._date = stats._date
                          ORDER BY page._date " & variables.sortOrder & ", page.pageId ASC";
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromYear", value = year(variables.fromDate), cfsqltype = "cf_sql_integer")
                                          .addParam(name = "toYear",   value = year(variables.toDate),   cfsqltype = "cf_sql_integer")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}