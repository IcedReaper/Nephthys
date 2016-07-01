component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.user.*";
    
    public filter function init() {
        variables.userId = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    
    public filter function execute() {
        if(variables.userId != null) {
            variables.qRes = null;
            variables.results = null;
            
            var qryFilter = new Query();
            var sql = "          SELECT epk.extPropertyKeyId,
                                        ep.extPropertyId,
                                        epk.description,
                                        ep.value,
                                        CASE
                                          WHEN ep.public IS NOT NULL THEN 
                                            ep.public
                                          ELSE 
                                            false
                                          END public
                                   FROM nephthys_user_extPropertyKey epk
                        LEFT OUTER JOIN (SELECT * 
                                           FROM nephthys_user_extProperty extProp
                                          WHERE extProp.userId = :userId) ep ON epk.extPropertyKeyId = ep.extPropertyKeyId";
            
            var where = "";
            
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
            
            sql &= where & " ORDER BY description ASC";
            
            variables.qRes = qryFilter.setSQL(sql)
                                      .execute()
                                      .getResult();
        }
        else {
            throw(type = "nephthys.application.invalidResource", message = "Please specify the userId");
        }
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(isNull(variables.results)) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append({
                    "extPropertyKeyId" = variables.qRes.extPropertyKeyId[i],
                    "extPropertyId"    = variables.qRes.extPropertyId[i],
                    "description"      = variables.qRes.description[i],
                    "value"            = variables.qRes.value[i],
                    "public"           = variables.qRes.public[i]
                });
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