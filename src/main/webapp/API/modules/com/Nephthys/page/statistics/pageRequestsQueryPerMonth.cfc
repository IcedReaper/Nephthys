component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function setYear(required numeric year) {
        variables.fromDate = createDate(arguments.year, 1, 1);
        variables.toDate   = today();
    }
    
    public pageRequestQuery function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qPageRequests = new Query();
            
            var sql = "";
            var innerQuery = "SELECT COUNT(*) requestCount, date_trunc('month', visitDate) _date 
                                FROM nephthys_page_statistics
                               WHERE date_trunc('month', visitDate) >= :fromDate
                                 AND date_trunc('month', visitDate) <= :toDate ";
            
            if(variables.pageId != null) {
                innerQuery &= " AND pageId = :pageId ";
                qPageRequests.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
            }
            
            innerQuery &= " GROUP BY date_trunc('month', visitDate)";
            
            sql = "         SELECT to_char(dateRange.d, 'MM') _date, 
                                   CASE
                                     WHEN pageRequests.requestCount IS NOT NULL THEN
                                       pageRequests.requestCount
                                     ELSE
                                       0
                                   END requestCount
                              FROM (SELECT i :: date d 
                                      FROM generate_series(:fromDate, :toDate, '1 month' :: interval) i) dateRange
                   LEFT OUTER JOIN ( " & innerQuery & " ) pageRequests ON dateRange.d = pageRequests._date
                          ORDER BY dateRange.d " & variables.sortOrder;
            
            variables.prq = qPageRequests.setSQL(sql)
                                         .addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                         .addParam(name = "toDate",   value = variables.toDate,   cfsqltype = "cf_sql_date")
                                         .execute();
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}