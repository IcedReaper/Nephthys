component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.userManager.*";
    
    public filter function init() {
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "";
        var where = "";
        
        sql = "SELECT extPropertyKeyId
                 FROM Nephthys_user_extPropertyKey "
            & where;
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(isNull(variables.results)) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new extPropertyKey(variables.qRes.extPropertyKeyId[i]));
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