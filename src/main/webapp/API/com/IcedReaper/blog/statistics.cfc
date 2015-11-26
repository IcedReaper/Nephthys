component {
    public statistics function init() {
        return this;
    }
    
    public array function load(required numeric blogpostId, required date fromDate, required date toDate) {
        var qStatistics = new Query().setSQL("         SELECT dateRange.d, CASE WHEN statistics.count IS NOT NULL THEN statistics.count ELSE 0 END count
                                                         FROM (SELECT i :: date d 
                                                                 FROM generate_series(:fromDate, :toDate, '1 day' :: interval) i) dateRange
                                              LEFT OUTER JOIN (  SELECT to_date(to_char(s.openDate, 'mm/dd/yyyy'), 'mm/dd/yyyy') openDate, COUNT(*) count
                                                                   FROM IcedReaper_blog_statistics s
                                                                  WHERE s.blogpostId = :blogpostId
                                                               GROUP BY to_date(to_char(s.openDate, 'mm/dd/yyyy'), 'mm/dd/yyyy'), blogpostId) statistics ON dateRange.d = statistics.openDate")
                                     .addParam(name = "fromDate",   value = arguments.fromDate,  cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDate",     value = arguments.toDate,    cfsqltype = "cf_sql_date")
                                     .addParam(name = "blogpostId", value = arguments.blogpostId, cfsqltype = "cf_sql_numeric")
                                     .execute()
                                     .getResult();
        
        var statistics = [];
        for(var i = 1; i <= qStatistics.getRecordCount(); i++) {
            statistics.append({
                "date"  = qStatistics.d[i],
                "count" = qStatistics.count[i]
            });
        }
        
        return statistics;
    }
    
    public void function add(required numeric blogpostId) {
        new Query().setSQL("INSERT INTO IcedReaper_blogpost_statistics
                                        (
                                            blogpostId
                                        )
                                 VALUES (
                                            :blogpostId
                                        )")
                   .addParam(name = "blogpostId", value = arguments.blogpostId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
}