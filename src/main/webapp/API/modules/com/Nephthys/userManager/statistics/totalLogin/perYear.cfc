component extends="abstractTotal" {
    public statistic function execute() {
        if(variables.fromDate != null && variables.toDate != null) {
            var qLoginStats = new Query();
            
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
                                   FROM (         SELECT i _date
                                                    FROM generate_series(:fromYear, :toYear) i) dateRange
                                         LEFT OUTER JOIN (  SELECT COUNT(*) loginCount,
                                                                   date_part('year', loginDate) _date
                                                              FROM nephthys_user_statistics
                                                             WHERE date_part('year', loginDate) BETWEEN :fromYear AND :toYear
                                                               AND successful = :successful "
                                                                 & extWhere & "
                                                          GROUP BY date_part('year', loginDate)
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
                               FROM (         SELECT i _date
                                                FROM generate_series(:fromYear, :toYear) i) dateRange
                                     LEFT OUTER JOIN (  SELECT COUNT(*) loginCount,
                                                               date_part('year', loginDate) _date
                                                          FROM nephthys_user_statistics
                                                         WHERE date_part('year', loginDate) BETWEEN :fromYear AND :toYear
                                                           AND successful = :failed "
                                                                 & extWhere & "
                                                      GROUP BY date_part('year', loginDate)
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