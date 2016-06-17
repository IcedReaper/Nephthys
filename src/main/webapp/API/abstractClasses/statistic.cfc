component implements="API.interfaces.statistic" {
    public statistic function init() {
        variables.fromDate = null;
        variables.toDate   = null;
        
        variables.pageId = null;
        variables.sortOrder = "ASC";
        
        variables.qRes = null;
        
        return this;
    }
    
    public statistic function setFromDate(required date _date) {
        variables.fromDate = arguments._date;
        
        return this;
    }
    public statistic function setToDate(required date _date) {
        variables.toDate = arguments._date;
        
        return this;
    }
    public statistic function setSortOrder(required string sortOrder) {
        if(uCase(arguments.sortOrder) == "ASC" || uCase(arguments.sortOrder) == "DESC") {
            variables.sortOrder = arguments.sortOrder;
        }
        return this;
    }
    
    public statistic function execute() {
        throw(type = "application", message = "Implement this method yourself!");
    }
    
    public query function getQuery() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        return variables.qRes;
    }
    
    public array function getResult() {
        throw(type = "application", message = "Implement this method yourself!");
    }
    
    
    private date function today() {
        var _now = now();
        
        return createDate(year(_now), month(_now), day(_now()));
    }
}