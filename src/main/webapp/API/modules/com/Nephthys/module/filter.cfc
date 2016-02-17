component implements="API.interfaces.filter" {
    public filter function init() {
        variables.availableWWW = null; // null = all | true | false
        variables.availableADMIN = null; // null = all | true | false
        
        variables.parentId = null;
        variables.moduleName = null;
        
        variables.qRes = null;
        variables.results = null;
        
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
    public filter function setParentId(required numeric parentId) {
        variables.parentId = arguments.parentId;
        return this;
    }
    public filter function setModuleName(required string moduleName) {
        variables.moduleName = arguments.moduleName;
        return this;
    }
    
    public filter function execute() {
        var qryFilter = new Query();
        var sql = "  SELECT moduleId
                       FROM nephthys_module ";
        
        var where = "";
        if(variables.availableWWW != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " availableWWW = :availableWWW";
            qryFilter.addParam(name="availableWWW", value=variables.availableWWW, cfsqltype="cf_sql_bit");
        }
        if(variables.availableADMIn != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " availableADMIN = :availableADMIN";
            qryFilter.addParam(name="availableADMIN", value=variables.availableADMIN, cfsqltype="cf_sql_bit");
        }
        if(variables.parentId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " moduleId NOT IN (SELECT subModuleId 
                                                                                FROM nephthys_module_subModule
                                                                               WHERE moduleId = :parentId) ";
            qryFilter.addParam(name="parentId", value=variables.parentId, cfsqltype="cf_sql_numeric");
        }
        if(variables.moduleName != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " moduleName = :moduleName ";
            qryFilter.addParam(name="moduleName", value=variables.moduleName, cfsqltype="cf_sql_varchar");
        }
        
        sql &= where & " ORDER BY sortOrder ASC";
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(variables.results == null) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new module(variables.qRes.moduleId[i]));
            }
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