component {
    // todo refactor to work like a filter component
    public filter function init() {
        return this;
    }
    
    public array function getList() {
        var qModuleIds = new Query().setSQL("  SELECT moduleId
                                                 FROM nephthys_module
                                             ORDER BY sortOrder")
                                    .execute()
                                    .getResult();
        
        var moduleArray = [];
        
        for(var i = 1; i <= qModuleIds.getRecordCount(); i++) {
            moduleArray.append(new module(qModuleIds.moduleId[i]));
        }
        
        return moduleArray;
    }
    
    public numeric function getMaxSortOrder() {
        return new Query().setSQL("SELECT MAX(sortOrder) maxSortOrder
                                     FROM nephthys_module")
                          .execute()
                          .getResult()
                          .maxSortOrder[1];
    }
}