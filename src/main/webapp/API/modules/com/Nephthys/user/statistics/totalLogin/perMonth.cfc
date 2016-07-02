component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qLoginStats = new Query();
            
            // the truncated dates are required for the series as they have to be on the first of every month
            var fromDateTruncated = createDate(year(variables.fromDate), month(variables.fromDate), 1);
            var toDateTruncated   = createDate(year(variables.toDate), month(variables.toDate), 1);
            
            var sql = "";
            var successfulSQL = "";
            var failedSQL = "";
            var extWhere = "";
            
            sql = "SELECT * FROM (";
            
            if(variables.userName != null) {
                extWhere &= " AND lower(userName) = :userName";
                qLoginStats.addParam(name = "userName", value = lCase(variables.userName), cfsqltype = "cf_sql_varchar");
            }
            
            if(variables.successful == null || variables.successful) {
                successfulSQL = "SELECT dateRange._date,
                                        CASE
                                          WHEN logins.loginCount IS NOT NULL THEN
                                            logins.loginCount
                                          ELSE
                                            0
                                          END loginCount,
                                          true as successful
                                   FROM (         SELECT i :: date _date
                                                    FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 month' :: interval) i) dateRange
                                         LEFT OUTER JOIN (  SELECT COUNT(*) loginCount,
                                                                   date_trunc('month', loginDate) _date
                                                              FROM nephthys_user_statistics
                                                             WHERE date_trunc('day', loginDate) >= :fromDate
                                                               AND date_trunc('day', loginDate) <= :toDate
                                                               AND successful = :successful "
                                                                 & extWhere & "
                                                          GROUP BY date_trunc('month', loginDate)
                                                         ) logins ON dateRange._date = logins._date";
                
                qLoginStats.addParam(name = "successful", value = true, cfsqltype = "cf_sql_bit");
            }
            
            if(variables.successful == null || ! variables.successful) {
                failedSQL = "SELECT dateRange._date,
                                    CASE
                                      WHEN logins.loginCount IS NOT NULL THEN
                                        logins.loginCount
                                      ELSE
                                        0
                                      END loginCount,
                                      false as successful
                               FROM (         SELECT i :: date _date
                                                FROM generate_series(:fromDateTruncated, :toDateTruncated, '1 month' :: interval) i) dateRange
                                     LEFT OUTER JOIN (  SELECT COUNT(*) loginCount,
                                                               date_trunc('month', loginDate) _date
                                                          FROM nephthys_user_statistics
                                                         WHERE date_trunc('day', loginDate) >= :fromDate
                                                           AND date_trunc('day', loginDate) <= :toDate
                                                           AND successful = :failed "
                                                                 & extWhere & "
                                                      GROUP BY date_trunc('month', loginDate)
                                                     ) logins ON dateRange._date = logins._date";
                
                qLoginStats.addParam(name = "failed", value = false, cfsqltype = "cf_sql_bit");
            }
            
            if(successfulSQL != "") {
                sql &= successfulSQL;
            }
            
            if(failedSQL != "") {
                if(successfulSQL != "") {
                    sql &= " UNION ALL ";
                }
                sql &= failedSQL;
            }
            
            sql &= ") sq "
            var orderBy = " ORDER BY sq._date " & variables.sortOrder;
            
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