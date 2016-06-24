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
                                             date_part('year', s.visitDate) _date,
                                             s.blogpostId
                                        FROM IcedReaper_blog_statistics s
                                       WHERE date_part('year', s.visitDate) BETWEEN :fromYear AND :toYear
                                    GROUP BY date_part('year', s.visitDate), s.blogpostId
                                   ) stats
                   FULL OUTER JOIN (SELECT i _date,
                                           blogpost.blogpostId
                                      FROM generate_series(:fromYear, :toYear) i,
                                           IcedReaper_blog_blogpost blogpost
                                   ) blogpost ON stats.blogpostId = blogpost.blogpostId AND blogpost._date = stats._date
                          ORDER BY blogpost._date ASC, blogpost.blogpostId ASC";
            
            variables.qRes = qblogpostRequests.setSQL(sql)
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