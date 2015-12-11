component {
    // this class should not be initialized directly!!!
    public settings function init() {
        variables.settings = {};
        
        loadDetails();
        
        return this;
    }
    
    public settings function setValueOfKey(required string key, required any value) {
        if(variables.settings.keyExists(arguments.key)) {
            variables.settings[arguments.key].value = convertBeforeSave(arguments.value, variables.settings[arguments.key].type);
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
        
        return this;
    }
    
    public any function getValueOfKey(required string key) {
        if(variables.settings.keyExists(arguments.key)) {
            return variables.settings[arguments.key].value;
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public struct function getKey(required string key) {
        if(variables.settings.keyExists(arguments.key)) {
            return variables.settings[arguments.key];
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a blog setting with the name " & arguments.key);
        }
    }
    
    public struct function getAllSettings() {
        return variables.settings;
    }
    
    private any function convertAfterLoad(required any value, required string type) {
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
            case "date": {
                if(arguments.value == "" || arguments.value == null) {
                    return null;
                }
                else {
                    var year   = mid(arguments.value,  1, 4);
                    var month  = mid(arguments.value,  6, 2);
                    var day    = mid(arguments.value,  9, 2);
                    
                    return createDate(year, month, day, hour);
                }
            }
            case "datetime": {
                if(arguments.value == "" || arguments.value == null) {
                    return null;
                }
                else {
                    var year   = mid(arguments.value,  1, 4);
                    var month  = mid(arguments.value,  6, 2);
                    var day    = mid(arguments.value,  9, 2);
                    var hour   = mid(arguments.value, 12, 2);
                    var minute = mid(arguments.value, 15, 2);
                    var second = mid(arguments.value, 18, 2);
                    
                    var timecorrection = mid(arguments.value, 20, 3);
                    
                    return createDatetime(year, month, day, hour, minute, second);
                }
            }
            case "foreignKey": {
                return arguments.value;
            }
            case "enum": {
                return arguments.value;
            }
        }
    }
    
    private any function convertBeforeSave(required any value, required string type) {
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
            case "date": {
                if(arguments.value == "" || arguments.value == null) {
                    return null;
                }
                else {
                    if(isDate(arguments.value)) {
                        return arguments.value;
                    }
                    else {
                        return mid(arguments.value, 7, 4) & "-" & mid(arguments.value, 4, 2) & "-" & mid(arguments.value, 1, 2);
                    }
                }
            }
            case "datetime": {
                if(arguments.value == "" || arguments.value == null) {
                    return null;
                }
                else {
                    if(isDate(arguments.value)) {
                        return arguments.value;
                    }
                    else {
                        var dt = mid(arguments.value, 7, 4) & "-" & mid(arguments.value, 4, 2) & "-" & mid(arguments.value, 1, 2);
                        return dt & " " & mid(arguments.value, 12, 8);
                    }
                }
            }
            case "foreignKey": {
                // implement checks if value is ok
                return arguments.value;
            }
            case "enum": {
                // implement checks if value is ok
                return arguments.value;
            }
        }
    }
    
    private string function convertToSaveFormat(required string key) {
        switch(lCase(variables.settings[arguments.key].type)) {
            case "date": {
                return dateFormat(variables.settings[arguments.key].value, "YYYY-MM-DD");
            }
            case "datetime": {
                return dateFormat(variables.settings[arguments.key].value, "YYYY-MM-DD") & " " & timeFormat(variables.settings[arguments.key].value, "HH:MM:SS");
            }
            default: {
                return variables.settings[arguments.key].value;
            }
        }
    }
}