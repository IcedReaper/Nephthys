component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.gallery.*";
    
    public filter function init() {
        variables.pagesRequireAction = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setPagesRequireAction(required numeric pagesRequireAction) {
        variables.pagesRequireAction = arguments.pagesRequireAction
        
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "SELECT statusId
                 FROM IcedReaper_gallery_status s ";
        
        where = "";
        if(variables.pagesRequireAction != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "s.pagesRequireAction = :pagesRequireAction";
            qryFilter.addParam(name = "pagesRequireAction", value = variables.pagesRequireAction, cfsqltype = "cf_sql_bit");
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