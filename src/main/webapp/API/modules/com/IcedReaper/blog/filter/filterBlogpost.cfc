component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.blog.*";
    
    public filter function init() {
        variables.userId             = null;
        variables.released           = null; // -1 => all | 0 | 1
        variables.sortBy             = "creationDate";
        variables.sortDirection      = "DESC";
        variables.link               = "";
        variables.blogpostId         = null;
        variables.totalBlogpostCount = 0;
        variables.categoryName       = "";
        variables.statusId           = null;
        variables.categoryId         = null;
        
        variables.offset  = 0;
        variables.count   = 0;
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        return this;
    }
    
    public filter function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        return this;
    }
    
    public filter function setReleased(required boolean released) {
        variables.released = arguments.released;
        
        return this;
    }
    
    public filter function setSortBy(required string sortBy) {
        switch(lCase(arguments.sortBy)) {
            case 'creationdate':
            case 'lasteditdate':
            case 'headline': {
                variables.sortBy = arguments.sortBy;
                
                break;
            }
        }
        
        return this;
    }
    
    public filter function setSortDirection(required string sortDirection) {
        switch(lCase(arguments.sortDirection)) {
            case 'asc':
            case 'desc': {
                variables.sortDirection = arguments.sortDirection;
                
                break;
            }
        }
        
        return this;
    }
    
    public filter function setCategory(required string categoryName) {
        variables.categoryName = arguments.categoryName;
        
        return this;
    }
    
    public filter function setLink(required string link) {
        variables.link = arguments.link;
        
        return this;
    }
    
    public filter function setOffset(required numeric offset) {
        if(arguments.offset > 0) {
            variables.offset = arguments.offset;
        }
        
        return this;
    }
    
    public filter function setCount(required numeric count) {
        if(arguments.count > 0) {
            variables.count = arguments.count;
        }
        
        return this;
    }
    
    public filter function setStatusId(required numeric statusId) {
        variables.statusId = arguments.statusId;
        return this;
    }
    
    public filter function setCategoryId(required numeric categoryId) {
        variables.categoryId = arguments.categoryId;
        return this;
    }
    
    public numeric function getTotalBlogpostCount() {
        return variables.totalBlogpostCount;
    }
    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql = "SELECT blogpostId 
                     FROM IcedReaper_blog_blogpost ";
        var where = "";
        var orderBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
        if(variables.released != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " (releaseDate IS NULL OR
                                                                releaseDate <= now())
                                                              AND statusId IN (SELECT statusId
                                                                                 FROM IcedReaper_blog_status
                                                                                WHERE online = :online) ";
            qryFilter.addParam(name = "online", value = true, cfsqltype = "cf_sql_bit");
        }
        
        if(variables.userId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " userId = :userId";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.blogpostId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " blogpostId = :blogpostId";
            qryFilter.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.link != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & " link = :link";
            qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
        }
        if(variables.statusId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " statusId = :statusId";
            qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.categoryId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & "blogpostId IN (SELECT blogpostId
                                                                               FROM icedreaper_blog_blogpostCategory
                                                                              WHERE categoryId = :categoryId)";
            qryFilter.addParam(name = "categoryId", value = variables.categoryId, cfsqltype="cf_sql_numeric");
        }
        
        if(variables.categoryName != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & "blogpostId IN (SELECT blogpostId
                                                                               FROM icedreaper_blog_blogpostCategory
                                                                              WHERE categoryId = (SELECT categoryId
                                                                                                    FROM icedreaper_blog_category
                                                                                                   WHERE name = :categoryName))";
            qryFilter.addParam(name = "categoryName", value = variables.categoryName, cfsqltype="cf_sql_varchar");
        }
        
        sql &= where & orderBy;
        
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
        var to = variables.offset + variables.count;
        if(to == 0 || to > variables.qRes.getRecordCount()) {
            to = variables.qRes.getRecordCount();
        }
        
        for(var i = variables.offset + 1; i <= to; i++) {
            variables.results.append(new blogpost(variables.qRes.blogpostId[i]));
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
