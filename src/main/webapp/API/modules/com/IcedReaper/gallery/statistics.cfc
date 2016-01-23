component {
    public statistics function init() {
        return this;
    }
    
    public array function load(required numeric galleryId, required date fromDate, required date toDate) {
        var qStatistics = new Query().setSQL("         SELECT dateRange.d, CASE WHEN statistics.count IS NOT NULL THEN statistics.count ELSE 0 END count
                                                         FROM (SELECT i :: date d 
                                                                 FROM generate_series(:fromDate, :toDate, '1 day' :: interval) i) dateRange
                                              LEFT OUTER JOIN (  SELECT to_date(to_char(s.openDate, 'mm/dd/yyyy'), 'mm/dd/yyyy') openDate, COUNT(*) count
                                                                   FROM IcedReaper_gallery_statistics s
                                                                  WHERE s.galleryId = :galleryId
                                                               GROUP BY to_date(to_char(s.openDate, 'mm/dd/yyyy'), 'mm/dd/yyyy'), galleryId) statistics ON dateRange.d = statistics.openDate")
                                     .addParam(name = "fromDate",  value = arguments.fromDate,  cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDate",    value = arguments.toDate,    cfsqltype = "cf_sql_date")
                                     .addParam(name = "galleryId", value = arguments.galleryId, cfsqltype = "cf_sql_numeric")
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
    
    public void function add(required numeric galleryId) {
        new Query().setSQL("INSERT INTO IcedReaper_gallery_statistics
                                        (
                                            galleryId
                                        )
                                 VALUES (
                                            :galleryId
                                        )")
                   .addParam(name = "galleryId", value = arguments.galleryId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
}