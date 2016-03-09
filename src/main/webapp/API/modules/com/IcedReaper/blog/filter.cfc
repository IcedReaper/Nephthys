component implements="API.interfaces.filter" {
    public filter function init() {
        variables.userId             = 0; // 0 => all | other => specific userId
        variables.released           = -1; // -1 => all | 0 | 1
        variables.sortBy             = "creationDate";
        variables.sortDirection      = "DESC";
        variables.link               = "";
        variables.blogpostId         = 0;
        variables.offset             = 0;
        variables.count              = 0;
        variables.totalBlogpostCount = 0;
        variables.categoryName       = "";
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        // todo: validation
        // todo: multiple userIds
        
        return this;
    }
    
    public filter function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        // todo: validation
        // todo: multiple userIds
        
        return this;
    }
    
    public filter function setReleased(required numeric released) {
        switch(arguments.released) {
            case -1:
            case 0:
            case 1: {
                variables.released = arguments.released;
                
                break;
            }
        }
        
        return this;
    }
    
    public filter function setSortBy(required string sortBy) {
        switch(lCase(arguments.sortBy)) {
            case 'creationdate':
            case 'lasteditdate':
            // case 'imageCount': // not yet implemented...
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
        // todo: validation
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
    
    public numeric function getTotalBlogpostCount() {
        return variables.totalBlogpostCount;
    }
    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql = "SELECT blogpostId 
                     FROM icedreaper_blog_blogpost ";
        var where = "";
        var orderBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
        if(variables.released != -1) {
            where &= ((where != "") ? " AND " : " WHERE ") & " released = :released";
            qryFilter.addParam(name = "released", value = variables.released, cfsqltype = "cf_sql_bit");
        }
        
        if(variables.userId != 0 && variables.userId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " userId = :userId";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.blogpostId != 0 && variables.blogpostId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " blogpostId = :blogpostId";
            qryFilter.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.link != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & " link = :link";
            qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
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

/* more possible filter parameter:
 * - adding tags to galleries and filter by them
 */