component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.pages.*";
    
    public filter function init() {
        variables.link = null;
        
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    public filter function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    
    
    public filter function execute() {
        if(variables.link == null) {
            throw(type = "nephthys.application.notAllowed", message = "Please set a link to use this filter");
        }
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "SELECT page.pageId,
                      page.preparredLink,
                      regexp_matches(:link, page.preparredLink || page.suffix || '$', 'i') parameter,
                      page.suffix
                 FROM (    SELECT p.pageId,
                                  '^' || replace(pv.link, '/', '\/') preparredLink,
                                  CASE 
                                    WHEN pv.useDynamicUrlSuffix = true THEN 
                                      '(?:\/(\w*|\-|\s|\.)*)*'
                                    ELSE 
                                      ''
                                  END suffix
                             FROM nephthys_page_page p
                       INNER JOIN nephthys_page_pageVersion pv ON p.pageId     = pv.pageId
                       INNER JOIN nephthys_page_status      ps ON pv.statusId  = ps.statusId
                       INNER JOIN nephthys_page_sitemapPage sp ON p.pageId     = sp.pageId
                       INNER JOIN nephthys_page_sitemap     sm ON sp.sitemapId = sm.sitemapId
                       INNER JOIN nephthys_page_status      hs ON sm.statusId  = hs.statusId
                            WHERE ps.online = :online
                              AND hs.online = :online) page";
                              
        qryFilter.addParam(name = "link",   value = variables.link, cfsqltype = "cf_sql_varchar")
                 .addParam(name = "active", value = 1,              cfsqltype = "cf_sql_bit")
                 .addParam(name = "online", value = 1,              cfsqltype = "cf_sql_bit")
        
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
                variables.results.append({
                    page = new page(variables.qRes.pageId[i]),
                    parameter = reReplaceNoCase(variables.link, variables.qRes.preparredLink[i], "")
                });
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