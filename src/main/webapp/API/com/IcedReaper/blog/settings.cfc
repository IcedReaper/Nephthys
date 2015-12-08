component {
    public settings function init() {
        variables.options = {};
        
        loadOptions();
        
        return this;
    }
    
    public settings function setValueOfKey(required string key, required any value) {
        if(variables.options.keyExists(arguments.key)) {
            variables.options[arguments.key].value = checkAndValidateValue(arguments.value, variables.options[arguments.key].type);
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
        
        return this;
    }
    
    public any function getValueOfKey(required string key) {
        if(variables.options.keyExists(arguments.key)) {
            return variables.options[arguments.key].value;
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public struct function getKey(required string key) {
        if(variables.options.keyExists(arguments.key)) {
            return variables.options[arguments.key];
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public struct function getAllSettings() {
        return variables.options;
    }
    
    public settings function save() {
        transaction {
            try {
                for(var option in variables.options) {
                    new Query().setSQL("UPDATE IcedReaper_blog_settings SET value = :value WHERE key = :key")
                               .addParam(name = "value", value = variables.options[option].value, cfsqltype = "cf_sql_varchar")
                               .addParam(name = "key",   value = option,                          cfsqltype = "cf_sql_varchar")
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
    
    private void function loadOptions() {
        var qGetOptions = new Query().setSQL("SELECT *
                                                FROM IcedReaper_blog_settings")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetOptions.getRecordCount(); i++) {
            variables.options[ qGetOptions.key[i] ] = {
                description = qGetOptions.description[i],
                value       = checkAndValidateValue(qGetOptions.value[i], qGetOptions.type[i]),
                type        = lCase(qGetOptions.type[i])
            };
        }
    }
    
    private any function checkAndValidateValue(required any value, required string type) {
        switch(lCase(arguments.type)) {
            case "bit": {
                if(arguments.value == 1 || arguments.value == 0 || arguments.value == null) {
                    return arguments.value;
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & arguments.type & " does not math it's type");
                }
            }
            case "number": {
                if(isNumeric(arguments.value) || arguments.value == null) {
                    return lsParseNumber(arguments.value);
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & arguments.type & " does not math it's type");
                }
            }
            case "string": {
                return toString(arguments.value);
            }
            case "boolean": {
                if(arguments.value == true || arguments.value == false || arguments.value == null) {
                    return arguments.value;
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & arguments.type & " does not math it's type");
                }
            }
        }
    }
}