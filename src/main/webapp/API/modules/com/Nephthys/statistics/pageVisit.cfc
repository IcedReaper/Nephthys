component {
    public pageVisit function init() {
        
        return this;
    }
    
    public array function get(required date fromDate, required date toDate) {
        arguments.toDate = dateAdd("d", 1, arguments.toDate);
        
        var _from = createDate(year(arguments.fromDate), month(arguments.fromDate), day(arguments.fromDate));
        var _to   = createDate(year(arguments.toDate),   month(arguments.toDate),   day(arguments.toDate));
        
        var qPageVisits = new Query().setSQL("  SELECT pageStatistic.pageId,
                                                       pageStatistic.link,
                                                       MAX(pageStatistic.count) count
                                                  FROM (   SELECT allPages.pageId,
                                                                  allPages.link,
                                                                  0 count,
                                                                  NULL parameter,
                                                                  allPages.region,
                                                                  allPages.sortOrder
                                                             FROM nephthys_page allPages
                                                            WHERE allPages.active = :apActive
                                                        UNION ALL(SELECT page.pageId,
                                                                         statistics.link,
                                                                         statistics.count,
                                                                         regexp_matches(statistics.link, page.preparredLink || page.suffix || '$', 'i') parameter,
                                                                         page.region,
                                                                         page.sortOrder
                                                                    FROM (SELECT p.pageId,
                                                                                 '^' || replace(p.link, '/', '\/') preparredLink,
                                                                                 CASE 
                                                                                   WHEN p.useDynamicSuffixes = true THEN 
                                                                                     '(?:\/(\w*|\-|\s|\.)*)*'
                                                                                   ELSE 
                                                                                     ''
                                                                                 END suffix,
                                                                                 p.region,
                                                                                 p.sortOrder
                                                                            FROM nephthys_page p
                                                                           WHERE p.active = :active) page,
                                                                         (  SELECT s.link,
                                                                                   COUNT(s.*) count
                                                                              FROM nephthys_statistics s
                                                                             WHERE s.visitDate > :fromDate
                                                                               AND s.visitDate < :toDate
                                                                          GROUP BY s.link) statistics)
                                                       ) pageStatistic
                                              GROUP BY pageStatistic.pageId,
                                                       pageStatistic.link,
                                                       pageStatistic.region,
                                                       pageStatistic.sortOrder
                                              ORDER BY pageStatistic.region,
                                                       pageStatistic.sortOrder,
                                                       pageStatistic.link
                                                 LIMIT 20")
                                     .addParam(name = "apActive", value = 1,     cfsqltype = "cf_sql_bit")
                                     .addParam(name = "active",   value = 1,     cfsqltype = "cf_sql_bit")
                                     .addParam(name = "fromDate", value = _from, cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDate",   value = _to,   cfsqltype = "cf_sql_date")
                                     .execute()
                                     .getResult();
        
        var pageVisits = [];
        for(var i = 1; i <= qPageVisits.getRecordCount(); i++) {
            pageVisits.append({
                    "pageId" = qPageVisits.pageId[i],
                    "link"   = qPageVisits.link[i],
                    "count"  = qPageVisits.count[i]
                });
        }
        
        return pageVisits;
    }
    
    public array function getPageStatistics(required date fromDate, required date toDate, required numeric pageId) {
        var _from = createDate(year(arguments.fromDate), month(arguments.fromDate), day(arguments.fromDate));
        var _to   = createDate(year(arguments.toDate),   month(arguments.toDate),   day(arguments.toDate));
        
        var qPageVisits = new Query().setSQL("            SELECT to_char(dateRange.d, 'dd.mm.yyyy') d,
                                                                 CASE
                                                                   WHEN SUM(pageStatistics.count) IS NOT NULL THEN
                                                                     SUM(pageStatistics.count)
                                                                   ELSE
                                                                     0
                                                                 END count
                                                                 FROM (SELECT i :: date d 
                                                                         FROM generate_series(:fromDateTF, :toDateTF, '1 day' :: interval) i) dateRange
                                              LEFT OUTER JOIN (SELECT page.link,
                                                                      statistics.count,
                                                                      regexp_matches(statistics.link, page.preparredLink || page.suffix || '$', 'i') parameter,
                                                                      to_date(statistics.visitDate, 'mm/dd/yyyy') visitDate
                                                                 FROM (SELECT p.pageId,
                                                                              p.link,
                                                                              '^' || replace(p.link, '/', '\/') preparredLink,
                                                                              CASE 
                                                                                WHEN p.useDynamicSuffixes = true THEN 
                                                                                  '(?:\/(\w*|\-|\s|\.)*)*'
                                                                                ELSE 
                                                                                  ''
                                                                              END suffix,
                                                                              p.region,
                                                                              p.sortOrder
                                                                         FROM nephthys_page p
                                                                        WHERE p.active = :active
                                                                          AND p.pageId = :pageId) page,
                                                                      (  SELECT s.link,
                                                                                COUNT(s.*) count,
                                                                                to_char(s.visitDate, 'mm/dd/yyyy') visitDate
                                                                           FROM nephthys_statistics s
                                                                          WHERE s.visitDate > :fromDateS
                                                                            AND s.visitDate < :toDateS
                                                                       GROUP BY s.link,
                                                                                to_char(s.visitDate, 'mm/dd/yyyy')) statistics) pageStatistics ON dateRange.d = pageStatistics.visitDate
                                                     GROUP BY dateRange.d,
                                                              pageStatistics.link
                                                     ORDER BY dateRange.d ASC")
                                     .addParam(name = "active",     value = 1,                    cfsqltype = "cf_sql_bit")
                                     .addParam(name = "pageId",     value = arguments.pageId,     cfsqltype = "cf_sql_numeric")
                                     .addParam(name = "fromDateTF", value = _from,                cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDateTF",   value = _to,                  cfsqltype = "cf_sql_date")
                                     .addParam(name = "fromDateS",  value = _from,                cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDateS",    value = dateAdd("d", 1, _to), cfsqltype = "cf_sql_date")
                                     .execute()
                                     .getResult();
        
        var pageVisits = [];
        for(var i = 1; i <= qPageVisits.getRecordCount(); i++) {
            pageVisits.append({
                    "date"   = qPageVisits.d[i],
                    "count"  = qPageVisits.count[i]
                });
        }
        
        return pageVisits;
    }
    
    
    public array function getPageStatistcsWithParameter(required date fromDate, required date toDate, required numeric pageId) {
        var _from = createDate(year(arguments.fromDate), month(arguments.fromDate), day(arguments.fromDate));
        var _to   = createDate(year(arguments.toDate),   month(arguments.toDate),   day(arguments.toDate));
        
        var qPageVisits = new Query().setSQL("            SELECT to_char(dateRange.d, 'dd.mm.yyyy') d,
                                                                 CASE
                                                                   WHEN pageStatistics.link IS NOT NULL THEN
                                                                     pageStatistics.link
                                                                   ELSE
                                                                     ''
                                                                 END link,
                                                                 CASE
                                                                   WHEN SUM(pageStatistics.count) IS NULL THEN
                                                                     0
                                                                   ELSE
                                                                     SUM(pageStatistics.count)
                                                                 END count
                                                                 FROM (SELECT i :: date d 
                                                                         FROM generate_series(:fromDateTF, :toDateTF, '1 day' :: interval) i) dateRange
                                              LEFT OUTER JOIN (SELECT statistics.link,
                                                                      statistics.count,
                                                                      regexp_matches(statistics.link, page.preparredLink || page.suffix || '$', 'i') parameter,
                                                                      to_date(statistics.visitDate, 'mm/dd/yyyy') visitDate
                                                                 FROM (SELECT p.pageId,
                                                                              p.link,
                                                                              '^' || replace(p.link, '/', '\/') preparredLink,
                                                                              CASE 
                                                                                WHEN p.useDynamicSuffixes = true THEN 
                                                                                  '(?:\/(\w*|\-|\s|\.)*)*'
                                                                                ELSE 
                                                                                  ''
                                                                              END suffix,
                                                                              p.region,
                                                                              p.sortOrder
                                                                         FROM nephthys_page p
                                                                        WHERE p.active = :active
                                                                          AND p.pageId = :pageId) page,
                                                                      (  SELECT s.link,
                                                                                COUNT(s.*) count,
                                                                                to_char(s.visitDate, 'mm/dd/yyyy') visitDate
                                                                           FROM nephthys_statistics s
                                                                          WHERE s.visitDate > :fromDateS
                                                                            AND s.visitDate < :toDateS
                                                                       GROUP BY s.link,
                                                                                to_char(s.visitDate, 'mm/dd/yyyy')) statistics) pageStatistics ON dateRange.d = pageStatistics.visitDate
                                                     GROUP BY dateRange.d,
                                                              pageStatistics.link
                                                     ORDER BY dateRange.d ASC")
                                     .addParam(name = "active",     value = 1,                    cfsqltype = "cf_sql_bit")
                                     .addParam(name = "pageId",     value = arguments.pageId,     cfsqltype = "cf_sql_numeric")
                                     .addParam(name = "fromDateTF", value = _from,                cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDateTF",   value = _to,                  cfsqltype = "cf_sql_date")
                                     .addParam(name = "fromDateS",  value = _from,                cfsqltype = "cf_sql_date")
                                     .addParam(name = "toDateS",    value = dateAdd("d", 1, _to), cfsqltype = "cf_sql_date")
                                     .execute()
                                     .getResult();
        
        var pageVisits = [];
        for(var i = 1; i <= qPageVisits.getRecordCount(); i++) {
            pageVisits.append({
                    "date"   = qPageVisits.d[i],
                    "link"   = qPageVisits.link[i],
                    "count"  = qPageVisits.count[i]
                });
        }
        
        return pageVisits;
    }
    
    public array function getRequestCountForDateRange(required date startDate, required date endDate) {
        arguments.endDate = dateAdd("d", 1, arguments.endDate);
        
        var qPageRequests = new Query().setSQL("         SELECT dateRange.d, 
                                                                CASE
                                                                  WHEN pageRequests.requestCount IS NOT NULL THEN
                                                                    pageRequests.requestCount
                                                                  ELSE
                                                                    0
                                                                END requestCount
                                                           FROM (SELECT i :: date d 
                                                                   FROM generate_series(:startDate, :endDate, '1 day' :: interval) i) dateRange
                                                LEFT OUTER JOIN (  SELECT COUNT(*) requestCount, date_trunc('day', visitDate) _date 
                                                                     FROM nephthys_statistics
                                                                    WHERE visitDate > :startDate
                                                                      AND visitDate < :endDate
                                                                 GROUP BY date_trunc('day', visitDate)) pageRequests ON dateRange.d = pageRequests._date
                                                       ORDER BY dateRange.d")
                                       .addParam(name = "startDate", value = arguments.startDate, cfsqltype = "cf_sql_date")
                                       .addParam(name = "endDate",   value = arguments.endDate,   cfsqltype = "cf_sql_date")
                                       .execute()
                                       .getResult();
        
        var pageRequests = [];
        for(var i = 1; i <= qPageRequests.getRecordCount(); ++i) {
            pageRequests.append({
                "date"         = qPageRequests.d[i],
                "requestCount" = qPageRequests.requestCount[i]
            });
        }
        
        return pageRequests;
    }
}