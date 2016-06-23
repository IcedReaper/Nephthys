component extends="abstractPerGallery" {
    public statistic function execute() {
        // Get galleryRequestCount per galleryId and hour for a specific date
        if(variables.fromDate != null) {
            var qGalleryRequests = new Query();
            
            sql = "         SELECT CASE
                                     WHEN stats.requestCount IS NOT NULL THEN
                                       stats.requestCount
                                     ELSE
                                       0
                                   END requestCount,
                                   gallery._date,
                                   gallery.galleryId
                              FROM (  SELECT COUNT(s.*) requestCount,
                                             date_part('Hour', s.visitDate) _date,
                                             s.galleryId
                                        FROM icedreaper_gallery_statistics s
                                       WHERE date_trunc('day', s.visitDate) >= :fromDate
                                    GROUP BY date_part('Hour', s.visitDate), s.galleryId
                                   ) stats
                   FULL OUTER JOIN (SELECT i _date, gallery.galleryId
                                      FROM generate_series(0, 23) i,
                                           icedreaper_gallery_gallery gallery
                                   ) gallery ON stats.galleryId = gallery.galleryId AND gallery._date = stats._date
                          ORDER BY gallery._date " & variables.sortOrder & ", gallery.galleryId ASC";
            
            variables.qRes = qGalleryRequests.setSQL(sql)
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