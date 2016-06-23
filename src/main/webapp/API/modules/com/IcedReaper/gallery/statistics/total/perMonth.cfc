component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            // the truncated dates are required for the series as they have to be on the first of every month
            var fromDateTruncated = createDate(year(variables.fromDate), month(variables.fromDate), 1);
            var toDateTruncated   = createDate(year(variables.toDate), month(variables.toDate), 1);
            
            var sql = "";
            var innerQuery = "SELECT COUNT(*) requestCount, date_trunc('month', visitDate) _date 
                                FROM IcedReaper_gallery_statistics
                               WHERE date_trunc('day', visitDate) >= :fromDate
                                 AND date_trunc('day', visitDate) <= :toDate ";
            
            if(variables.galleryId != null) {
                innerQuery &= " AND galleryId = :galleryId ";
                qPageRequests.addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric");
            }
            
            innerQuery &= " GROUP BY date_trunc('month', visitDate)";
            
            sql = "         SELECT dateRange.d _date, 
                                   CASE
                                     WHEN pageRequests.requestCount IS NOT NULL THEN
                                       pageRequests.requestCount
                                     ELSE
                                       0
                                   END requestCount
                              FROM (SELECT i :: date d 
                                      FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 month' :: interval) i) dateRange
                   LEFT OUTER JOIN ( " & innerQuery & " ) pageRequests ON dateRange.d = pageRequests._date
                          ORDER BY dateRange.d " & variables.sortOrder;
            
            variables.qRes = qPageRequests.setSQL(sql)
                                          .addParam(name = "fromDateTruncated", value = fromDateTruncated,  cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDateTruncated",   value = toDateTruncated,    cfsqltype = "cf_sql_date")
                                          .addParam(name = "fromDate",          value = variables.fromDate, cfsqltype = "cf_sql_date")
                                          .addParam(name = "toDate",            value = variables.toDate,   cfsqltype = "cf_sql_date")
                                          .execute()
                                          .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}