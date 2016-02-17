component implements="API.interfaces.filter" {
    public filter function init() {
        variables.themeId   = null;
        variables.themeName = null;
        variables.active    = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setThemeId(required numeric themeId) {
        variables.themeId = arguments.themeId;
        return this;
    }
    public filter function setThemeName(required string themeName) {
        variables.themeName = arguments.themeName;
        return this;
    }
    public filter function setActive(required boolean active) {
        variables.active = arguments.active;
        return this;
    }
    
    public filter function execute() {
        var qryFilter = new Query();
        var sql = "SELECT themeId
                     FROM nephthys_theme ";
        
        var where = "";
        if(variables.themeId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "themeId = :themeId";
            qryFilter.addParam(name = "themeId", value = variables.themeId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.themeName != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "lower(name) = :themeName";
            qryFilter.addParam(name = "themeName", value = lCase(variables.themeName), cfsqltype = "cf_sql_varchar");
        }
        if(variables.active != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "active = :active";
            qryFilter.addParam(name = "active", value = variables.active, cfsqltype = "cf_sql_bit");
        }
        
        sql &= where & " ORDER BY name ASC";
        
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
                variables.results.append(new theme(variables.qRes.themeId[i]));
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