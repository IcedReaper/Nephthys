component {
    import "API.modules.com.IcedReaper.blog.statistics.*";
    
    public statistics function init(string locale = 'de-DE', string dateFormat = "DD.MM.YYYY") {
        variables.locale     = arguments.locale;
        variables.dateFormat = arguments.dateFormat;
        
        return this;
    }
    
    public struct function getTotal(required numeric blogpostId = null, required string sortOrder, required date fromDate, required date toDate) {
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
        
        var requestData = statisticsService.setBlogpostId(arguments.blogpostId)
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
    
    public struct function getSplitPerBlogpost(required string sortOrder, required date fromDate, required date toDate) {
        var returnData = {
            "labels" = [],
            "series" = [],
            "data"   = []
        };
        
        if(year(arguments.fromDate) != year(arguments.toDate)) {
            var statisticsService = createObject("component", "perBlogpost.perYear").init();
            returnData.actualView = "perYear";
        }
        else if(month(arguments.fromDate) != month(arguments.toDate)) {
            var statisticsService = createObject("component", "perBlogpost.perMonth").init();
            returnData.actualView = "perMonth";
        }
        else if(day(arguments.fromDate) != day(arguments.toDate)) {
            if(arguments.toDate > now()) {
                var n = now();
                arguments.toDate = createDate(year(n), month(n), day(n));
            }
            var statisticsService = createObject("component", "perBlogpost.perDay").init();
            returnData.actualView = "perDay";
        }
        else {
            var statisticsService = createObject("component", "perBlogpost.perHour").init();
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
            if(! pageIndex.keyExists(requestData[i].blogpostId)) {
                pageIndex[requestData[i].blogpostId] = ++maxPageIndex;
                
                returnData.data[maxPageIndex] = [];
                returnData.series[maxPageIndex] = new blogpost(requestData[i].blogpostId).getHeadline();
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
            
            returnData.data[pageIndex[requestData[i].blogpostId]].append(requestData[i].requestCount);
        }
        
        return returnData;
    }
    
    public void function add(required numeric blogpostId) {
        new Query().setSQL("INSERT INTO IcedReaper_blog_statistics
                                        (
                                            blogpostId
                                        )
                                 VALUES (
                                            :blogpostId
                                        )")
                   .addParam(name = "blogpostId", value = arguments.blogpostId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
}