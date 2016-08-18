component extends="abstractPerBlogpost" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qblogpostRequests = new Query();
            
            sql = "         SELECT blogpost._date,
                                   CASE 
                                     WHEN stats.requestCount IS NOT NULL THEN 
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   blogpost.blogpostId
                              FROM (  SELECT COUNT(s.*) requestCount,
                                             date_trunc('month', s.visitDate) _date,
                                             s.blogpostId
                                        FROM IcedReaper_blog_statistics s
                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                         AND date_trunc('day', s.visitDate) <= :toDate
                                    GROUP BY date_trunc('month', s.visitDate), s.blogpostId
                                   ) stats
                   FULL OUTER JOIN (SELECT i :: date _date,
                                           blogpost.blogpostId
                                      FROM generate_series(:fromDate, :toDate, '1 month' :: interval) i,
                                           IcedReaper_blog_blogpost blogpost
                                   ) blogpost ON stats.blogpostId = blogpost.blogpostId AND blogpost._date = stats._date
                          ORDER BY blogpost._date " & variables.sortOrder & ", blogpost.blogpostId ASC";
            
            variables.qRes = qblogpostRequests.setSQL(sql)
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