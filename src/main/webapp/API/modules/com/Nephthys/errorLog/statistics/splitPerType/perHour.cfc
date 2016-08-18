component extends="abstractSplitPerType" {
    public statistic function execute() {
        if(variables.fromDate != null) {
            var qPageRequests = new Query();
            
            var sql = "         SELECT tmp1._date, 
                                       CASE 
                                         WHEN tmp2.errorCount IS NOT NULL THEN
                                           tmp2.errorCount
                                         ELSE
                                           0
                                       END errorCount,
                                       tmp1.errorCode
                                  FROM (SELECT DISTINCT inter._date,
                                                        stats.errorCode,
                                                        0 errorCount
                                          FROM (SELECT i _date
                                                  FROM generate_series(0, 23) i) inter,
                                                       (  SELECT COUNT(s.*) errorCount,
                                                                 date_part('Hour', s.errorDate) _date,
                                                                 s.errorCode
                                                            FROM nephthys_error s
                                                           WHERE date_trunc('day', s.errorDate) = :date
                                                        GROUP BY date_part('Hour', s.errorDate), s.errorCode) stats
                                                ORDER BY inter._date, stats.errorCode
                                               ) tmp1
                       FULL OUTER JOIN (  SELECT COUNT(s.*) errorCount,
                                                 date_part('Hour', s.errorDate) _date,
                                                 s.errorCode
                                            FROM nephthys_error s
                                           WHERE date_trunc('day', s.errorDate) = :date
                                        GROUP BY date_part('Hour', s.errorDate), s.errorCode
                                          HAVING COUNT(s.*) > 0
                                       ) tmp2 ON tmp1._date = tmp2._date AND tmp1.errorCode = tmp2.errorCode
                              ORDER BY tmp1._date " & variables.sortOrder & ", tmp1.errorCode ASC";
            
            variables.qRes = qPageRequests.setSQL(sql)
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