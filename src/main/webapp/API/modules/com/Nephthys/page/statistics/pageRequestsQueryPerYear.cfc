component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "";
            var innerQuery = "SELECT COUNT(*) requestCount, date_part('year', visitDate) _date 
                                FROM nephthys_page_statistics
                               WHERE date_trunc('month', visitDate) >= :fromDate
                                 AND date_trunc('month', visitDate) <= :toDate ";
            
            if(variables.pageId != null) {
                innerQuery &= " AND pageId = :pageId ";
                qPageRequests.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
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
            
            variables.prq = qPageRequests.setSQL(sql)
                                         .addParam(name = "fromDate", value = variables.fromDate,       cfsqltype = "cf_sql_date")
                                         .addParam(name = "toDate",   value = variables.toDate,         cfsqltype = "cf_sql_date")
                                         .addParam(name = "fromYear", value = year(variables.fromDate), cfsqltype = "cf_sql_integer")
                                         .addParam(name = "toYear",   value = year(variables.toDate),   cfsqltype = "cf_sql_integer")
                                         .execute();
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}