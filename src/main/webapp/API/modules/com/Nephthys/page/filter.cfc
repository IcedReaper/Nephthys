/*component {
    public filter function init() {
        return this;
    }
    
    public array function getList(required numeric parentId = 0, required string region = 'header', required boolean onlyOnline = true) {
        var qPageIds = getPages(arguments.parentId, arguments.region);
        
        var pageArray = [];
        for(var i = 1; i <= qPageIds.getRecordCount(); i++) {
            var page = createObject("component", "API.modules.com.Nephthys.page.page").init(qPageIds.pageId[i]);
            if(arguments.onlyOnline && page.isOnline() || ! arguments.onlyOnline) {
                pageArray.append(page);
            }
        }
        
        return pageArray;
    }
    
    private query function getPages(required numeric parentId, required string region) {
        var sql = "";
        
        if(arguments.parentId == 0) {
            sql = "  SELECT pageId
                       FROM nephthys_page
                      WHERE parentId IS NULL
                        AND region = :region
                   ORDER BY sortOrder ASC";
        }
        else {
            sql = "  SELECT pageId
                       FROM nephthys_page
                      WHERE parentId = :parentId
                        AND region = :region
                   ORDER BY sortOrder ASC";
        }
        
        return new Query().setSQL(sql)
                          .addParam(name = "parentId", value = arguments.parentId, cfsqltype = "cf_sql_numeric")
                          .addParam(name = "region",   value = arguments.region, cfsqltype = "cf_sql_varchar")
                          .execute()
                          .getResult();
    }
}*/
component implements="API.interfaces.filter" {
    public filter function init() {
        variables.pageId   = null;
        variables.linkText = null;
        variables.link     = null;
        variables.active   = null;
        variables.parentId = null;
        variables.region   = null;
        
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
    
    public filter function execute() {
        var qryFilter = new Query();
        var sql = "SELECT pageId
                     FROM nephthys_page ";
        
        var where = "";
        if(variables.pageId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pageId = :pageId";
            qryFilter.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.parentId != null) {
            if(variables.parentId != 0) {
                where &= (where == "" ? " WHERE " : " AND ") & "parentId = :parentId";
                qryFilter.addParam(name = "parentId", value = variables.parentId, cfsqltype = "cf_sql_numeric");
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & "parentId IS NULL";
            }
        }
        if(variables.linkText != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(linkText) = :linkText";
            qryFilter.addParam(name = "linkText", value = lCase(variables.linkText), cfsqltype = "cf_sql_varchar");
        }
        if(variables.link != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(link) = :link";
            qryFilter.addParam(name = "link", value = lCase(variables.link), cfsqltype = "cf_sql_varchar");
        }
        if(variables.region != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(region) = :region";
            qryFilter.addParam(name = "region", value = lCase(variables.region), cfsqltype = "cf_sql_varchar");
        }
        if(variables.active != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "active = :active";
            qryFilter.addParam(name = "active", value = variables.active, cfsqltype = "cf_sql_bit");
        }
        
        sql &= where & " ORDER BY sortOrder ASC";
        
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