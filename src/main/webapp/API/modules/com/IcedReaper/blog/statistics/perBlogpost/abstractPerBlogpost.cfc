component extends="API.modules.com.IcedReaper.blog.statistics.abstractStatistic" {
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        var pageRequests = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); ++i) {
            pageRequests.append({
                "date"         = variables.qRes._date[i],
                "requestCount" = variables.qRes.requestCount[i],
                "blogpostId"   = variables.qRes.blogpostId[i]
            });
        }
        
        return pageRequests;
    }
}