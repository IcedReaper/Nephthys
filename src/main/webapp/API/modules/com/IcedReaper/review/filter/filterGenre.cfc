component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.review.*";
    
    public filter function init() {
        variables.review = null;
        
        variables.offset        = 0;
        variables.count         = 0;
        variables.likeName      = null;
        variables.sortBy        = "creationDate";
        variables.sortDirection = "DESC";
        variables.qRes          = null;
        variables.results       = null;
        
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
    
    public filter function setLikeName(required string likeName) {
        variables.likeName = arguments.likeName;
        
        return this;
    }
    
    public filter function setReview(required review review) {
        variables.review = arguments.review;
        
        return this;
    }
    
    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql = "SELECT genreId 
                     FROM IcedReaper_review_genre ";
        var where = "";
        
        if(variables.likeName != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " name LIKE :likeName ";
            qryFilter.addParam(name = "likeName", value = "%" & variables.likeName & "%", cfsqltype = "cf_sql_varchar");
        }
        
        if(! isNull(variables.review) {
            where &= (where == "" ? " WHERE " : " AND ") & " reviewId = :reviewId ";
            qryFilter.addParam(name = "reviewId", value = variables.review.getReviewId(), cfsqltype = "cf_sql_numeric");
        }
        
        var orderBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
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
            variables.results.append(new genre(variables.qRes.genreId[i]));
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