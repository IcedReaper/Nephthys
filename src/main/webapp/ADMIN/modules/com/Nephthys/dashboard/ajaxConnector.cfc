component {
    remote struct function getTodaysVisits() {
        var today = now();
        
        return {
            "success"    = true,
            "pageVisits" = prepareVisitData(createObject("component", "API.modules.com.Nephthys.statistics.pageVisit").init().get(today, today)),
            "websiteUrl" = application.system.settings.getValueOfKey("wwwDomain")
        };
    }
    
    remote struct function getYesterdaysVisits() {
        var yesterday = dateAdd("d", -1, now());
        
        return {
            "success"    = true,
            "pageVisits" = prepareVisitData(createObject("component", "API.modules.com.Nephthys.statistics.pageVisit").init().get(yesterday, yesterday)),
            "websiteUrl" = application.system.settings.getValueOfKey("wwwDomain")
        };
    }
    
    remote struct function loginStatistics() {
        var loginStatisticsCtrl = createObject("component", "API.modules.com.Nephthys.statistics.login").init();
        
        return {
            "success"    = true,
            "successful" = prepareLoginData(loginStatisticsCtrl.getSuccessful()),
            "failed"     = prepareLoginData(loginStatisticsCtrl.getFailed())
        };
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
        for(var i = 1; i <= arguments.loginData.len(); i++) {
            arguments.loginData[i].loginDate = application.tools.formatter.formatDate(arguments.loginData[i].loginDate);
        }
        
        return arguments.loginData;
    }
}