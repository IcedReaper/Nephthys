component implements="API.interfaces.filter" {
    public filter function init() {
        variables.pageId             = null;
        variables.link               = null;
        variables.online             = null;
        variables.parentId           = null;
        variables.region             = null;
        variables.actualVersion      = null;
        variables.majorVersion       = null;
        variables.minorVersion       = null;
        variables.pageStatusId       = null;
        variables.hierarchyVersionId = null;
        
        // only for variables.for == 'pageStatus'
        variables.startStatus = null;
        variables.endStatus   = null;
        
        // only for hierarchy
        variables.pageHierarchyVersionId = null;
        
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
            case "pageStatus": {
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
    public filter function setHierarchyVersionId(required numeric hierarchyVersionId) {
        variables.hierarchyVersionId = arguments.hierarchyVersionId;
        return this;
    }
    public filter function setPageStatusId(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        return this;
    }
    
    
    public filter function setStartStatus(required boolean startStatus) {
        variables.startStatus = arguments.startStatus;
        return this;
    }
    public filter function setEndStatus(required boolean endStatus) {
        variables.endStatus = arguments.endStatus;
        return this;
    }
    
    
    public filter function setPageHierarchyVersionId(required numeric pageHierarchyVersionId) {
        variables.pageHierarchyVersionId = arguments.pageHierarchyVersionId;
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
                             FROM nephthys_page p
                       INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                       INNER JOIN nephthys_pageStatus  ps ON pv.pageStatusId = ps.pageStatusId";
                
                if(variables.link != null) {
                    // TODO: regEx | parameter check
                    where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
                    qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
                }
                if(variables.pageStatusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "pv.pageStatusId = :pageStatusId";
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
                var innerQuery = "    SELECT h.pageId, h.sortOrder
                                        FROM nephthys_pageHierarchy h
                                  INNER JOIN nephthys_pageHierarchyVersion hv ON h.pageHierarchyVersionId = hv.pageHierarchyVersionId
                                  INNER JOIN nephthys_pageStatus hs ON hv.pageStatusId = hs.pageStatusId ";
                
                var innerWhere = "";
                if(variables.region != null && variables.region != "null") {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.region = :region";
                    qryFilter.addParam(name = "region", value = variables.region, cfsqltype = "cf_sql_varchar");
                }
                if(variables.online != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hs.offline = :online";
                    qryFilter.addParam(name = "online", value = ! variables.online, cfsqltype = "cf_sql_bit");
                }
                if(variables.parentId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.parentPageId = :parentId";
                    qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.pageStatusId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hv.pageStatusId = :pageStatusId";
                    qryFilter.addParam(name = "pageStatusId", value = variables.pageStatusId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.hierarchyVersionId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hv.pageHierarchyVersionId = :hierarchyVersionId";
                    qryFilter.addParam(name = "hierarchyVersionId", value = variables.hierarchyVersionId, cfsqltype = "cf_sql_numeric");
                }
                
                innerQuery &= innerWhere;
                
                sql = "    SELECT p.pageId
                             FROM nephthys_page p
                       INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                       INNER JOIN nephthys_pageStatus  ps ON pv.pageStatusId = ps.pageStatusId
                       INNER JOIN (" & innerQuery & ") ph ON p.pageId = ph.pageId";
                
                if(variables.link != null) {
                    // TODO: regEx | parameter check
                    where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
                    qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
                }
                if(variables.pageStatusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "pv.pageStatusId = :pageStatusId";
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
                
                orderBy = " ORDER BY ph.sortOrder ASC";
                
                break;
            }
            case "pageVersion": {
                break;
            }
            case "hierarchy": {
                
                sql = "    SELECT hv.pageHierarchyVersionId, hv.pageStatusId
                             FROM nephthys_pageHierarchyVersion hv
                       INNER JOIN nephthys_pageStatus ps ON hv.pageStatusId = ps.pageStatusId";
                
                if(variables.pageHierarchyVersionId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "hv.pageHierarchyVersionId = :pageHierarchyVersionId";
                    qryFilter.addParam(name = "pageHierarchyVersionId", value = variables.pageHierarchyVersionId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.pageStatusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "hv.pageStatusId = :pageStatusId";
                    qryFilter.addParam(name = "pageStatusId", value = variables.pageStatusId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.online != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "ps.offline = :online";
                    qryFilter.addParam(name = "online", value = ! variables.online, cfsqltype = "cf_sql_bit");
                }
                
                orderBy = " ORDER BY hv.pageHierarchyVersionId ASC";
                
                break;
            }
            case "pagesNotInHierarchy": {
                var innerQuery = "    SELECT h.pageId
                                        FROM nephthys_pageHierarchy h
                                  INNER JOIN nephthys_pageHierarchyVersion hv ON h.pageHierarchyVersionId = hv.pageHierarchyVersionId
                                  INNER JOIN nephthys_pageStatus hs ON hv.pageStatusId = hs.pageStatusId ";
                
                var innerWhere = "";
                if(variables.region != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.region = :region";
                    qryFilter.addParam(name = "region", value = variables.region, cfsqltype = "cf_sql_varchar");
                }
                if(variables.parentId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "h.parentPageId = :parentId";
                    qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.pageStatusId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hv.pageStatusId = :pageStatusId";
                    qryFilter.addParam(name = "pageStatusId", value = variables.pageStatusId, cfsqltype = "cf_sql_numeric");
                }
                if(variables.hierarchyVersionId != null) {
                    innerWhere &= (innerWhere == "" ? " WHERE " : " AND ") & "hv.pageHierarchyVersionId = :hierarchyVersionId";
                    qryFilter.addParam(name = "hierarchyVersionId", value = variables.hierarchyVersionId, cfsqltype = "cf_sql_numeric");
                }
                
                innerQuery &= innerWhere;
                sql = "    SELECT DISTINCT p.pageId
                             FROM nephthys_page p
                       INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                       INNER JOIN nephthys_pageStatus  ps ON pv.pageStatusId = ps.pageStatusId";
                where = " WHERE p.pageId NOT IN ( " & innerQuery & " )";
                
                if(variables.link != null) {
                    // TODO: regEx | parameter check
                    where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
                    qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
                }
                if(variables.pageStatusId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & "pv.pageStatusId = :pageStatusId";
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
            case "pageStatus": {
                var sql = "SELECT pageStatusId
                             FROM nephthys_pageStatus ";
                
                var where = "";
                if(variables.startStatus != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & " startStatus = :startStatus";
                    qryFilter.addParam(name = "startStatus", value = variables.startStatus, cfsqltype = "cf_sql_bit");
                }
                if(variables.endStatus != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & " endStatus = :endStatus";
                    qryFilter.addParam(name = "endStatus", value = variables.endStatus, cfsqltype = "cf_sql_bit");
                }
                
                var orderBy = " ORDER BY pageStatusId";
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
                            "hierarchyVersionId" = variables.qRes.pageHierarchyVersionId[i],
                            "pageStatusId"       = variables.qRes.pageStatusId[i]
                        });
                        break;
                    }
                    case "pageStatus": {
                        variables.results.append(new pageStatus(variables.qRes.pageStatusId[i]));
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