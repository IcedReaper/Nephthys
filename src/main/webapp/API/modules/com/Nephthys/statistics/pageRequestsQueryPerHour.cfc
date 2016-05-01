component extends="API.abstractClasses.pageRequestQuery" {
    public pageRequestQuery function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            variables.prq = new Query().setSQL("          SELECT dateRange.d _date, 
                                                            CASE
                                                              WHEN pageRequests.requestCount IS NOT NULL THEN
                                                                pageRequests.requestCount
                                                              ELSE
                                                                0
                                                            END requestCount
                                                           FROM (SELECT i d
                                                                FROM generate_series(1, 24) i) dateRange
                                                LEFT OUTER JOIN (  SELECT COUNT(*) requestCount, date_part('Hour', visitDate) _date 
                                                                     FROM nephthys_statistics
                                                                    WHERE date_trunc('day', visitDate) >= :date
                                                                 GROUP BY date_part('Hour', visitDate)) pageRequests ON dateRange.d = pageRequests._date
                                                       ORDER BY dateRange.d")
                                       .addParam(name = "date", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                       .execute();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}