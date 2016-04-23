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
    
    remote struct function getVisitsForDayCount(required numeric dayCount) {
        if(arguments.dayCount > 0) {
            var endDate = createDate(year(now()), month(now()), day(now()) + 1);
            var startDate = dateAdd("d", arguments.dayCount * -1, endDate);
            
            return prepareRequestData(new pageVisit().getRequestCountForDateRange(startDate, endDate));
        }
        else {
            throw(type = "application", message = "dayCount has to be a positive number");
        }
    }
    
    remote struct function getVisitsForMonth(required numeric month, required numeric year) {
        var startDate = createDate(arguments.year, arguments.month, 1);
        var endDate   = createDate(arguments.year, arguments.month, daysInMonth(startDate));
        
        return prepareRequestData(new pageVisit().getRequestCountForDateRange(startDate, endDate));
    }
    
    remote struct function getVisitsForYear(required numeric year) {
        var startDate = createDate(arguments.year,  1,  1);
        var endDate   = createDate(arguments.year, 12, 31);
        
        return prepareRequestData(new pageVisit().getRequestCountForDateRange(startDate, endDate));
    }
    
    remote struct function getVisitsForTimeframe(required string startDate, required string endDate) {
        var _startDate = dateFormat(arguments.startDate, "DD.MM.YYYY");
        var _endDate   = dateFormat(arguments.endDate, "DD.MM.YYYY");
        
        return prepareRequestData(new pageVisit().getRequestCountForDateRange(_startDate, _endDate));
    }
    
    
    private struct function prepareVisitData(required array visitData) {
        var labels = [];
        var data   = [];
        var id     = [];
        
        for(var i = 1; i <= arguments.visitData.len(); i++) {
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
        
        for(var i = 1; i <= arguments.loginData.len(); i++) {
            arguments.loginData[i].loginDate = formatCtrl.formatDate(arguments.loginData[i].loginDate);
        }
        
        return arguments.loginData;
    }
    
    private struct function prepareRequestData(required array requestData) {
        var returnData = {
            "labels" = [],
            "data" = []
        };
        
        for(var i = 1; i <= arguments.requestData.len(); ++i) {
            returnData.labels[i] = dateFormat(arguments.requestData[i].date, "DD.MM.YYYY");
            returnData.data[i] = arguments.requestData[i].requestCount;
        }
        
        return returnData;
    }
}