component {
    public settings function init() {
        variables.options = {};
        
        loadOptions();
        
        return this;
    }
    
    public settings function setKey(required string key, required string value) {
        variables.options[arguments.key] = arguments.value;
        
        return this;
    }
    
    public any function getKey(required string key) {
        if(structKeyExists(variables.options, arguments.key)) {
            return variables.options[arguments.key];
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    private void function loadOptions() {
        var qGetOptions = new Query().setSQL("SELECT *
                                                FROM IcedReaper_blog_settings")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qGetOptions.getRecordCount(); i++) {
            if(isNumeric(qGetOptions.value[i])) {
                variables.options[ qGetOptions.key[i] ] = lsParseNumber(qGetOptions.value[i]);
            }
            else {
                switch(qGetOptions.value[i]) {
                    case "true": {
                        variables.options[ qGetOptions.key[i] ] = true;
                        break;
                    }
                    case "false": {
                        variables.options[ qGetOptions.key[i] ] = false;
                        break;
                    }
                    case "null": {
                        variables.options[ qGetOptions.key[i] ] = null;
                        break;
                    }
                    default: {
                        variables.options[ qGetOptions.key[i] ] = qGetOptions.value[i];
                    }
                }
            }
        }
    }
}