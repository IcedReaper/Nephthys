component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.page.*";
    
    public filter function init() {
        variables.link          = null;
        variables.online        = null;
        variables.majorVersion  = null;
        variables.minorVersion  = null;
        variables.statusId      = null;
        
        variables.parentId     = null;
        variables.regionId     = null;
        variables.sitemapId  = null;
        
        variables.inSitemap = false;
        
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    public filter function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    public filter function setOnline(required boolean online) {
        variables.online = arguments.online;
        return this;
    }
    public filter function setMajorVersion(required numeric majorVersion) {
        variables.majorVersion = arguments.majorVersion;
        return this;
    }
    public filter function setMinorVersion(required numeric minorVersion) {
        variables.minorVersion = arguments.minorVersion;
        return this;
    }
    public filter function setStatusId(required numeric statusId) {
        variables.statusId = arguments.statusId;
        return this;
    }
    
    public filter function setRegionId(required numeric regionId) {
        variables.regionId = arguments.regionId;
        return this;
    }
    public filter function setParentId(required numeric parentId) {
        variables.parentId = arguments.parentId;
        return this;
    }
    public filter function setSitemapId(required numeric sitemapId) {
        variables.sitemapId = arguments.sitemapId;
        return this;
    }
    public filter function setInSitemap(required boolean inSitemap) {
        variables.inSitemap = arguments.inSitemap;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        var innerQuery = "";
        
        if(variables.inSitemap) {
            var innerQuery = "    SELECT sp.pageId, sp.sortOrder
                                    FROM nephthys_page_sitemapPage sp
                              INNER JOIN nephthys_page_sitemap     sm ON sp.sitemapId = sm.sitemapId
                              INNER JOIN nephthys_page_status      ss ON sm.statusId  = ss.statusId ";
            
            var innerWhere = "";
            if(variables.regionId != null) {
                innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "sp.regionId = :regionId";
                qryFilter.addParam(name = "regionId", value = variables.regionId, cfsqltype = "cf_sql_numeric");
            }
            if(variables.online != null) {
                innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "ss.online = :hsOnline";
                qryFilter.addParam(name = "hsOnline", value = variables.online, cfsqltype = "cf_sql_bit");
            }
            if(variables.parentId != null) {
                innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "sp.parentPageId = :parentId";
                qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
            }
            if(variables.statusId != null) {
                innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "sm.statusId = :statusId";
                qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
            }
            if(variables.sitemapId != null) {
                innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "sm.sitemapId = :sitemapId";
                qryFilter.addParam(name = "sitemapId", value = variables.sitemapId, cfsqltype = "cf_sql_numeric");
            }
            
            innerQuery &= innerWhere;
            
            innerQuery = " INNER JOIN (" & innerQuery & ") sitemap ON p.pageId = sitemap.pageId "
        }
        
        sql = "    SELECT DISTINCT p.pageId, pv.link
                     FROM nephthys_page_page p
               INNER JOIN nephthys_page_pageVersion pv ON p.pageId = pv.pageId
               INNER JOIN nephthys_page_status      ps ON pv.statusId = ps.statusId "
            & innerQuery;
        
        if(variables.link != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
            qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
        }
        if(variables.statusId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.statusId = :statusId";
            qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.online != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "ps.online = :online";
            qryFilter.addParam(name = "online", value = variables.online, cfsqltype = "cf_sql_bit");
        }
        if(variables.majorVersion == null && variables.minorVersion == null) {
            where &= (where == "" ? " WHERE " : " AND ") & "p.pageVersionId = pv.pageversionId";
        }
        else {
            if(variables.majorVersion != null) {
                where &= (where == "" ? " WHERE " : " AND ") & "pv.majorVersion = :majorVersion";
                qryFilter.addParam(name = "majorVersion", value = variables.majorVersion, cfsqltype = "cf_sql_numeric");
            }
            if(variables.minorVersion != null) {
                where &= (where == "" ? " WHERE " : " AND ") & "pv.minorVersion = :minorVersion";
                qryFilter.addParam(name = "minorVersion", value = variables.minorVersion, cfsqltype = "cf_sql_numeric");
            }
        }
        orderBy = " ORDER BY pv.link, p.pageId ASC";
        
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