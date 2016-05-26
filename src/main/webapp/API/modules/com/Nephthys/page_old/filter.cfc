component implements="API.interfaces.filter" {
    public filter function init() {
        variables.pageId   = null;
        variables.linkText = null;
        variables.link     = null;
        variables.active   = null;
        variables.parentId = null;
        variables.region   = null;
        variables.version  = null;
        
        variables.qRes = null;
        variables.results = null;
        
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
    public filter function setLinkText(required string linkText) {
        variables.linkText = arguments.linkText;
        return this;
    }
    public filter function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    public filter function setRegion(required string region) {
        variables.region = arguments.region;
        return this;
    }
    public filter function setActive(required boolean active) {
        variables.active = arguments.active;
        return this;
    }
    public filter function setVersion(required string version) {
        variables.version = arguments.version;
        return this;
    }
    
    public filter function execute() {
        var qryFilter = new Query();
        var sql = "    SELECT p.pageId
                         FROM nephthys_page p
                   INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                   INNER JOIN nephthys_pageHierarchy ph ON p.pageId = ph.pageId
                   INNER JOIN nephthys_pageStatus ps ON pv.pageStatusId = ps.pageStatusId";
        
        var where = "";
        if(variables.pageId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "p.pageId = :pageId";
            qryFilter.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.parentId != null) {
            if(variables.parentId != 0) {
                where &= (where == "" ? " WHERE " : " AND ") & "pv.parentPageId = :parentId";
                qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & "pv.parentPageId IS NULL";
            }
        }
        if(variables.linkText != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.linkText) = :linkText";
            qryFilter.addParam(name = "linkText", value = lCase(variables.linkText), cfsqltype = "cf_sql_varchar");
        }
        if(variables.link != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(pv.link) = :link";
            qryFilter.addParam(name = "link", value = lCase(variables.link), cfsqltype = "cf_sql_varchar");
        }
        if(variables.region != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.region = :region";
            qryFilter.addParam(name = "region", value = lCase(variables.region), cfsqltype = "cf_sql_varchar");
        }
        if(variables.active != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.active = :active";
            qryFilter.addParam(name = "active", value = variables.active, cfsqltype = "cf_sql_bit");
        }
        if(variables.version != null) {
            if(variables.version == "actual") {
                where &= (where == "" ? " WHERE " : " AND ") & "p.actualVersion = pv.version";
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & "pv.version = :version";
                qryFilter.addParam(name = "version", value = variables.version, cfsqltype = "cf_sql_varchar");
            }
        }
        
        sql &= where & " ORDER BY ph.sortOrder ASC";
        
        variables.qRes = qryFilter.setSQL(sql)
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