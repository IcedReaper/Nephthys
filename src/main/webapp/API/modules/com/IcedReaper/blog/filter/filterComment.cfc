component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.blog.*";
    
    public filter function init() {
        variables.blogpost = null;
        
        variables.sortBy = "c.creationDate";
        variables.sortDirection = "ASC";
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setBlogpost(required blogpost blogpost) {
        variables.blogpost = arguments.blogpost;
        return this;
    }
    public filter function setSortBy(required string sortBy) {
        switch(lCase(arguments.sortBy)) {
            case 'commentid':
            case 'creationdate':
            case 'publisheddate': {
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
    
    public filter function execute() {
        if(isNull(variables.blogpost)) {
            throw(type = "Nepthyhs.filter.conditionsNotMet", message = "Please specify the blogpost");
        }
        
        variables.results = null;
        var qryFilter = new Query();
        
        var sql = "SELECT c.commentId, c.blogpostId
                     FROM IcedReaper_blog_comment c ";
        
        var where = "";
        if(variables.blogpost.getBlogpostId() != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " c.blogpostId = :blogpostId ";
            qryFilter.addParam(name = "blogpostId", value = variables.blogpost.getBlogpostId(), cfsqltype = "cf_sql_numeric");
        }
        
        sql &= where & " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
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
            variables.results.append(new comment(variables.qRes.commentId[i], variables.blogpost));
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