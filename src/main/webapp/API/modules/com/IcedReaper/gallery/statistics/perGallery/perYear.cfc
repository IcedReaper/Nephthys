component extends="abstractPerGallery" {
    public statistic function execute() {
        // Get galleryRequestCount per galleryId and year 
        if(variables.fromDate != null && variables.toDate != null) {
            var qGalleryRequests = new Query();
            
            sql = "         SELECT gallery._date,
                                   CASE 
                                     WHEN stats.requestCount IS NOT NULL THEN 
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   gallery.galleryId
                              FROM (  SELECT COUNT(s.*) requestCount,
                                             date_part('year', s.visitDate) _date,
                                             s.galleryId
                                        FROM IcedReaper_gallery_statistics s
                                       WHERE date_part('year', s.visitDate) BETWEEN :fromYear AND :toYear
                                    GROUP BY date_part('year', s.visitDate), s.galleryId
                                   ) stats
                   FULL OUTER JOIN (SELECT i _date,
                                           gallery.galleryId
                                      FROM generate_series(:fromYear, :toYear) i,
                                           IcedReaper_gallery_gallery gallery
                                   ) gallery ON stats.galleryId = gallery.galleryId AND gallery._date = stats._date
                          ORDER BY gallery._date ASC, gallery.galleryId ASC";
            
            variables.qRes = qGalleryRequests.setSQL(sql)
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