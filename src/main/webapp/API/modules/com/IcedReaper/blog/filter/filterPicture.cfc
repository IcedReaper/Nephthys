component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.blog.*";
    
    public filter function init() {
        variables.blogpostId = null;
        
        variables.sortBy = "sortId";
        variables.sortDirection = "ASC";
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        return this;
    }
    public filter function setSortBy(required string columnName) {
        switch(lCase(arguments.columnName)) {
            case "sortid":
            case "pictureid":
            case "picturefilename":
            case "title":
            case "alt":
            case "caption": {
                variables.sortBy = arguments.columnName;
                break;
            }
        }
        return this;
    }
    
    public filter function setSortDirection(required string sortDirection) {
        switch(lCase(arguments.sortDirection)) {
            case "asc":
            case "desc": {
                variables.sortDirection = arguments.sortDirection;
                break;
            }
        }
        
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql = "SELECT pictureId
                     FROM IcedReaper_blog_picture ";
        
        var where = "";
        if(variables.blogpostId != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " blogpostId = :blogpostId ";
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
            variables.results.append(new picture(variables.qRes.pictureId[i]));
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