component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.blog.*";
    
    public filter function init() {
        variables.categoryId   = null;
        variables.name         = null;
        variables.blogpostId   = null;
        variables.useExactName = false;
        variables.used         = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setCategoryId(required numeric categoryId) {
        variables.categoryId = arguments.categoryId;
        return this;
    }
    
    public filter function setName(required string name) {
        variables.name = arguments.name;
        return this;
    }
    
    public filter function setUseExactName(required boolean useExactName) {
        variables.useExactName = arguments.useExactName;
        return this;
    }
    
    public filter function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        return this;
    }
    
    public filter function setUsed(required boolean used) {
        variables.used = arguments.used;
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql = "SELECT c.categoryId
                     FROM IcedReaper_blog_category c";
        
        if(variables.blogpostId != null) {
            sql &=" INNER JOIN (  SELECT COUNT(bc.*) count, bc.categoryId
                                    FROM IcedReaper_blog_blogpostCategory bc
                                   WHERE bc.blogpostId = :blogpostId
                                GROUP BY bc.categoryId) bCat ON c.categoryId = bCat.categoryId ";
            qryFilter.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
        }
        
        var where = "";
        if(variables.categoryId != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " c.categoryId = :categoryId ";
            qryFilter.addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.name != null) {
            if(variables.useExactName) {
                where &= ((where == "") ? " WHERE " : " AND ") & " c.name = :name ";
                qryFilter.addParam(name = "name", value = variables.name, cfsqltype = "cf_sql_varchar");
            }
            else {
                where &= ((where == "") ? " WHERE " : " AND ") & " lower(c.name) LIKE :name ";
                qryFilter.addParam(name = "name", value = "%" & lCase(variables.name) & "%", cfsqltype = "cf_sql_varchar");
            }
        }
        if(variables.used != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " c.categoryId IN (    SELECT bc.categoryId
                                                                                    FROM IcedReaper_blog_blogpostCategory bc
                                                                              INNER JOIN IcedReaper_blog_blogpost bp ON bc.blogpostId = bp.blogpostId
                                                                              INNER JOIN IcedReaper_blog_status s ON bp.statusId = s.statusId
                                                                                   WHERE s.online = :online) ";
            qryFilter.addParam(name = "online", value = true, cfsqltype = "cf_sql_bit");
        }
        
        sql &= where & " ORDER BY name ASC";
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        variables.results = [];
        
        for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
            variables.results.append(new category(variables.qRes.categoryId[i]));
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