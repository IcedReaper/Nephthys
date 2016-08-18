component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.pageManager.*";
    
    public filter function init() {
        variables.moduleName = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    public filter function setModuleName(required string moduleName) {
        variables.moduleName = arguments.moduleName;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        var innerQuery = "";
        
        variables.qRes = new Query().setSQL("    SELECT pv.pageVersionId
                                                   FROM nephthys_page_pageVersion pv
                                             INNER JOIN nephthys_page_sitemapPage sp  ON sp.pageId    = pv.pageId
                                             INNER JOIN nephthys_page_sitemap     s   ON sp.sitemapId = s.sitemapId
                                             INNER JOIN nephthys_page_status      pvs ON pv.statusId  = pvs.statusId
                                             INNER JOIN nephthys_page_status      ss  ON s.statusId   = ss.statusId
                                                  WHERE pv.content LIKE :module
                                                    AND pvs.online = :online
                                                    AND ss.online  = :online")
                                    .addParam(name = "module", value = "%""type"":""" & variables.moduleName & """%", cfsqltype = "cf_sql_varchar")
                                    .addParam(name = "online", value = true,                                          cfsqltype = "cf_sql_bit")
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
                variables.results.append(new pageVersion(variables.qRes.pageVersionId[i]));
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