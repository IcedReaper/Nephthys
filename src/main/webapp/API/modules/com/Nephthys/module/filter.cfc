component {
    // todo refactor to work like a filter component
    public filter function init() {
        variables.availableWWW = null; // null = all | true | false
        variables.availableADMIN = null; // null = all | true | false
        
        return this;
    }
    
    public filter function setAvailableWWW(required boolean available) {
        variables.availableWWW = arguments.available;
        
        return this;
    }
    
    public filter function setAvailableADMIN(required boolean available) {
        variables.availableADMIN = arguments.available;
        
        return this;
    }
    
    public array function filter() {
        var qryModuleIds = new Query();
        var sql = "  SELECT moduleId
                       FROM nephthys_module ";
        
        var where = "";
        if(variables.availableWWW != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " availableWWW = :availableWWW";
            qryModuleIds.addParam(name="availableWWW", value=variables.availableWWW, cfsqltype="cf_sql_bit");
        }
        if(variables.availableADMIn != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " availableADMIN = :availableADMIN";
            qryModuleIds.addParam(name="availableADMIN", value=variables.availableADMIN, cfsqltype="cf_sql_bit");
        }
        
        sql &= where & " ORDER BY sortOrder";
        
        var qModuleIds = qryModuleIds.setSQL(sql)
                                      .execute()
                                      .getResult();
        
        var moduleArray = [];
        
        for(var i = 1; i <= qModuleIds.getRecordCount(); i++) {
            moduleArray.append(new module(qModuleIds.moduleId[i]));
        }
        
        return moduleArray;
    }
    
    /*
    public numeric function getMaxSortOrder() {
        return new Query().setSQL("SELECT MAX(sortOrder) maxSortOrder
                                     FROM nephthys_module")
                          .execute()
                          .getResult()
                          .maxSortOrder[1];
    }*/
}