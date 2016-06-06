component implements="API.interfaces.filter" {
    public filter function init() {
        variables.pageId        = null;
        variables.link          = null;
        variables.online        = null;
        variables.parentId      = null;
        variables.region        = null;
        variables.actualVersion = null;
        variables.majorVersion  = null;
        variables.minorVersion  = null;
        variables.statusId      = null;
        variables.hierarchyId   = null;
        
        // only for hierarchy
        variables.hierarchyId = null;
        
        variables.for = "page"; // page | pageVersion | pageHierarchy
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setFor(required string for) {
        switch(arguments.for) {
            case "page":
            case "sitemap":
            case "pageVersion":
            case "hierarchy":
            case "pagesNotInHierarchy":
            case "Status": {
                variables.for = arguments.for;
                break;
            }
        }
        
        return this;
    }
    public filter function setPageId(required numeric pageId) {
        variables.pageId = arguments.pageId;
        return this;
    }
    public filter function setParentId(required numeric parentId) {
        variables.parentId = arguments.parentId;
        return this;
    }
    public filter function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    public filter function setRegion(required string region) {
        variables.region = lCase(arguments.region);
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
    public filter function setHierarchyId(required numeric hierarchyId) {
        variables.hierarchyId = arguments.hierarchyId;
        return this;
    }
    public filter function setStatusId(required numeric statusId) {
        variables.statusId = arguments.statusId;
        return this;
    }
    
    
    public filter function setPageHierarchyVersionId(required numeric hierarchyId) {
        variables.hierarchyId = arguments.hierarchyId;
        return this;
    }
    
    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        switch(variables.for) {
            case "page": {
                sql = "    SELECT DISTINCT p.pageId, pv.link
                             FROM nephthys_page_page p
                       INNER JOIN nephthys_page_pageVersion pv ON p.pageId = pv.pageId
                       INNER JOIN nephthys_page_status  ps ON pv.statusId = ps.statusId";
                
                if(variables.link != null) {
                    // TODO: regEx | parameter check
                    where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
                    qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
                }
                if(variables.statusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "pv.statusId = :statusId";
                }
                if(variables.online != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "ps.offline = :online";
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
                
                break;
            }
            case "sitemap": {
                var innerQuery = "    SELECT hp.pageId, hp.sortOrder
                                        FROM nephthys_page_hierarchyPage hp
                                  INNER JOIN nephthys_page_hierarchy h  ON hp.hierarchyId = h.hierarchyId
                                  INNER JOIN nephthys_page_status    hs ON h.statusId = hs.statusId ";
                
                var innerWhere = "";
                if(variables.region != null && variables.region != "null") {
                    innerQuery &= " INNER JOIN nephthys_page_region r ON hp.regionId = r.regionId"
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "r.name = :region";
                    qryFilter.addParam(name = "region", value = variables.region, cfsqltype = "cf_sql_varchar");
                }
                if(variables.online != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hs.online = :online";
                    qryFilter.addParam(name = "online", value = variables.online, cfsqltype = "cf_sql_bit");
                }
                if(variables.parentId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.parentPageId = :parentId";
                    qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.statusId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hv.statusId = :statusId";
                    qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.hierarchyId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hv.hierarchyId = :hierarchyId";
                    qryFilter.addParam(name = "hierarchyId", value = variables.hierarchyId, cfsqltype = "cf_sql_numeric");
                }
                
                innerQuery &= innerWhere;
                
                sql = "    SELECT p.pageId
                             FROM nephthys_page_page p
                       INNER JOIN nephthys_page_pageVersion pv ON p.pageId = pv.pageId
                       INNER JOIN nephthys_page_status      ps ON pv.statusId = ps.statusId
                       INNER JOIN (" & innerQuery & ")      ph ON p.pageId = ph.pageId";
                
                if(variables.link != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
                    qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
                }
                if(variables.statusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "pv.statusId = :statusId";
                }
                if(variables.online != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "ps.online = :online";
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
                
                orderBy = " ORDER BY ph.sortOrder ASC";
                
                break;
            }
            case "pageVersion": {
                break;
            }
            case "hierarchy": {
                
                sql = "    SELECT h.hierarchyId, hv.statusId
                             FROM nephthys_page_hierarchy h
                       INNER JOIN nephthys_page_status s ON h.statusId = s.statusId";
                
                if(variables.hierarchyId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "h.hierarchyId = :hierarchyId";
                    qryFilter.addParam(name = "hierarchyId", value = variables.hierarchyId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.statusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "h.statusId = :statusId";
                    qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.online != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "s.online = :online";
                    qryFilter.addParam(name = "online", value = variables.online, cfsqltype = "cf_sql_bit");
                }
                
                orderBy = " ORDER BY h.hierarchyId ASC";
                
                break;
            }
            case "pagesNotInHierarchy": {
                var innerQuery = "    SELECT h.pageId
                                        FROM nephthys_page_hierarchyPage hp
                                  INNER JOIN nephthys_page_hierarchy h ON hp.hierarchyId = h.hierarchyId
                                  INNER JOIN nephthys_page_status hs ON hv.statusId = hs.statusId ";
                
                var innerWhere = "";
                if(variables.region != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hp.region = :region";
                    qryFilter.addParam(name = "region", value = variables.region, cfsqltype = "cf_sql_varchar");
                }
                if(variables.parentId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hp.parentPageId = :parentId";
                    qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.statusId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.statusId = :statusId";
                    qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.hierarchyId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.hierarchyId = :hierarchyId";
                    qryFilter.addParam(name = "hierarchyId", value = variables.hierarchyId, cfsqltype = "cf_sql_numeric");
                }
                
                innerQuery &= innerWhere;
                sql = "    SELECT DISTINCT p.pageId
                             FROM nephthys_page_page p
                       INNER JOIN nephthys_page_pageVersion pv ON p.pageId = pv.pageId
                       INNER JOIN nephthys_page_status      ps ON pv.statusId = ps.statusId";
                where = " WHERE p.pageId NOT IN ( " & innerQuery & " )";
                
                if(variables.link != null) {
                    // TODO: regEx | parameter check
                    where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
                    qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
                }
                if(variables.statusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "pv.statusId = :statusId";
                }
                if(variables.online != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "ps.offline = :online";
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
                
                orderBy = " ORDER BY p.pageId ASC";
                
                break;
            }
            case "Status": {
                var sql = "SELECT statusId
                             FROM nephthys_page_status ";
                
                var where = "";
                
                var orderBy = " ORDER BY statusId";
                break;
            }
        }
        
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
                switch(variables.for) {
                    case "page":
                    case "sitemap":
                    case "pagesNotInHierarchy": {
                        variables.results.append(new page(variables.qRes.pageId[i]));
                        break;
                    }
                    case "pageVersion": {
                        break;
                    }
                    case "hierarchy": {
                        variables.results.append({
                            "hierarchyId" = variables.qRes.hierarchyId[i],
                            "statusId"    = variables.qRes.statusId[i]
                        });
                        break;
                    }
                    case "Status": {
                        variables.results.append(new status(variables.qRes.statusId[i]));
                        break;
                    }
                }
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