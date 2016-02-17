component implements="API.interfaces.filter" {
    public filter function init() {
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function execute() {
        variables.qRes = new Query().setSQL("  SELECT pageStatusId
                                                 FROM nephthys_pageStatus
                                             ORDER BY pageStatusId")
                                    .execute()
                                    .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(variables.results == null) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new pageStatus(variables.qRes.pageStatusId[i]));
            }
        }
        return variables.results;
    }
    
    public numeric function getResultCount() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        return variables.qRes.getRecordCount();
    }
}