component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qLoginStats = new Query();
            var fromDateTruncated = createDate(year(variables.fromDate), month(variables.fromDate), 1);
            var toDateTruncated   = createDate(year(variables.toDate), month(variables.toDate), 1);
            
            var sql = "";
            var where = "";
            
            if(variables.userId != null) {
                where &= " AND userId = :userId";
                qLoginStats.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_integer");
            }
            
            sql = "         SELECT dateRange._date, searchStatistics.searchCount, searchStatistics.avgResultCount
                              FROM (SELECT dr :: date _date
                                      FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 month' :: interval) dr) dateRange
                   LEFT OUTER JOIN (  SELECT COUNT(*) searchCount,
                                             round(AVG(resultCount), 2) avgResultCount,
                                             date_trunc('month', ss.searchDate) _date
                                        FROM nephthys_search_statistics ss
                                       WHERE date_trunc('day', ss.searchDate) >= :fromDate
                                         AND date_trunc('day', ss.searchDate) <= :toDate "
                & where
                & "                 GROUP BY date_trunc('month', ss.searchDate)) searchStatistics ON dateRange._date = searchStatistics._date";
            var orderBy = " ORDER BY dateRange._date " & variables.sortOrder;
            
            variables.qRes = qLoginStats.setSQL(sql & orderBy)
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