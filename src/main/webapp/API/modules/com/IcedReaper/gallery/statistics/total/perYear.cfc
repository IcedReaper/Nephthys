component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "";
            var innerQuery = "SELECT COUNT(*) requestCount, date_part('year', visitDate) _date 
                                FROM IcedReaper_gallery_statistics
                               WHERE date_part('year', visitDate) BETWEEN :fromYear AND :toYear ";
            
            if(variables.galleryId != null) {
                innerQuery &= " AND galleryId = :galleryId ";
                qPageRequests.addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric");
            }
            
            innerQuery &= " GROUP BY date_part('year', visitDate)";
            
            sql = "         SELECT dateRange.d _date, 
                                   CASE
                                     WHEN pageRequests.requestCount IS NOT NULL THEN
                                       pageRequests.requestCount
                                     ELSE
                                       0
                                   END requestCount
                              FROM (SELECT i d 
                                      FROM generate_series(:fromYear, :toYear) i) dateRange
                   LEFT OUTER JOIN ( " & innerQuery & " ) pageRequests ON dateRange.d = pageRequests._date
                          ORDER BY dateRange.d " & variables.sortOrder;
            
            variables.qRes = qPageRequests.setSQL(sql)
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