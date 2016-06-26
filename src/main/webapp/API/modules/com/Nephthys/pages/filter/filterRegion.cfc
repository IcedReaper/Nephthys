component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.pages.*";
    
    public filter function init() {
        variables.name = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setName(required string name) {
        variables.name = arguments.name;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "SELECT regionId
                 FROM nephthys_page_region";
        
        where = "";
        if(variables.name != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " name = :name";
            qryFilter.addParam(name = "name", value = variables.name, cfsqltype = "cf_sql_varchar");
        }
        
        orderBy = " ORDER BY regionId ";
        
        variables.qRes = qryFilter.setSQL(sql & where & orderBy)
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
                variables.results.append(new region(variables.qRes.regionId[i]));
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