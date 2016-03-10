component implements="API.interfaces.filter" {
    public filter function init() {
        variables.userId        = null;
        variables.reviewId      = null;
        variables.link          = "";
        variables.typeName      = null;
        variables.genreName     = null;
        
        variables.offset        = 0;
        variables.count         = 0;
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
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        return this;
    }
    
    public filter function setReviewId(required numeric reviewId) {
        variables.reviewId = arguments.reviewId;
        
        return this;
    }
    
    public filter function setLink(required string link) {
        variables.link = arguments.link;
        
        return this;
    }
    
    public filter function setType(required string type) {
        variables.typeName = arguments.type;
        
        return this;
    }
    
    public filter function setGenre(required string genre) {
        variables.genreName = arguments.genre;
        
        return this;
    }

    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql = "SELECT reviewId 
                     FROM IcedReaper_review_review ";
        var where = "";
        var orderBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
        if(variables.link != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & " link = :link";
            qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
        }
        
        if(variables.userId != 0 && variables.userId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " creatorUserId = :userId";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.reviewId != 0 && variables.reviewId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " reviewId = :reviewId";
            qryFilter.addParam(name = "reviewId", value = variables.reviewId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.typeName != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & "typeId = (SELECT typeId
                                                                              FROM icedreaper_review_type
                                                                             WHERE name = :typeName)";
            qryFilter.addParam(name = "typeName", value = variables.typeName, cfsqltype="cf_sql_varchar");
        }
        
        if(variables.genreName != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & "reviewId IN (SELECT reviewId
                                                                              FROM icedreaper_review_reviewGenre
                                                                             WHERE genreId = (SELECT genreId
                                                                                                   FROM icedreaper_review_genre
                                                                                                  WHERE name = :genreName))";
            qryFilter.addParam(name = "genreName", value = variables.genreName, cfsqltype="cf_sql_varchar");
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
            variables.results.append(new review(variables.qRes.reviewId[i]));
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