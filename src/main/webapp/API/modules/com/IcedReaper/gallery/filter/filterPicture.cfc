component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.gallery.*";
    
    public filter function init() {
        variables.galleryId = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setGalleryId(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        return this;
    }
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql = "SELECT pictureId
                     FROM IcedReaper_gallery_picture ";
        
        var where = "";
        if(variables.galleryId != null) {
            where &= ((where == "") ? " WHERE " : " AND ") & " galleryId = :galleryId ";
            qryFilter.addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric");
        }
        
        sql &= where & " ORDER BY pictureId ASC";
        
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