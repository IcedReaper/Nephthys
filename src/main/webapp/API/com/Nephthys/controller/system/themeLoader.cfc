component {
    public themeLoader function init() {
        return this;
    }
    
    public array function getList(required numeric active = -1) {
        var qryGetTheme = new Query();
        
        var sql = "SELECT themeId
                     FROM nephthys_theme ";
        
        if(arguments.active == 0 || arguments.active == 1) {
            sql &= " WHERE active = :active ";
            qryGetTheme.addParam(name = "active", value = arguments.active, cfsqltype = "cf_sql_bit");
        }
        
        sql &= " ORDER BY name";
        
        var qGetTheme = qryGetTheme.setSQL(sql)
                                   .execute()
                                   .getResult();
        
        var themes = [];
        for(var i = 1; i <= qGetTheme.getRecordCount(); i++) {
            themes.append(createObject("component", "API.com.Nephthys.classes.system.theme").init(qGetTheme.themeId[i]));
        }
        
        return themes;
    }
}