component extends="API.modules.com.Nephthys.pages.statistics.abstractStatistic" {
    public statistic function execute() {
        return this;
    }
    
    public struct function getResult() {
        /*if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }*/
        
        /*var pageRequests = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); ++i) {
            pageRequests.append({
                "date"         = variables.qRes._date[i],
                "requestCount" = variables.qRes.requestCount[i],
                "completeLink" = variables.qRes.completeLink[i]
            });
        }*/
        
        return {
            "title"    = "Willkommen",
            "requests" = 1234
        };
    }
}