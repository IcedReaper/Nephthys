component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.page.*";
    
    public filter function init() {
        variables.hierarchyId   = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setHierarchyId(required numeric hierarchyId) {
        variables.hierarchyId = arguments.hierarchyId;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "    SELECT p.hierarchyPageId
                     FROM nephthys_page_hierarchyPage hp";
        where = "";
        if(variables.hierarchyId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " hp.hierarchyId = :hierarchyId";
            qryFilter.addParam(name = "hierarchyId", value = variables.hierarchyId, cfsqltype = "cf_sql_numeric");
        }
        
        orderBy = " ORDER BY p.pageId ASC";
        
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
                variables.results.append(new hierarchyPage(variables.qRes.hierarchyPageId[i]));
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