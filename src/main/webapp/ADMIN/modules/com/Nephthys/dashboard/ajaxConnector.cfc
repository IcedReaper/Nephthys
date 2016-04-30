component {
    import "API.modules.com.Nephthys.statistics.*";
    
    remote struct function getTodaysVisits() {
        var today = now();
        
        return {
            "success"    = true,
            "pageVisits" = prepareVisitData(new pageVisit().get(today, today)),
            "websiteUrl" = application.system.settings.getValueOfKey("wwwDomain")
        };
    }
    
    remote struct function getYesterdaysVisits() {
        var yesterday = dateAdd("d", -1, now());
        
        return {
            "success"    = true,
            "pageVisits" = prepareVisitData(new pageVisit().get(yesterday, yesterday)),
            "websiteUrl" = application.system.settings.getValueOfKey("wwwDomain")
        };
    }
    
    remote struct function loginStatistics() {
        var loginStatisticsCtrl = new login();
        
        return {
            "success"    = true,
            "successful" = prepareLoginData(loginStatisticsCtrl.getSuccessful()),
            "failed"     = prepareLoginData(loginStatisticsCtrl.getFailed())
        };
    }
    
    remote struct function getPageRequests(required string fromDate, required string toDate) { // format: DD.MM.YYYY // TODO: custom formats by server settings
        var _fromDate = dateFormat(arguments.fromDate, "DD.MM.YYYY");
        var _toDate   = dateFormat(arguments.toDate, "DD.MM.YYYY");

        var returnData = {
            "labels" = [],
            "data" = []
        };
        
        if(year(_fromDate) != year(_toDate)) {
            var requestData = new pageRequestsQueryPerYear()
                                      .setFromDate(_fromDate)
                                      .setToDate(_toDate)
                                      .execute()
                                      .getResult();
            
            
            returnData.actualView = "perYear";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i] = requestData[i].date;
                returnData.data[i]   = requestData[i].requestCount;
            }
        }
        else if(month(_fromDate) != month(_toDate)) {
            var requestData = new pageRequestsQueryPerMonth()
                                      .setFromDate(_fromDate)
                                      .setToDate(_toDate)
                                      .execute()
                                      .getResult();
            
            returnData.actualView = "perMonth";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i] = monthAsString(requestData[i].date, "de-DE");
                returnData.data[i]   = requestData[i].requestCount;
            }
        }
        else if(day(_fromDate) != day(_toDate)) {
            var requestData = new pageRequestsQueryPerDay()
                                      .setFromDate(_fromDate)
                                      .setToDate(_toDate)
                                      .execute()
                                      .getResult();
            
            returnData.actualView = "perDay";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i] = dateFormat(requestData[i].date, "DD.MM.YYYY");
                returnData.data[i] = requestData[i].requestCount;
            }
        }
        else {
            var requestData = new pageRequestsQueryPerHour()
                                      .setFromDate(_fromDate)
                                      .setToDate(_toDate)
                                      .execute()
                                      .getResult();
            
            returnData.actualView = "perHour";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i] = requestData[i].date;
                returnData.data[i] = requestData[i].requestCount;
            }
        }
        
        return returnData;
    }
    
    
    private struct function prepareVisitData(required array visitData) {
        var labels = [];
        var data   = [];
        var id     = [];
        
        for(var i = 1; i <= arguments.visitData.len(); ++i) {
            labels[i] = arguments.visitData[i].link;
            data[i]   = arguments.visitData[i].count;
            id[i]     = arguments.visitData[i].pageId;
        }
        
        return {
            "labels" = labels,
            "data"   = data,
            "id"     = id
        };
    }
    
    private array function prepareLoginData(required array loginData) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        for(var i = 1; i <= arguments.loginData.len(); ++i) {
            arguments.loginData[i].loginDate = formatCtrl.formatDate(arguments.loginData[i].loginDate);
        }
        
        return arguments.loginData;
    }
}