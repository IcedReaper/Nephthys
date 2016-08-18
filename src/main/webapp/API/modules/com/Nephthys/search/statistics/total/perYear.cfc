component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qLoginStats = new Query();
            
            var sql = "";
            var where = "";
            
            if(variables.userId != null) {
                where &= " AND userId = :userId";
                qLoginStats.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_integer");
            }
            
            sql = "         SELECT dateRange._date, searchStatistics.searchCount, searchStatistics.avgResultCount
                              FROM (SELECT dr _date
                                      FROM generate_series(:fromYear, :toYear) dr) dateRange
                   LEFT OUTER JOIN (  SELECT COUNT(*) searchCount,
                                             round(AVG(resultCount), 2) avgResultCount,
                                             date_part('year', ss.searchDate) _date
                                        FROM nephthys_search_statistics ss
                                       WHERE date_part('year', ss.searchDate) BETWEEN :fromYear AND :toYear "
                & where
                & "                 GROUP BY date_part('year', ss.searchDate)) searchStatistics ON dateRange._date = searchStatistics._date";
            var orderBy = " ORDER BY dateRange._date " & variables.sortOrder;
            
            variables.qRes = qLoginStats.setSQL(sql & orderBy)
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