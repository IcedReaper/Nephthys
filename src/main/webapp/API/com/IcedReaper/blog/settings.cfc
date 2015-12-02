component {
    public settings function init() {
        variables.options = {};
        
        loadOptions();
        
        return this;
    }
    
    public settings function setValueOfKey(required string key, required string value) {
        if(structKeyExists(variables.options, arguments.key)) {
            variables.options[arguments.key].value = arguments.value;
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
        
        return this;
    }
    
    public any function getValueOfKey(required string key) {
        if(structKeyExists(variables.options, arguments.key)) {
            return variables.options[arguments.key].value;
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public struct function getKey(required string key) {
        if(structKeyExists(variables.options, arguments.key)) {
            return variables.options[arguments.key];
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public settings function save() {
        for(var option in variables.options) {
            new Query().setSQL("UPDATE IcedReaper_blog_settings SET value = :value WHERE key = :key")
                       .addParam(name = "value", value = option.value, cfsqltype = "cf_sql_varchar")
                       .addParam(name = "key",   value = option.key,   cfsqltype = "cf_sql_varchar")
                       .execute();
        }
        
        return this;
    }
    
    private void function loadOptions() {
        var qGetOptions = new Query().setSQL("SELECT *
                                                FROM IcedReaper_blog_settings")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetOptions.getRecordCount(); i++) {
            switch(lCase(qGetOptions.type[i])) {
                case "bit": {
                    if(qGetOptions.value[i] == 1 || qGetOptions.value[i] == 0 || qGetOptions.value[i] == null) {
                        variables.options[ qGetOptions.key[i] ] = {
                            value = qGetOptions.value[i],
                            type  = "bit"
                        };
                    }
                    else {
                        throw(type = "nephthys.application.invalidFormat", message = "The value for key " & qGetOptions.key[i] & " does not math it's type");
                    }
                    
                    break;
                }
                case "number": {
                    if(isNumeric(qGetOptions.value[i]) || qGetOptions.value[i] == null) {
                        variables.options[ qGetOptions.key[i] ] = {
                            value = qGetOptions.value[i],
                            type  = "number"
                        };
                    }
                    else {
                        throw(type = "nephthys.application.invalidFormat", message = "The value for key " & qGetOptions.key[i] & " does not math it's type");
                    }
                    
                    break;
                }
                case "string": {
                    variables.options[ qGetOptions.key[i] ] = {
                        value = toString(qGetOptions.value[i]),
                        type  = "string"
                    };
                    
                    break;
                }
                case "boolean": {
                    if(qGetOptions.value[i] == true || qGetOptions.value[i] == false || qGetOptions.value[i] == null) {
                        variables.options[ qGetOptions.key[i] ] = {
                            value = qGetOptions.value[i],
                            type  = "bit"
                        };
                    }
                    else {
                        throw(type = "nephthys.application.invalidFormat", message = "The value for key " & qGetOptions.key[i] & " does not math it's type");
                    }
                    
                    break;
                }
            }
        }
    }
}