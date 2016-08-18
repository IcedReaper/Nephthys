component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.references.*";
    
    public filter function init() {
        variables.sortDirection = "ASC";
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setSortDirection(required string sortDirection) {
        if(lCase(arguments.sortDirection) == "ASC" || lCase(arguments.sortDirection) == "DESC") {
            variables.sortDirection = arguments.sortDirection;
        }
        
        return this;
    }
    
    public filter function execute() {
        variables.results = [];
        variables.qRes = null;
        
        var qryFilter = new Query();
        
        var sql = "SELECT referenceId 
                     FROM IcedReaper_references_reference "
        var where = "";
        var orderBy = " ORDER BY position " & variables.sortDirection;
        
        sql &= where & orderBy;
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        variables.results = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
            variables.results.append(new reference(variables.qRes.referenceId[i]));
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