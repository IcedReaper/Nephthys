component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.gallery.*";
    
    public filter function init() {
        variables.categoryId   = null;
        variables.name         = null;
        variables.galleryId    = null;
        variables.useExactName = false;
        
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
    
    public filter function setGalleryId(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql = "SELECT categoryId
                     FROM IcedReaper_gallery_category ";
        
        var where = "";
        if(variables.categoryId != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " categoryId = :categoryId ";
            qryFilter.addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.name != null) {
            if(variables.useExactName) {
                where &= ((where == "") ? " WHERE " : " AND ") & " name = :name ";
                qryFilter.addParam(name = "name", value = variables.name, cfsqltype = "cf_sql_varchar");
            }
            else {
                where &= ((where == "") ? " WHERE " : " AND ") & "  lower(name) LIKE :name ";
                qryFilter.addParam(name = "name", value = "%" & lCase(variables.name) & "%", cfsqltype = "cf_sql_varchar");
            }
        }
        if(variables.galleryId != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " categoryId IN (SELECT categoryId
                                                                                FROM IcedReaper_gallery_galleryCategory
                                                                               WHERE galleryId = :galleryId) ";
            qryFilter.addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric");
        }
        
        sql &= where & " ORDER BY categoryId ASC";
        
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