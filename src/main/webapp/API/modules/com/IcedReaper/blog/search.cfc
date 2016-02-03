component {
    public search function init() {
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
        //variables.releaseDate       = null;
        
        return this;
    }
    
    public search function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        // todo: validation
        // todo: multiple userIds
        
        return this;
    }
    
    public search function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        // todo: validation
        // todo: multiple userIds
        
        return this;
    }
    
    public search function setReleased(required numeric released) {
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
    
    /*public search function setReleaseDate(required date releaseDate) {
        variables.releaseDate = arguments.releaseDate;
        
        return this;
    }*/
    
    public search function setSortBy(required string sortBy) {
        switch(lCase(arguments.sortBy)) {
            case 'creationdate':
            case 'lasteditdate':
            // case 'imageCount': // not yet implemented...
            case 'headline': {
                variables.sortBy = arguments.sortBy;
                
                break;
            }
        }
    }
    
    public search function setSortDirection(required string sortDirection) {
        switch(lCase(arguments.sortDirection)) {
            case 'asc':
            case 'desc': {
                variables.sortDirection = arguments.sortDirection;
                
                break;
            }
        }
    }
    
    public search function setCategory(required string categoryName) {
        variables.categoryName = arguments.categoryName;
        
        return this;
    }
    
    public search function setLink(required string link) {
        // todo: validation
        variables.link = arguments.link;
        
        return this;
    }
    
    public search function setOffset(required numeric offset) {
        if(arguments.offset > 0) {
            variables.offset = arguments.offset;
        }
        
        return this;
    }
    
    public search function setCount(required numeric count) {
        if(arguments.count > 0) {
            variables.count = arguments.count;
        }
        
        return this;
    }
    
    public numeric function getTotalBlogpostCount() {
        return variables.totalBlogpostCount;
    }
    
    public array function execute() {
        var qSearch = new Query();
        
        var sql = "SELECT blogpostId 
                     FROM icedreaper_blog_blogpost ";
        var where = "";
        var orderBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
        if(variables.released != -1) {
            where &= ((where != "") ? " AND " : " WHERE ") & " released = :released";
            qSearch.addParam(name = "released", value = variables.released, cfsqltype = "cf_sql_bit");
        }
        
        /*if(variables.releaseDate != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " (releaseDate IS NULL OR releaseDate <= :releaseDate) "; // todo: check for dates with time || or if releaseDate needs to get stripped down to yyyy/mm7dd
            qSearch.addParam(name = "releaseDate", value = variables.releaseDate, cfsqltype = "cf_sql_date");
        }*/
        
        if(variables.userId != 0 && variables.userId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " userId = :userId";
            qSearch.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.blogpostId != 0 && variables.blogpostId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " blogpostId = :blogpostId";
            qSearch.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.link != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & " link = :link";
            qSearch.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
        }
        
        if(variables.categoryName != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & "blogpostId IN (SELECT blogpostId
                                                                               FROM icedreaper_blog_blogpostCategory
                                                                              WHERE categoryId = (SELECT categoryId
                                                                                                    FROM icedreaper_blog_category
                                                                                                   WHERE name = :categoryName))";
            qSearch.addParam(name = "categoryName", value = variables.categoryName, cfsqltype="cf_sql_varchar");
        }
        
        var qBlogpostIds = qSearch.setSQL(sql & where & orderBy)
                                  .execute()
                                  .getResult();
        
        variables.totalBlogpostCount = qBlogpostIds.getRecordCount();
        
        var blogposts = [];
        
        var i = variables.offset + 1;
        var to = variables.offset + variables.count;
        if(to == 0 || to > qBlogpostIds.getRecordCount()) {
            to = qBlogpostIds.getRecordCount();
        }
        
        for(; i <= to; i++) {
            blogposts.append(new blogpost(qBlogpostIds.blogpostId[i]));
        }
        
        return blogposts;
    }
}

/* more possible search parameter:
 * - adding tags to galleries and search by them
 */