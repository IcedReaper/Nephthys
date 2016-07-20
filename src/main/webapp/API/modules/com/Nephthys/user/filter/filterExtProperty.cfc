component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.user.*";
    
    public filter function init() {
        variables.userId = null;
        
        variables.extPropertyKeyId = null;
        
        variables.public = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public filter function setExtPropertyKeyId(required numeric extPropertyKeyId) {
        variables.extPropertyKeyId = arguments.extPropertyKeyId;
        return this;
    }
    public filter function setPublic(required boolean public) {
        variables.public = arguments.public;
        return this;
    }
    
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "    SELECT ep.extPropertyId
                         FROM nephthys_user_extProperty ep
                   INNER JOIN nephthys_user_extPropertyKey epk ON ep.extPropertyKeyId = epk.extPropertyKeyId";
        var where = "";
        var sortBy = " ORDER BY epk.sortOrder ASC";
        
        if(variables.userId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " ep.userId = :userId";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.extPropertyKeyId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " ep.extPropertyKeyId = :extPropertyKeyId";
            qryFilter.addParam(name = "extPropertyKeyId", value = variables.extPropertyKeyId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.public != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " ep.public = :public";
            qryFilter.addParam(name = "public", value = variables.public, cfsqltype = "cf_sql_bit");
        }
        
        sql &= where & sortBy;
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(isNull(variables.results)) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new extProperty(variables.qRes.extPropertyId[i]));
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