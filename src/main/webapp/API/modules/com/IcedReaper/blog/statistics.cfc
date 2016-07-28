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
            var statisticsService = new perBlogpost.perYear();
            returnData.actualView = "perYear";
        }
        else {
            if(month(arguments.fromDate) != month(arguments.toDate) && 
               datediff("d", arguments.fromDate, arguments.toDate) > daysInMonth(arguments.fromDate)) {
                var statisticsService = new perBlogpost.perMonth();
                returnData.actualView = "perMonth";
            }
            else {
                if(arguments.fromDate == arguments.toDate) {
                    var statisticsService = new perBlogpost.perHour();
                    returnData.actualView = "perHour";
                }
                else {
                    if(arguments.toDate > now()) {
                        var n = now();
                        arguments.toDate = createDate(year(n), month(n), day(n));
                    }
                    
                    var statisticsService = new perBlogpost.perDay();
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