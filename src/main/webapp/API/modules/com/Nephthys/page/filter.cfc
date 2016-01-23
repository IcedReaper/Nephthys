component {
    public filter function init() {
        return this;
    }
    
    public array function getList(required numeric parentId = 0, required string region = 'header', required boolean onlyOnline = true) {
        var qPageIds = getPages(arguments.parentId, arguments.region);
        
        var pageArray = [];
        for(var i = 1; i <= qPageIds.getRecordCount(); i++) {
            var page = createObject("component", "API.modules.com.Nephthys.page.page").init(qPageIds.pageId[i]);
            if(arguments.onlyOnline && page.isOnline() || ! arguments.onlyOnline) {
                pageArray.append(page);
            }
        }
        
        return pageArray;
    }
    
    private query function getPages(required numeric parentId, required string region) {
        var sql = "";
        
        if(arguments.parentId == 0) {
            sql = "  SELECT pageId
                       FROM nephthys_page
                      WHERE parentId IS NULL
                        AND region = :region
                   ORDER BY sortOrder ASC";
        }
        else {
            sql = "  SELECT pageId
                       FROM nephthys_page
                      WHERE parentId = :parentId
                        AND region = :region
                   ORDER BY sortOrder ASC";
        }
        
        return new Query().setSQL(sql)
                          .addParam(name = "parentId", value = arguments.parentId, cfsqltype = "cf_sql_numeric")
                          .addParam(name = "region",   value = arguments.region, cfsqltype = "cf_sql_varchar")
                          .execute()
                          .getResult();
    }
}