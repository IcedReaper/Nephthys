component extends="abstractPerGallery" {
    public statistic function execute() {
        // Get galleryRequestCount per galleryId and date for a specific month
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
                                             date_trunc('month', s.visitDate) _date,
                                             s.galleryId
                                        FROM IcedReaper_gallery_statistics s
                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                         AND date_trunc('day', s.visitDate) <= :toDate
                                    GROUP BY date_trunc('month', s.visitDate), s.galleryId
                                   ) stats
                   FULL OUTER JOIN (SELECT i :: date _date,
                                           gallery.galleryId
                                      FROM generate_series(:fromDate, :toDate, '1 month' :: interval) i,
                                           IcedReaper_gallery_gallery gallery
                                   ) gallery ON stats.galleryId = gallery.galleryId AND gallery._date = stats._date
                          ORDER BY gallery._date " & variables.sortOrder & ", gallery.galleryId ASC";
            
            variables.qRes = qGalleryRequests.setSQL(sql)
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