component {
    import "API.modules.com.Nephthys.search.statistics.*";
    
    public statistics function init(string locale = 'de-DE', string dateFormat = "DD.MM.YYYY") {
        variables.locale     = arguments.locale;
        variables.dateFormat = arguments.dateFormat;
        
        return this;
    }
    
    public struct function getTotal(required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "data"   = [],
            "series" = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = new total.perYear();
            returnData.actualView = "perYear";
        }
        else {
            if(month(arguments.fromDate) != month(arguments.toDate) && 
               datediff("d", arguments.fromDate, arguments.toDate) > daysInMonth(arguments.fromDate)) {
                var statisticsService = new total.perMonth();
                returnData.actualView = "perMonth";
            }
            else {
                if(arguments.fromDate == arguments.toDate) {
                    var statisticsService = new total.perHour();
                    returnData.actualView = "perHour";
                }
                else {
                    if(arguments.toDate > now()) {
                        var n = now();
                        arguments.toDate = createDate(year(n), month(n), day(n));
                    }
                    
                    var statisticsService = new total.perDay();
                    returnData.actualView = "perDay";
                }
            }
        }
        
        var requestData = statisticsService.setSortOrder(arguments.sortOrder)
                                           .setFromDate(arguments.fromDate)
                                           .setToDate(arguments.toDate)
                                           .execute()
                                           .getResult();
        
        returnData.data[1] = [];
        returnData.data[2] = [];
        returnData.series[1] = "Suchanfragen";
        returnData.series[2] = "Durchschnittliche Treffer";
        
        for(var i = 1; i <= requestData.len(); ++i) {
            switch(returnData.actualView) {
                case "perHour":
                case "perYear": {
                    returnData.labels.append(requestData[i].date);
                    break;
                }
                case "perDay": {
                    returnData.labels.append(dateFormat(requestData[i].date, variables.dateFormat));
                    break;
                }
                case "perMonth": {
                    returnData.labels.append(monthAsString(month(requestData[i].date), variables.locale));
                    break;
                }
            }
        
            returnData.data[1].append(requestData[i].searchCount);
            returnData.data[2].append(requestData[i].avgResultCount);
        }
        
        return returnData;
    }
    
    public array function getOverview(required date fromDate, required date toDate) {
        var qOverview = new Query().setSQL("  SELECT max(ss.searchString) searchString, COUNT(*) searchCount
                                                FROM nephthys_search_statistics ss
                                               WHERE date_trunc('day', ss.searchDate) >= :fromDate
                                                 AND date_trunc('day', ss.searchDate) <= :toDate
                                            GROUP BY lower(ss.searchString)
                                            ORDER BY COUNT(*) DESC, lower(ss.searchString)")
                                   .addParam(name = "fromDate", value = arguments.fromDate, cfsqltype = "cf_sql_date")
                                   .addParam(name = "toDate", value = arguments.toDate, cfsqltype = "cf_sql_date")
                                   .execute()
                                   .getResult();
        
        var overviewData = [];
        for(var i = 1; i <= qOverview.getRecordCount(); ++i) {
            overviewData.append({
                "searchString" = qOverview.searchString[i],
                "searchCount"  = qOverview.searchCount[i]
            });
        }
        
        return overviewData;
    }
}