component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.pageManager.*";
    
    public filter function init() {
        variables.pageVersionId = null;
        variables.sitemapId = null;
        
        variables.sortBy = "approvalDate";
        variables.sortDirection = "ASC";
        variables.offset = null;
        variables.limit = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setPageVersionId(required numeric pageVersionId) {
        variables.pageVersionId = arguments.pageVersionId;
        return this;
    }
    public filter function setSitemapId(required numeric sitemapId) {
        variables.sitemapId = arguments.sitemapId;
        return this;
    }
    
    
    public filter function setSortBy(required string sortBy) {
        switch(lCase(arguments.sortBy)) {
            case "approvaldate": {
                variables.sortBy = arguments.sortBy;
                
                break;
            }
        }
        return this;
    }
    public filter function setSortDirection(required string sortDirection) {
        switch(lCase(arguments.sortDirection)) {
            case "asc":
            case "desc": {
                variables.sortDirection = arguments.sortDirection;
                
                break;
            }
        }
        return this;
    }
    public filter function setOffset(required numeric offset) {
        variables.offset = arguments.offset;
        return this;
    }
    public filter function setLimit(required numeric limit) {
        variables.limit = arguments.limit;
        return this;
    }
    
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "SELECT approvalId
                     FROM nephthys_page_approval ";
        var where = "";
        var sortBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        var limit = "";
        var offset = "";
        
        if(variables.limit != null) {
            limit = " LIMIT " & variables.limit;
        }
        if(variables.offset != null) {
            offset = " OFFSET " & variables.offset;
        }
        
        if(variables.pageVersionId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " pageVersionId = :pageVersionId";
            qryFilter.addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.sitemapId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " sitemapId = :sitemapId";
            qryFilter.addParam(name = "sitemapId", value = variables.sitemapId, cfsqltype = "cf_sql_numeric");
        }
        
        sql &= where & sortBy & limit & offset;
        
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
                variables.results.append(new approval(variables.qRes.approvalId[i]));
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