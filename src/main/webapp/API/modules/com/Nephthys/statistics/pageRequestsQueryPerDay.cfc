component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            variables.prq = new Query().setSQL("         SELECT dateRange.d _date, 
                                                                CASE
                                                                  WHEN pageRequests.requestCount IS NOT NULL THEN
                                                                    pageRequests.requestCount
                                                                  ELSE
                                                                    0
                                                                END requestCount
                                                           FROM (SELECT i :: date d 
                                                                   FROM generate_series(:fromDate, :toDate, '1 day' :: interval) i) dateRange
                                                LEFT OUTER JOIN (  SELECT COUNT(*) requestCount, date_trunc('day', visitDate) _date 
                                                                     FROM nephthys_statistics
                                                                    WHERE date_trunc('day', visitDate) >= :fromDate
                                                                      AND date_trunc('day', visitDate) <= :toDate
                                                                 GROUP BY date_trunc('day', visitDate)) pageRequests ON dateRange.d = pageRequests._date
                                                       ORDER BY dateRange.d")
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