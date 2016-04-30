component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function setYear(required numeric year) {
        variables.fromDate = createDate(arguments.year, 1, 1);
        variables.toDate   = today();
    }
    
    public pageRequestQuery function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            variables.prq = new Query().setSQL("         SELECT to_char(dateRange.d, 'MM') _date, 
                                                                CASE
                                                                  WHEN pageRequests.requestCount IS NOT NULL THEN
                                                                    pageRequests.requestCount
                                                                  ELSE
                                                                    0
                                                                END requestCount
                                                           FROM (SELECT i :: date d 
                                                                   FROM generate_series(:fromDate, :toDate, '1 month' :: interval) i) dateRange
                                                LEFT OUTER JOIN (  SELECT COUNT(*) requestCount, date_trunc('month', visitDate) _date 
                                                                     FROM nephthys_statistics
                                                                    WHERE date_trunc('month', visitDate) >= :fromDate
                                                                      AND date_trunc('month', visitDate) <= :toDate
                                                                 GROUP BY date_trunc('month', visitDate)) pageRequests ON dateRange.d = pageRequests._date
                                                       ORDER BY dateRange.d")
                                       .addParam(name = "fromDate", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                       .addParam(name = "toDate", value = variables.toDate,     cfsqltype = "cf_sql_date")
                                       .execute();
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}