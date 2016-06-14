component implements="API.interfaces.pageRequestQuery" {
    public pageRequestQuery function init() {
        variables.fromDate = null;
        variables.toDate   = null;
        
        variables.pageId = null;
        variables.sortOrder = "ASC";
        
        variables.prq = null;
        
        return this;
    }
    
    public pageRequestQuery function setFromDate(required date _date) {
        variables.fromDate = arguments._date;
        
        return this;
    }
    public pageRequestQuery function setToDate(required date _date) {
        variables.toDate = arguments._date;
        
        return this;
    }
    public pageRequestQuery function setPageId(required numeric pageId) {
        variables.pageId = arguments.pageId;
        
        return this;
    }
    public pageRequestQuery function setSortOrder(required string sortOrder) {
        if(uCase(arguments.sortOrder) == "ASC" || uCase(arguments.sortOrder) == "DESC") {
            variables.sortOrder = arguments.sortOrder;
        }
        return this;
    }
    
    public pageRequestQuery function execute() {
        throw(type = "application", message = "Implement this method yourself!");
    }
    
    public query function getQuery() {
        return variables.prq.getResult();
    }
    
    public array function getResult() {
        var qResult = variables.prq.getResult();
        
        var pageRequests = [];
        for(var i = 1; i <= qResult.getRecordCount(); ++i) {
            pageRequests.append({
                "date"         = qResult._date[i],
                "requestCount" = qResult.requestCount[i]
            });
        }
        
        return pageRequests;
    }
    
    
    private date function today() {
        var _now = now();
        
        return createDate(year(_now), month(_now), day(_now()));
    }
}