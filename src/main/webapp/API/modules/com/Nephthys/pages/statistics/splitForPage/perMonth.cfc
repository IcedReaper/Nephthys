component extends="abstractSplitPerPage" {
    public statistic function execute() {
        // Get pageRequestCount per completeLink and month for a specific siteId and year
        if(variables.fromDate != null && variables.toDate != null && variables.pageId != null) {
            var qPageRequests = new Query();
            
            // the truncated dates are required for the series as they have to be on the first of every month
            var fromDateTruncated = createDate(year(variables.fromDate), month(variables.fromDate), 1);
            var toDateTruncated   = createDate(year(variables.toDate), month(variables.toDate), 1);
            
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
                                      FROM (SELECT i :: date _date
                                              FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 month' :: interval) i) inter,
                                                   (  SELECT COUNT(s.*) requestCount,
                                                             date_trunc('month', s.visitDate) _date,
                                                             s.completeLink
                                                        FROM nephthys_page_statistics s
                                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                                         AND date_trunc('day', s.visitDate) <= :toDate
                                                         AND s.pageId = 3
                                                    GROUP BY date_trunc('month', s.visitDate), s.completeLink) stats
                                            ORDER BY inter._date, stats.completeLink
                                           ) tmp1
                   FULL OUTER JOIN (  SELECT COUNT(s.*) requestCount,
                                             date_trunc('month', s.visitDate) _date,
                                             s.completeLink
                                        FROM nephthys_page_statistics s
                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                         AND date_trunc('day', s.visitDate) <= :toDate
                                         AND s.pageId = 3
                                    GROUP BY date_trunc('month', s.visitDate), s.completeLink
                                   ) tmp2 ON tmp1._date = tmp2._date AND tmp1.completeLink = tmp2.completeLink
                          ORDER BY tmp1._date " & variables.sortOrder & ", tmp1.completeLink ASC";
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromDateTruncated", value = fromDateTruncated,  cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDateTruncated",   value = toDateTruncated,    cfsqltype = "cf_sql_date")
                                          .addParam(name = "fromDate",          value = variables.fromDate, cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDate",            value = variables.toDate,   cfsqltype = "cf_sql_date")
                                          .addParam(name = "pageId",            value = variables.pageId,   cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}