component {
    import "API.modules.com.Nephthys.userManager.statistics.*";
    
    public statistics function init(string locale = 'de-DE', string dateFormat = "DD.MM.YYYY") {
        variables.locale     = arguments.locale;
        variables.dateFormat = arguments.dateFormat;
        
        return this;
    }
    
    public struct function getTotal(required numeric userId = null, required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "data"   = [],
            "series" = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = new totalLogin.perYear();
            returnData.actualView = "perYear";
        }
        else {
            if(month(arguments.fromDate) != month(arguments.toDate) && 
               datediff("d", arguments.fromDate, arguments.toDate) > daysInMonth(arguments.fromDate)) {
                var statisticsService = new totalLogin.perMonth();
                returnData.actualView = "perMonth";
            }
            else {
                if(arguments.fromDate == arguments.toDate) {
                    var statisticsService = new totalLogin.perHour();
                    returnData.actualView = "perHour";
                }
                else {
                    if(arguments.toDate > now()) {
                        var n = now();
                        arguments.toDate = createDate(year(n), month(n), day(n));
                    }
                    
                    var statisticsService = new totalLogin.perDay();
                    returnData.actualView = "perDay";
                }
            }
        }
        
        var requestData = statisticsService.setUserNameById(arguments.userId)
                                           .setSortOrder(arguments.sortOrder)
                                           .setFromDate(arguments.fromDate)
                                           .setToDate(arguments.toDate)
                                           .execute()
                                           .getResult();
        
        var lastDate = "";
        
        returnData.data[1] = [];
        returnData.data[2] = [];
        returnData.series[1] = "Erfolgreiche Loginversuche";
        returnData.series[2] = "Gescheiterte Loginversuche";
        
        for(var i = 1; i <= requestData.len(); ++i) {
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
            
            if(requestData[i].successful == 1) {
                returnData.data[1].append(requestData[i].loginCount);
            }
            else {
                returnData.data[2].append(requestData[i].loginCount);
            }
        }
        
        return returnData;
    }
}