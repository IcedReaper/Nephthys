component {
    import "API.modules.com.Nephthys.page.statistics.*";
    
    public statistics function init(string locale = 'de-DE', string dateFormat = "DD.MM.YYYY") {
        variables.locale     = arguments.locale;
        variables.dateFormat = arguments.dateFormat;
        
        return this;
    }
    
    public struct function getTotal(required numeric pageId = null, required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "data"   = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = createObject("component", "total.perYear").init();
            returnData.actualView = "perYear";
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var statisticsService = createObject("component", "total.perMonth").init();
            returnData.actualView = "perMonth";
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var statisticsService = createObject("component", "total.perDay").init();
            returnData.actualView = "perDay";
            
        }
        else {
            var statisticsService = createObject("component", "total.perHour").init();
            returnData.actualView = "perHour";
        }
        
        var requestData = statisticsService.setPageId(arguments.pageId)
                                           .setSortOrder(arguments.sortOrder)
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
            returnData.data[1][i] = requestData[i].requestCount;
        }
        
        return returnData;
    }
    
    public struct function getTotalSplitPerPage(required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "series" = [],
            "data"   = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = createObject("component", "perPage.perYear").init();
            returnData.actualView = "perYear";
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var statisticsService = createObject("component", "perPage.perMonth").init();
            returnData.actualView = "perMonth";
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var statisticsService = createObject("component", "perPage.perDay").init();
            returnData.actualView = "perDay";
        }
        else {
            var statisticsService = createObject("component", "perPage.perHour").init();
            returnData.actualView = "perHour";
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
            if(! pageIndex.keyExists(requestData[i].pageId)) {
                pageIndex[requestData[i].pageId] = ++maxPageIndex;
                
                returnData.data[maxPageIndex] = [];
                returnData.series[maxPageIndex] = new page(requestData[i].pageId).getActualPageVersion().getLinktext();
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
            
            returnData.data[pageIndex[requestData[i].pageId]].append(requestData[i].requestCount);
        }
        
        return returnData;
    }
    
    public struct function getSplitPerPage(required numeric pageId, required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "series" = [],
            "data" = []
        };
        
        var linkIndex = {};
        var maxLinkIndex = 0;
        var lastDate = "";
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = createObject("component", "splitForPage.perYear").init();
            returnData.actualView = "perYear";
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var statisticsService = createObject("component", "splitForPage.perMonth").init();
            returnData.actualView = "perMonth";
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var statisticsService = createObject("component", "splitForPage.perDay").init();
            returnData.actualView = "perDay";
        }
        else {
            var statisticsService = createObject("component", "splitForPage.perHour").init();
            returnData.actualView = "perHour";
        }
        
        var requestData = statisticsService.setPageId(arguments.pageId)
                                           .setSortOrder(arguments.sortOrder)
                                           .setFromDate(arguments.fromDate)
                                           .setToDate(arguments.toDate)
                                           .execute()
                                           .getResult();
        
        for(var i = 1; i <= requestData.len(); ++i) {
            if(! linkIndex.keyExists(requestData[i].completeLink)) {
                linkIndex[requestData[i].completeLink] = ++maxLinkIndex;
                
                returnData.data[maxLinkIndex] = [];
                returnData.series[maxLinkIndex] = requestData[i].completeLink;
            }
            
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
                        returnData.labels.append(monthAsString(requestData[i].date, variables.locale));
                        break;
                    }
                }
            }
            
            returnData.data[linkIndex[requestData[i].completeLink]].append(requestData[i].requestCount);
        }
        
        return returnData;
    }
}