component {
    public filter function init() {
        variables.key         = "";
        variables.application = null;
        variables.moduleId    = null;
        
        return this;
    }
    
    public filter function setKey(required string key) {
        variables.key = arguments.key;
        return this;
    }
    public filter function setApplication(required string application) {
        variables.application = arguments.application;
        return this;
    }
    public filter function setModuleId(required numeric key) {
        variables.moduleId = arguments.moduleId;
        return this;
    }
    
    public any function getValue() {
        if(variables.key != "") {
            var sql = "";
            var where = "";
            
            var qFilter = new Query();
            sql = "SELECT value
                     FROM nephthys_serverSetting
                    WHERE key = :key";
            
            qFilter.addParam(name = "key", value = variables.key, cfsqltype = "cf_sql_varchar");
            
            if(variables.application != null) {
                where = " AND application = :application ";
                qFilter.addParam(name = "application", value = variables.application, cfsqltype = "cf_sql_varchar");
            }
            else {
                where = " AND application IS NULL ";
            }
            
            if(variables.moduleId != null) {
                where = " AND moduleId = :moduleId ";
                qFilter.addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric");
            }
            
            var res = qFilter.setSQL(sql & where)
                             .execute()
                             .getResult();
            
            if(res.getRecordCount() >= 1) {
                return res.value[1];
            }
        }
        
        return "";
    }
}