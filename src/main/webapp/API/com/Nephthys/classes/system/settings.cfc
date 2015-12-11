component extends="API.com.Nephthys.abstractClasses.settings" {
    // @overwrite from abstract class
    public settings function setValueOfKey(required string key, required any value, boolean force = false) {
        if(variables.settings.keyExists(arguments.key)) {
            if(variables.settings[arguments.key].readonly && arguments.force) {
                variables.settings[arguments.key].forced = true;
            }
            
            if(! variables.settings[arguments.key].readonly || (variables.settings[arguments.key].readonly && arguments.force)) {
                variables.settings[arguments.key].value = checkAndValidateValue(arguments.value, variables.settings[arguments.key].type);
            }
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
        
        return this;
    }
    
    public boolean function isKeyReadonly(required string key) {
        if(variables.settings.keyExists(arguments.key)) {
            return variables.settings[arguments.key].readonly;
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public boolean function isKeySystemKey(required string key) {
        if(variables.settings.keyExists(arguments.key)) {
            return variables.settings[arguments.key].systemKey;
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public settings function save() {
        transaction {
            try {
                for(var option in variables.settings) {
                    // update only non readonly or forced settings
                    if(! variables.settings[option].readonly || (variables.settings[option].readonly && variables.settings[option].keyExists("forced"))) {
                        new Query().setSQL("UPDATE nephthys_serverSetting
                                               SET value = :value
                                             WHERE key = :key")
                                   .addParam(name = "value", value = variables.settings[option].value, cfsqltype = "cf_sql_varchar")
                                   .addParam(name = "key",   value = option,                           cfsqltype = "cf_sql_varchar")
                                   .execute();
                    }
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
    
    public void function loadDetails() {
        var qGetSettings = new Query().setSQL("SELECT *
                                                FROM nephthys_serverSetting")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetSettings.getRecordCount(); i++) {
            variables.settings[ qGetSettings.key[i] ] = {
                id          = qGetSettings.serverSettingId[i],
                description = qGetSettings.description[i],
                value       = checkAndValidateValue(qGetSettings.value[i], qGetSettings.type[i]),
                type        = lCase(qGetSettings.type[i]),
                systemKey   = qGetSettings.systemKey[i],
                readonly    = qGetSettings.readonly[i]
            };
        }
    }
}