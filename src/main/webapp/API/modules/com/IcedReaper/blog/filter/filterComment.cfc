component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.blog.*";
    
    public filter function init() {
        variables.blogpostId = null;
        
        variables.sortBy = "c.creationDate";
        variables.sortDirection = "ASC";
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
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
        variables.results = null;
        var qryFilter = new Query();
        
        var sql = "SELECT c.commentId
                     FROM IcedReaper_blog_comment c ";
        
        var where = "";
        if(variables.blogpostId != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " c.blogpostId = :blogpostId ";
            qryFilter.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
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
            variables.results.append(new comment(variables.qRes.commentId[i]));
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