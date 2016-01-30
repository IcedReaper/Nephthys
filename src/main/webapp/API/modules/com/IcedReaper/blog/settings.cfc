component extends="API.abstractClasses.settings" {
    public settings function save() {
        transaction {
            try {
                for(var key in variables.settings) {
                    new Query().setSQL("UPDATE IcedReaper_blog_settings SET value = :value WHERE key = :key")
                               .addParam(name = "value", value = convertToSaveFormat(key), cfsqltype = "cf_sql_varchar")
                               .addParam(name = "key",   value = key,                      cfsqltype = "cf_sql_varchar")
                               .execute();
                }
                
                transactionCommit();
            }
            catch(any e) {
                transactionRollback();
                
                throw(object=e);
            }
        }
        
        return this;
    }
    
    public settings function load() {
        var qGetSettings = new Query().setSQL("SELECT *
                                                FROM IcedReaper_blog_settings")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetSettings.getRecordCount(); i++) {
            variables.settings[ qGetSettings.key[i] ] = {
                id                  = qGetSettings.settingId[i],
                description         = qGetSettings.description[i],
                rawValue            = qGetSettings.value[i],
                type                = lCase(qGetSettings.type[i]),
                value               = convertAfterLoad(qGetSettings.value[i], qGetSettings.type[i]),
                systemKey           = false,
                readonly            = false,
                enumOptions         = {},
                hidden              = false,
                foreignTableOptions = [],
                alwaysRevalidate    = true
            };
        }
        
        return this;
    }
}