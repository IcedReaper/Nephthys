component {
    public categoryLoader function init() {
        variables.categoryId = 0;
        variables.name       = "";
        variables.blogpostId  = 0;
        variables.useExactName  = false;
        
        return this;
    }
    
    public categoryLoader function setCategoryId(required numeric categoryId) {
        variables.categoryId = arguments.categoryId;
        
        return this;
    }
    
    public categoryLoader function setName(required string name) {
        variables.name = arguments.name;
        
        return this;
    }
    
    public categoryLoader function setUseExactName(required boolean useExactName) {
        variables.useExactName = arguments.useExactName;
        
        return this;
    }
    
    public categoryLoader function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        return this;
    }
    
    
    public array function load() {
        var qryGetCategories = new Query();
        
        var sql = "SELECT categoryId FROM IcedReaper_blog_category ";
        
        var where = "";
        if(variables.categoryId != 0) {
            where &= ((where == "") ? " WHERE " : "AND") & "categoryId = :categoryId ";
            qryGetCategories.addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.name != "") {
            if(variables.useExactName) {
                where &= ((where == "") ? " WHERE " : "AND") & "name = :name ";
                qryGetCategories.addParam(name = "name", value = variables.name, cfsqltype = "cf_sql_varchar");
            }
            else {
                where &= ((where == "") ? " WHERE " : "AND") & " lower(name) LIKE :name ";
                qryGetCategories.addParam(name = "name", value = "%" & lCase(variables.name) & "%", cfsqltype = "cf_sql_varchar");
            }
        }
        if(variables.blogpostId != 0) {
            where &= ((where == "") ? " WHERE " : "AND") & "categoryId IN (SELECT categoryId FROM IcedReaper_blog_blogCategory WHERE blogpostId = :blogpostId) ";
            qryGetCategories.addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric");
        }
        
        sql &= where & " ORDER BY categoryId ASC";
        
        var qCategories = qryGetCategories.setSQL(sql)
                                          .execute()
                                          .getResult();
        
        var categories = [];
        for(var c = 1; c <= qCategories.getRecordCount(); c++) {
            categories.append(new category(qCategories.categoryId[c]));
        }
        
        return categories;
    }
}