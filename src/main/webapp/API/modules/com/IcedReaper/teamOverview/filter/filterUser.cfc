component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.userManager.*";
    
    public filter function init() {
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function execute() {
       variables.qRes = new Query().setSQL("  SELECT userId
                                                FROM nephthys_user
                                               WHERE userId NOT IN (SELECT userId
                                                                      FROM icedReaper_teamOverview_member)
                                                 AND active = :active
                                            ORDER BY userName ASC")
                                   .addParam(name = "active", value = true, cfsqltype = "cf_sql_bit")
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
                variables.results.append(new user(variables.qRes.userId[i]));
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