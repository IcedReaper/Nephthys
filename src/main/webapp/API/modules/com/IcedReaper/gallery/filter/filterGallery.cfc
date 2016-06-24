component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.gallery.*";
    
    public filter function init() {
        variables.userId            = 0; // 0 => all | other => specific userId
        variables.published         = -1; // -1 => all | 0 | 1
        variables.sortBy            = "creationDate";
        variables.sortDirection     = "DESC";
        variables.link              = "";
        variables.galleryId         = 0;
        variables.offset            = 0;
        variables.count             = 0;
        variables.totalGalleryCount = 0;
        variables.categoryName      = "";
        variables.statusId          = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        return this;
    }
    
    public filter function setGalleryId(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        return this;
    }
    
    public filter function setPublished(required numeric published) {
        switch(arguments.published) {
            case -1:
            case 0:
            case 1: {
                variables.published = arguments.published;
                
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
    
    public filter function setstatusId(required numeric statusId) {
        variables.statusId = arguments.statusId;
        
        return this;
    }
    
    public filter function execute() {
        var qryFilter = new Query();
        
        var sql = "SELECT galleryId 
                     FROM icedreaper_gallery_gallery ";
        var where = "";
        var orderBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
        if(variables.published != -1) {
            where &= ((where != "") ? " AND " : " WHERE ") & " activeStatus = :activeStatus";
            qryFilter.addParam(name = "activeStatus", value = variables.published, cfsqltype = "cf_sql_bit");
        }
        
        if(variables.userId != 0 && variables.userId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " userId = :userId";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.galleryId != 0 && variables.galleryId != null) {
            where &= ((where != "") ? " AND " : " WHERE ") & " galleryId = :galleryId";
            qryFilter.addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.link != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & " link = :link";
            qryFilter.addParam(name = "link", value = variables.link, cfsqltype = "cf_sql_varchar");
        }
        
        if(variables.statusId != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & " statusId = :statusId";
            qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_varchar");
        }
        
        if(variables.categoryName != "") {
            where &= ((where != "") ? " AND " : " WHERE ") & "galleryId IN (SELECT galleryId
                                                                              FROM icedreaper_gallery_galleryCategory
                                                                             WHERE categoryId = (SELECT categoryId
                                                                                                   FROM icedreaper_gallery_category
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
            variables.results.append(new gallery(variables.qRes.galleryId[i]));
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