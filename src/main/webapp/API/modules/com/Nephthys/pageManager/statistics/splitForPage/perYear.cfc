component extends="abstractSplitPerPage" {
    public statistic function execute() {
        // Get pageRequestCount per completeLink and year for a specific siteId
        if(variables.fromDate != null && variables.toDate != null && variables.pageId != null) {
            var qPageRequests = new Query();
            
            sql = "         SELECT tmp1._date, 
                                   CASE 
                                     WHEN tmp2.requestCount IS NOT NULL THEN
                                       tmp2.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   tmp1.completeLink
                              FROM (SELECT DISTINCT inter._date,
                                                    stats.completeLink,
                                                    0 requestCount
                                      FROM (SELECT i _date
                                              FROM generate_series(:fromYear, :toYear) i) inter,
                                                   (  SELECT COUNT(s.*) requestCount,
                                                             date_part('year', s.visitDate) _date,
                                                             s.completeLink
                                                        FROM nephthys_page_statistics s
                                                       WHERE date_part('year', s.visitDate) BETWEEN :fromYear AND :toYear
                                                         AND s.pageId = 3
                                                    GROUP BY date_part('year', s.visitDate), s.completeLink) stats
                                            ORDER BY inter._date, stats.completeLink
                                           ) tmp1
                   FULL OUTER JOIN (  SELECT COUNT(s.*) requestCount,
                                             date_part('year', s.visitDate) _date,
                                             s.completeLink
                                        FROM nephthys_page_statistics s
                                       WHERE date_part('year', s.visitDate) BETWEEN :fromYear AND :toYear
                                         AND s.pageId = 3
                                    GROUP BY date_part('year', s.visitDate), s.completeLink
                                   ) tmp2 ON tmp1._date = tmp2._date AND tmp1.completeLink = tmp2.completeLink
                          ORDER BY tmp1._date " & variables.sortOrder & ", tmp1.completeLink ASC";
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromYear", value = year(variables.fromDate), cfsqltype = "cf_sql_integer")
                                          .addParam(name = "toYear",   value = year(variables.toDate),   cfsqltype = "cf_sql_integer")
                                          .addParam(name = "pageId",   value = variables.pageId,         cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}