component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.page.*";
    
    public filter function init() {
        variables.sitemapId   = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setSitemapId(required numeric sitemapId) {
        variables.sitemapId = arguments.sitemapId;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        var innerQuery = "    SELECT sp.pageId
                                FROM nephthys_page_sitemapPage sp
                          INNER JOIN nephthys_page_sitemap     sm ON sp.sitemapId = sm.sitemapId";
        
        var innerWhere = "";
        if(variables.sitemapId != null) {
            innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "sm.sitemapId = :sitemapId";
            qryFilter.addParam(name = "sitemapId", value = variables.sitemapId, cfsqltype = "cf_sql_numeric");
        }
        
        innerQuery &= innerWhere;
        sql = "    SELECT DISTINCT p.pageId
                     FROM nephthys_page_page p
               INNER JOIN nephthys_page_pageVersion pv ON p.pageId = pv.pageId
               INNER JOIN nephthys_page_status      ps ON pv.statusId = ps.statusId";
        where = " WHERE p.pageId NOT IN ( " & innerQuery & " )";
        
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
                variables.results.append(new page(variables.qRes.pageId[i]));
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