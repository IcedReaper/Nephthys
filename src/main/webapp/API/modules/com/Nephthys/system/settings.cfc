component extends="API.abstractClasses.settings" {
    // @overwrite from abstract class
    public settings function setValueOfKey(required string key, required any value, boolean force = false) {
        if(variables.settings.keyExists(arguments.key)) {
            if(variables.settings[arguments.key].readonly && arguments.force) {
                variables.settings[arguments.key].forced = true;
            }
            
            if(! variables.settings[arguments.key].readonly || (variables.settings[arguments.key].readonly && arguments.force)) {
                variables.settings[arguments.key].rawValue = convertBeforeSave(arguments.key, arguments.value);
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
                for(var key in variables.settings) {
                    // update only non readonly or forced settings
                    if(! variables.settings[key].readonly || (variables.settings[key].readonly && variables.settings[key].keyExists("forced"))) {
                        new Query().setSQL("UPDATE nephthys_serverSetting
                                               SET value = :value
                                             WHERE key = :key")
                                   .addParam(name = "value", value = convertToSaveFormat(key), cfsqltype = "cf_sql_varchar")
                                   .addParam(name = "key",   value = key,                      cfsqltype = "cf_sql_varchar")
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
        
        load();
        
        return this;
    }
    
    public settings function load() {
        var qGetSettings = new Query().setSQL("  SELECT *
                                                   FROM nephthys_serverSetting
                                               ORDER BY sortOrder ASC")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetSettings.getRecordCount(); i++) {
            variables.settings[ qGetSettings.key[i] ] = {
                id                  = qGetSettings.serverSettingId[i],
                description         = qGetSettings.description[i],
                rawValue            = qGetSettings.value[i],
                type                = lCase(qGetSettings.type[i]),
                systemKey           = qGetSettings.systemKey[i],
                readonly            = qGetSettings.readonly[i],
                enumOptions         = deserializeJSON(qGetSettings.enumOptions[i]),
                hidden              = qGetSettings.hidden[i],
                foreignTableOptions = deserializeJSON(qGetSettings.foreignTableOptions[i]),
                alwaysRevalidate    = qGetSettings.alwaysRevalidate[i]
            };
            
            variables.settings[ qGetSettings.key[i] ].value = convertAfterLoad(qGetSettings.value[i], qGetSettings.type[i]);
            
            if(isStruct(variables.settings[ qGetSettings.key[i] ].foreignTableOptions)) {
                loadForeignTableOptions(qGetSettings.key[i]);
            }
        }
        return this;
    }
    
    private void function loadForeignTableOptions(required string key) {
        var ftOptions = variables.settings[ arguments.key ].foreignTableOptions;
        
        var qOptions = new Query().setSQL("SELECT " & ftOptions.idField & " id, " & ftOptions.valueField & " v 
                                             FROM " & ftOptions.table & " " & 
                                                  ftOptions.condition & " " & 
                                                  ftOptions.orderBy)
                                  .execute()
                                  .getResult();
        
        variables.settings[ arguments.key ].enumOptions = {};
        for(var i = 1; i <= qOptions.getRecordCount(); i++) {
            variables.settings[ arguments.key ].enumOptions[qOptions.id[i]] = qOptions.v[i];
        }
    }
}