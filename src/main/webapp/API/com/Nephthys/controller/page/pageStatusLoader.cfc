component {
    public pageStatusLoader function init() {
        return this;
    }
    
    public array function load() {
        var qPageStatus = new Query().setSQL("  SELECT pageStatusId
                                                  FROM nephthys_pageStatus
                                              ORDER BY pageStatusId")
                                     .execute()
                                     .getResult();
        
        var pageStatus = [];
        for(var i = 1; i <= qPageStatus.getRecordCount(); i++) {
            pageStatus.append(createObject("component", "API.com.Nephthys.classes.page.pageStatus").init(qPageStatus.pageStatusId[i]));
        }
        
        return pageStatus;
    }
}