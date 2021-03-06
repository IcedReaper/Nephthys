component interface="APi.interfaces.validator" {
    public validator function init() {
        variables.rules = {};
        load();
        
        return this;
    }
    
    public validator function load() {
        if(! application.keyExists("system") || ! application.system.keyExists("settings")) {
            throw(type = "nephthys.critical.installation", message = "Error! application.system.settings is undefined!");
        }
        
        var validationRules = fileRead(expandPath(application.system.settings.getValueOfKey("validationRuleFile")));
        
        if(isJSON(validationRules)) {
            variables.rules = deserializeJSON(validationRules);
        }
        else {
            throw(type = "nephthys.application.invalidFormat", message = "The validation rules are not in a valid JSON format");
        }
        
        return this;
    }
    
    public boolean function validate(required string data, required string ruleName, string country = "", string language = "", string locale = "", boolean mandatory = true) {
        if(arguments.data == "") {
            if(! arguments.mandatory) {
                return true;
            }
            else {
                return false;
            }
        }
        
        if(variables.rules.keyExists(arguments.ruleName)) {
            if(arguments.country != "" && arguments.language != "") {
                arguments.locale = arguments.language & "-" & arguments.country;
            }
            
            
            if(arguments.locale != "") {
                if(variables.rules[arguments.ruleName].keyExists("byLocale")) {
                    if(variables.rules[arguments.ruleName].byLocale.keyExists(arguments.locale)) {
                        return doValidation(arguments.data, variables.rules[arguments.ruleName].byLocale[arguments.locale].rule);
                    }
                    else {
                        throw(type = "nephthys.notFound.validation", message = "Locale of validation rule not found", detail = arguments.locale);
                    }
                }
                else {
                    throw(type = "nephthys.notFound.validation", message = "The validation rule is not set up for validation by locale", detail = arguments.ruleName);
                }
            }
            else if(arguments.country != "") {
                if(variables.rules[arguments.ruleName].keyExists("byCountry")) {
                    if(variables.rules[arguments.ruleName].byCountry.keyExists(arguments.country)) {
                        return doValidation(arguments.data, variables.rules[arguments.ruleName].byCountry[arguments.country].rule);
                    }
                    else {
                        throw(type = "nephthys.notFound.validation", message = "Country of validation rule not found", detail = arguments.country);
                    }
                }
                else {
                    throw(type = "nephthys.notFound.validation", message = "The validation rule is not set up for validation by country", detail = arguments.ruleName);
                }
            }
            else if(arguments.language != "") {
                if(variables.rules[arguments.ruleName].keyExists("byLanguage")) {
                    if(variables.rules[arguments.ruleName].byLanguage.keyExists(arguments.language)) {
                        return doValidation(arguments.data, variables.rules[arguments.ruleName].byLanguage[arguments.language].rule);
                    }
                    else {
                        throw(type = "nephthys.notFound.validation", message = "Language of validation rule not found", detail = arguments.language);
                    }
                }
                else {
                    throw(type = "nephthys.notFound.validation", message = "The validation rule is not set up for validation by language", detail = arguments.ruleName);
                }
            }
            else {
                if(variables.rules[arguments.ruleName].keyExists("rule")) {
                    return doValidation(arguments.data, variables.rules[arguments.ruleName].rule);
                }
                else {
                    throw(type = "nephthys.notFound.validation", message = "The validation rule is not set up for simple validation", detail = arguments.ruleName);
                }
            }
        }
        else {
            throw(type = "nephthys.notFound.validation", message = "Validation rule not found", detail = arguments.ruleName);
        }
    }
    
    private boolean function doValidation(required any data, required string rule) {
        return (javaCast('string', arguments.data).replaceAll(arguments.rule, "") == "");
    }
}