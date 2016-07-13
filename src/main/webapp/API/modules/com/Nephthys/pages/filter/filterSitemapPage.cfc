component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.pages.*";
    
    public filter function init() {
        variables.sitemapId = null;
        variables.regionId  = null;
        variables.pageId    = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setSitemapId(required numeric sitemapId) {
        variables.sitemapId = arguments.sitemapId;
        return this;
    }
    public filter function setRegionId(required numeric regionId) {
        variables.regionId = arguments.regionId;
        return this;
    }
    public filter function setPageId(required numeric pageId) {
        variables.pageId = arguments.pageId;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "    SELECT sp.sitemapPageId
                     FROM nephthys_page_sitemapPage sp";
        where = "";
        if(variables.sitemapId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " sp.sitemapId = :sitemapId";
            qryFilter.addParam(name = "sitemapId", value = variables.sitemapId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.regionId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " sp.regionId = :regionId";
            qryFilter.addParam(name = "regionId", value = variables.regionId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.pageId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " sp.pageId = :pageId";
            qryFilter.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
        }
        
        orderBy = " ORDER BY sp.sitemapPageId ASC";
        
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
                variables.results.append(new sitemapPage(variables.qRes.sitemapPageId[i]));
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