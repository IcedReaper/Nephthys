component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.pageManager.*";
    
    public filter function init() {
        variables.showInTasklist = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setShowInTasklist(required numeric showInTasklist) {
        variables.showInTasklist = arguments.showInTasklist
        
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "SELECT statusId
                 FROM nephthys_page_status s ";
        
        where = "";
        if(variables.showInTasklist != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "s.showInTasklist = :showInTasklist";
            qryFilter.addParam(name = "showInTasklist", value = variables.showInTasklist, cfsqltype = "cf_sql_bit");
        }
        
        orderBy = " ORDER BY statusId";
        
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
                variables.results.append(new status(variables.qRes.statusId[i]));
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