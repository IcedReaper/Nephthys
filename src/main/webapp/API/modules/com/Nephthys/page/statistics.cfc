component {
    import "statistics.*";
    
    public statistics function init(string locale = 'de-DE', string dateFormat = "DD.MM.YYYY") {
        variables.locale     = arguments.locale;
        variables.dateFormat = arguments.dateFormat;
        
        return this;
    }
    
    public struct function getTotal(required numeric pageId = null, required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "data" = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var requestData = createObject("component", "total.perYear").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            
            returnData.actualView = "perYear";
            
            returnData.data[1] = [];
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i]  = requestData[i].date;
                returnData.data[1][i] = requestData[i].requestCount;
            }
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var requestData = createObject("component", "total.perMonth").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perMonth";
            
            returnData.data[1] = [];
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i]  = monthAsString(requestData[i].date, variables.locale);
                returnData.data[1][i] = requestData[i].requestCount;
            }
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var requestData = createObject("component", "total.perDay").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perDay";
            
            returnData.data[1] = [];
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i]  = dateFormat(requestData[i].date, variables.dateFormat);
                returnData.data[1][i] = requestData[i].requestCount;
            }
        }
        else {
            var requestData = createObject("component", "total.perHour").init()
                                      .setPageId(arguments.pageId)
                                      .setSortOrder(arguments.sortOrder)
                                      .setFromDate(arguments.fromDate)
                                      .setToDate(arguments.toDate)
                                      .execute()
                                      .getResult();
            
            returnData.actualView = "perHour";
            
            returnData.data[1] = [];
            for(var i = 1; i <= requestData.len(); ++i) {
                returnData.labels[i]  = requestData[i].date;
                returnData.data[1][i] = requestData[i].requestCount;
            }
        }
        
        return returnData;
    }
    
    public struct function getTotalSplitPerPage(required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "series" = [],
            "data" = []
        };
        
        var pageIndex = {};
        var maxPageIndex = 0;
        var lastDate = "";
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var requestData = createObject("component", "perPage.perYear").init()
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perYear";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! pageIndex.keyExists(requestData[i].pageId)) {
                    pageIndex[requestData[i].pageId] = ++maxPageIndex;
                    
                    returnData.data[maxPageIndex] = [];
                    returnData.series[maxPageIndex] = new page(requestData[i].pageId).getActualPageVersion().getLinktext();
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(requestData[i].date, variables.dateFormat);
                }
                
                returnData.data[pageIndex[requestData[i].pageId]].append(requestData[i].requestCount);
            }
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var requestData = createObject("component", "perPage.perMonth").init()
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perMonth";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! pageIndex.keyExists(requestData[i].pageId)) {
                    pageIndex[requestData[i].pageId] = ++maxPageIndex;
                    
                    returnData.data[maxPageIndex] = [];
                    returnData.series[maxPageIndex] = new page(requestData[i].pageId).getActualPageVersion().getLinktext();
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(monthAsString(requestData[i].date, variables.locale));
                }
                
                returnData.data[pageIndex[requestData[i].pageId]].append(requestData[i].requestCount);
            }
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var requestData = createObject("component", "perPage.perDay").init()
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perDay";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! pageIndex.keyExists(requestData[i].pageId)) {
                    pageIndex[requestData[i].pageId] = ++maxPageIndex;
                    
                    returnData.data[maxPageIndex] = [];
                    returnData.series[maxPageIndex] = new page(requestData[i].pageId).getActualPageVersion().getLinktext();
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(dateFormat(requestData[i].date, variables.dateFormat));
                }
                
                returnData.data[pageIndex[requestData[i].pageId]].append(requestData[i].requestCount);
            }
        }
        else {
            var requestData = createObject("component", "perPage.perHour").init()
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perHour";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! pageIndex.keyExists(requestData[i].pageId)) {
                    pageIndex[requestData[i].pageId] = ++maxPageIndex;
                    
                    returnData.data[maxPageIndex] = [];
                    returnData.series[maxPageIndex] = new page(requestData[i].pageId).getActualPageVersion().getLinktext();
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(requestData[i].date);
                }
                
                returnData.data[pageIndex[requestData[i].pageId]].append(requestData[i].requestCount);
            }
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
            var requestData = createObject("component", "splitForPage.perYear").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perYear";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! linkIndex.keyExists(requestData[i].completeLink)) {
                    linkIndex[requestData[i].completeLink] = ++maxLinkIndex;
                    
                    returnData.data[maxLinkIndex] = [];
                    returnData.series[maxLinkIndex] = requestData[i].completeLink;
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(requestData[i].date, variables.dateFormat);
                }
                
                returnData.data[linkIndex[requestData[i].completeLink]].append(requestData[i].requestCount);
            }
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var requestData = createObject("component", "splitForPage.perMonth").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perMonth";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! linkIndex.keyExists(requestData[i].completeLink)) {
                    linkIndex[requestData[i].completeLink] = ++maxLinkIndex;
                    
                    returnData.data[maxLinkIndex] = [];
                    returnData.series[maxLinkIndex] = requestData[i].completeLink;
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(monthAsString(requestData[i].date, variables.locale));
                }
                
                returnData.data[linkIndex[requestData[i].completeLink]].append(requestData[i].requestCount);
            }
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var requestData = createObject("component", "splitForPage.perDay").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perDay";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! linkIndex.keyExists(requestData[i].completeLink)) {
                    linkIndex[requestData[i].completeLink] = ++maxLinkIndex;
                    
                    returnData.data[maxLinkIndex] = [];
                    returnData.series[maxLinkIndex] = requestData[i].completeLink;
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(dateFormat(requestData[i].date, variables.dateFormat));
                }
                
                returnData.data[linkIndex[requestData[i].completeLink]].append(requestData[i].requestCount);
            }
        }
        else {
            var requestData = createObject("component", "splitForPage.perHour").init()
                                  .setPageId(arguments.pageId)
                                  .setSortOrder(arguments.sortOrder)
                                  .setFromDate(arguments.fromDate)
                                  .setToDate(arguments.toDate)
                                  .execute()
                                  .getResult();
            
            returnData.actualView = "perHour";
            
            for(var i = 1; i <= requestData.len(); ++i) {
                if(! linkIndex.keyExists(requestData[i].completeLink)) {
                    linkIndex[requestData[i].completeLink] = ++maxLinkIndex;
                    
                    returnData.data[maxLinkIndex] = [];
                    returnData.series[maxLinkIndex] = requestData[i].completeLink;
                }
                
                if(lastDate != requestData[i].date) {
                    lastDate = requestData[i].date;
                    returnData.labels.append(requestData[i].date);
                }
                
                returnData.data[linkIndex[requestData[i].completeLink]].append(requestData[i].requestCount);
            }
        }
        
        return returnData;
    }
}