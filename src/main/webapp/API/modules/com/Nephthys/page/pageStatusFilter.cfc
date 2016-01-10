component {
    public pageStatusFilter function init() {
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
            pageStatus.append(new pageStatus(qPageStatus.pageStatusId[i]));
        }
        
        return pageStatus;
    }
}