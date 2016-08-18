component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.userManager.*";
    
    public filter function init() {
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function execute() {
       variables.qRes = new Query().setSQL("    SELECT u.userId
                                                  FROM nephthys_user u
                                            INNER JOIN nephthys_user_status s ON u.statusId = s.statusId
                                                 WHERE u.userId NOT IN (SELECT userId
                                                                        FROM icedReaper_teamOverview_member)
                                                   AND s.canLogin = :canLogin
                                            ORDER BY userName ASC")
                                   .addParam(name = "canLogin", value = true, cfsqltype = "cf_sql_bit")
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