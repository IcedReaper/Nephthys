component {
    import "statistics.*";
    
    public statistics function init(string locale = 'de-DE', string dateFormat = "DD.MM.YYYY") {
        variables.locale     = arguments.locale;
        variables.dateFormat = arguments.dateFormat;
        
        return this;
    }
    
    public struct function getTotal(required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "data"   = []
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
        for(var i = 1; i <= requestData.len(); ++i) {
            switch(returnData.actualView) {
                case "perHour":
                case "perYear": {
                    returnData.labels[i] = requestData[i].date;
                    break;
                }
                case "perDay": {
                    returnData.labels[i] = dateFormat(requestData[i].date, variables.dateFormat);
                    break;
                }
                case "perMonth": {
                    returnData.labels[i] = monthAsString(month(requestData[i].date), variables.locale);
                    break;
                }
            }
            returnData.data[1][i] = requestData[i].errorCount;
        }
        
        return returnData;
    }
    
    public struct function getSplitPerType(required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "series" = [],
            "data"   = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = new splitPerType.perYear();
            returnData.actualView = "perYear";
        }
        else {
            if(month(arguments.fromDate) != month(arguments.toDate) && 
               datediff("d", arguments.fromDate, arguments.toDate) > daysInMonth(arguments.fromDate)) {
                var statisticsService = new splitPerType.perMonth();
                returnData.actualView = "perMonth";
            }
            else {
                if(arguments.fromDate == arguments.toDate) {
                    var statisticsService = new splitPerType.perHour();
                    returnData.actualView = "perHour";
                }
                else {
                    if(arguments.toDate > now()) {
                        var n = now();
                        arguments.toDate = createDate(year(n), month(n), day(n));
                    }
                    
                    var statisticsService = new splitPerType.perDay();
                    returnData.actualView = "perDay";
                }
            }
        }
        
        var requestData = statisticsService.setSortOrder(arguments.sortOrder)
                                           .setFromDate(arguments.fromDate)
                                           .setToDate(arguments.toDate)
                                           .execute()
                                           .getResult();
        
        var pageIndex = {};
        var maxPageIndex = 0;
        var lastDate = "";
        
        returnData.recordCount = requestData.len();
        returnData.lastDate = [];
        
        for(var i = 1; i <= requestData.len(); ++i) {
            if(! pageIndex.keyExists(requestData[i].errorCode)) {
                pageIndex[requestData[i].errorCode] = ++maxPageIndex;
                
                returnData.data[maxPageIndex] = [];
                returnData.series[maxPageIndex] = requestData[i].errorCode;
            }
            
            returnData.lastDate.append({
                lastDate = lastDate,
                dbDate = requestData[i].date
            });
            if(lastDate != requestData[i].date) {
                lastDate = requestData[i].date;
                
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
            }
            
            returnData.data[pageIndex[requestData[i].errorCode]].append(requestData[i].errorCount);
        }
        
        return returnData;
    }
    
    public array function getTotalSplitPerType(required date fromDate, required date toDate) {
        return new totalSplitPerType.total()
                                    .setFromDate(arguments.fromDate)
                                    .setToDate(arguments.toDate)
                                    .execute()
                                    .getResult();
    }
}