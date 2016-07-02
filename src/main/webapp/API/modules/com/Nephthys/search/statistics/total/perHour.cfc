component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null) {
            var qLoginStats = new Query();
            
            var sql = "";
            var where = "";
            
            if(variables.userId != null) {
                where &= " AND userId = :userId";
                qLoginStats.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_integer");
            }
            
            sql = "         SELECT dateRange._date, searchStatistics.searchCount, searchStatistics.avgResultCount
                              FROM (SELECT dr _date
                                      FROM generate_series(0, 23) dr) dateRange
                   LEFT OUTER JOIN (  SELECT COUNT(*) searchCount,
                                             round(AVG(resultCount), 2) avgResultCount,
                                             date_part('hour', ss.searchDate) _date
                                        FROM nephthys_search_statistics ss
                                       WHERE date_trunc('day', ss.searchDate) = :date "
                & where
                & "                 GROUP BY date_part('hour', ss.searchDate)) searchStatistics ON dateRange._date = searchStatistics._date";
            var orderBy = " ORDER BY dateRange._date " & variables.sortOrder;
            
            variables.qRes = qLoginStats.setSQL(sql & orderBy)
                                        .addParam(name = "date", value = variables.fromDate, cfsqltype = "cf_sql_date")
                                        .execute()
                                        .getResult();
            
            return this;
        }
        else {
            throw(type = "application", message = "Start and/or end date isn't set");
        }
    }
}