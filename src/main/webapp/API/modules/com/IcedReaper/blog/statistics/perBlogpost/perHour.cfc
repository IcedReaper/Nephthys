component extends="abstractPerBlogpost" {
    public statistic function execute() {
        if(variables.fromDate != null) {
            var qblogpostRequests = new Query();
            
            sql = "         SELECT CASE
                                     WHEN stats.requestCount IS NOT NULL THEN
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   blogpost._date,
                                   blogpost.blogpostId
                              FROM (  SELECT COUNT(s.*) requestCount,
                                             date_part('Hour', s.visitDate) _date,
                                             s.blogpostId
                                        FROM IcedReaper_blog_statistics s
                                       WHERE date_trunc('day', s.visitDate) = :fromDate
                                    GROUP BY date_part('Hour', s.visitDate), s.blogpostId
                                   ) stats
                   FULL OUTER JOIN (SELECT i _date, blogpost.blogpostId
                                      FROM generate_series(0, 23) i,
                                           IcedReaper_blog_blogpost blogpost
                                   ) blogpost ON stats.blogpostId = blogpost.blogpostId AND blogpost._date = stats._date
                          ORDER BY blogpost._date " & variables.sortOrder & ", blogpost.blogpostId ASC";
            
            variables.qRes = qblogpostRequests.setSQL(sql)
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