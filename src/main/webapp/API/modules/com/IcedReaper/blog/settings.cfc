component extends="API.abstractClasses.settings" {
    public settings function save() {
        transaction {
            try {
                for(var option in variables.settings) {
                    new Query().setSQL("UPDATE IcedReaper_blog_settings SET value = :value WHERE key = :key")
                               .addParam(name = "value", value = variables.settings[option].value, cfsqltype = "cf_sql_varchar")
                               .addParam(name = "key",   value = option,                           cfsqltype = "cf_sql_varchar")
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
    
    private void function loadDetails() {
        var qGetOptions = new Query().setSQL("SELECT *
                                                FROM IcedReaper_blog_settings")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetOptions.getRecordCount(); i++) {
            variables.settings[ qGetOptions.key[i] ] = {
                description = qGetOptions.description[i],
                value       = convertAfterLoad(qGetOptions.value[i], qGetOptions.type[i]),
                type        = lCase(qGetOptions.type[i])
            };
        }
    }
}