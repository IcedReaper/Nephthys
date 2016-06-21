component {
    // this class should not be initialized directly!!!
    public settings function init() {
        variables.settings = {};
        
        return this;
    }
    
    public settings function setValueOfKey(required string key, required any value) {
        if(variables.settings.keyExists(arguments.key)) {
            variables.settings[arguments.key].rawValue = convertBeforeSave(arguments.key, arguments.value);
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a setting with the name " & arguments.key);
        }
        
        return this;
    }
    
    public any function getValueOfKey(required string key) {
        if(variables.settings.keyExists(arguments.key)) {
            if(! variables.settings[arguments.key].alwaysRevalidate) {
                return variables.settings[arguments.key].value;
            }
            else {
                return convertAfterLoad(variables.settings[arguments.key].rawValue, variables.settings[arguments.key].type);
            }
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a setting with the name " & arguments.key);
        }
    }
    
    public struct function getKey(required string key) {
        if(variables.settings.keyExists(arguments.key)) {
            return variables.settings[arguments.key];
        }
        else {
            throw(type = "nephthys.notFound.general", message = "Could not find a setting with the name " & arguments.key);
        }
    }
    
    public struct function getAllSettings() {
        return variables.settings;
    }
    
    public struct function getAllSettingsForModuleId(required numeric moduleId) {
        var tmpSettings = {};
        for(var setting in variables.settings) {
            if(variables.settings[setting].moduleId == arguments.moduleId) {
                tmpSettings[setting] = duplicate(variables.settings[setting]);
            }
        }
        return tmpSettings;
    }
    
    public struct function getAllSettingsForModuleName(required string moduleName) {
        var tmpSettings = {};
        for(var setting in variables.settings) {
            if(variables.settings[setting].moduleName == arguments.moduleName) {
                tmpSettings[setting] = duplicate(variables.settings[setting]);
            }
        }
        return tmpSettings;
    }
    
    public string function getValueOfKeyFromForeignTable(required string key) {
        if(variables.settings[ arguments.key ].type == "foreignKey" && isStruct(variables.settings[ arguments.key ].foreignTableOptions)) {
            var ftOptions = variables.settings[ arguments.key ].foreignTableOptions;
            
            return  new Query().setSQL("SELECT " & ftOptions.valueField & " v
                                          FROM " & ftOptions.table & "  
                                         WHERE " & ftOptions.idField & " = :id ")
                               .addParam(name = "id", value = variables.settings[arguments.key].rawValue, cfsqltype = ftOptions.IDType)
                               .execute()
                               .getResult()
                               .v[1];
        }
        else {
            throw(type = "nephthys.application.invalidFormat", message = "The setting behind key " & arguments.key & " is not a foreign key option");
        }
    }
    
    private any function convertAfterLoad(required any value, required string type) {
        switch(lCase(arguments.type)) {
            case "bit": {
                if(arguments.value == 1 || arguments.value == 0 || arguments.value == null) {
                    return arguments.value;
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for type " & arguments.type & " does not match it's type");
                }
            }
            case "number": {
                if(isNumeric(arguments.value) || arguments.value == null) {
                    return lsParseNumber(arguments.value);
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for type " & arguments.type & " does not match it's type");
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
                    throw(type = "nephthys.application.invalidFormat", message = "The value for type " & arguments.type & " does not match it's type");
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
            case "component": {
                return createObject("component", arguments.value).init();
            }
        }
    }
    
    private any function convertBeforeSave(required string key, required any value) {
        switch(lCase(variables.settings[arguments.key].type)) {
            case "bit": {
                if(arguments.value == 1 || arguments.value == 0 || arguments.value == null) {
                    return arguments.value;
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & variables.settings[arguments.key].type & " does not match it's type");
                }
            }
            case "number": {
                if(isNumeric(arguments.value) || arguments.value == null) {
                    return lsParseNumber(arguments.value);
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & variables.settings[arguments.key].type & " does not match it's type");
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
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & variables.settings[arguments.key].type & " does not match it's type");
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
                if(isStruct(variables.settings[arguments.key].foreignTableOptions)) {
                    if(lookupKeyInForeignTable(variables.settings[arguments.key].foreignTableOptions, arguments.value)) {
                        return arguments.value;
                    }
                    else {
                        throw(type = "nephthys.application.invalidFormat", message = "The value for key " & variables.settings[arguments.key].type & " is not within it's foreign table values");
                    }
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The foreign table options are missing");
                }
            }
            case "enum": {
                if(isStruct(variables.settings[arguments.key].enumOptions) && variables.settings[arguments.key].enumOptions.keyExists(arguments.value)) {
                    return arguments.value;
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The value for key " & variables.settings[arguments.key].type & " is not within it's enum definitions");
                }
            }
            case "component": {
                if(! arguments.value.find("/")) {
                    var fileName = replace(arguments.value, ".", "/", "ALL");
                    if(fileExists(expandPath("/" & fileName & ".cfc"))) {
                        try {
                            var cfc = createObject("component", arguments.value).init();
                            
                            return arguments.value;
                        }
                        catch(any e) {
                            throw(type = "nephthys.application.invalidResource", message = "The component is invalid. Please be sure that the component has an init method.");
                        }
                    }
                    else {
                        throw(type = "nephthys.application.invalidResource", message = "The component could not be found. Please be sure that the component is saved here: " & fileName);
                    }
                }
                else {
                    throw(type = "nephthys.application.invalidFormat", message = "The format of the component name is invalid. Please be sure that you separated the foldernames by dot.");
                }
            }
        }
    }
    
    private string function convertToSaveFormat(required string key) {
        switch(lCase(variables.settings[arguments.key].type)) {
            case "date": {
                return dateFormat(variables.settings[arguments.key].rawValue, "YYYY-MM-DD");
            }
            case "datetime": {
                return dateFormat(variables.settings[arguments.key].rawValue, "YYYY-MM-DD") & " " & timeFormat(variables.settings[arguments.key].rawValue, "HH:MM:SS");
            }
            default: {
                return variables.settings[arguments.key].rawValue;
            }
        }
    }
    
    private boolean function lookupKeyInForeignTable(required struct foreignTableOptions, required any value) {
        var ftOptions = arguments.foreignTableOptions;
        
        return new Query().setSQL("SELECT " & ftOptions.idField & " id
                                     FROM " & ftOptions.table & " "
                                            & ftOptions.condition &
                                  "   AND " & ftOptions.idField & " = :value")
                          .addParam(name = "value", value = arguments.value, cfsqltype = ftOptions.idType)
                          .execute()
                          .getResult()
                          .getRecordCount() == 1;
    }
}