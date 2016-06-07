component {
    public option function init(required numeric optionId, numeric moduleId = 0) {
        variables.optionId = arguments.optionId;
        variables.moduleId = arguments.moduleId;
        
        loadDetails();
        
        return this;
    }
    
    public option function setModuleId(required numeric moduleId) {
        if(variables.optionId == 0 || variables.optionId == null) {
            variables.moduleId = arguments.moduleId;
        }
        
        return this;
    }
    public option function setOptionName(required string optionName) {
        variables.optionName = arguments.optionName;
        
        return this;
    }
    public option function setDescription(required string description) {
        variables.description = arguments.description;
        
        return this;
    }
    public option function setType(required string type) {
        switch(arguments.type) {
            case "text":
            case "boolean":
            case "select":
            case "wysiwyg": {
                variables.type = arguments.type;
                break;
            }
            default: {
                throw(type = "nephthys.application.invalidFormat", message = "Invalid type");
            }
        }
        
        return this;
    }
    public option function setSelectOptions(required any options) {
        if(variables.type == "select") {
            if(isArray(arguments.options)) {
                variables.selectOptions = arguments.options;
            }
            else if(isJSON(arguments.options)) {
                variables.selectOptions = deserializeJSON(arguments.options);
            }
            else {
                throw(type = "nephthys.application.invalidFormat", message = "Select Options are not of type array or are a valid json array string");
            }
        }
        else {
            throw(type = "nephthys.application.invalidResource", message = "Select options are only available for type select.");
        }
        
        return this;
    }
    public option function setSortOrder(required numeric sortOrder) {
        variables.sortOrder = arguments.sortOrder;
        
        return this;
    }
    
    
    public numeric function getOptionId() {
        return variables.optionId;
    }
    public numeric function getModuleId() {
        return variables.moduleId;
    }
    public string function getOptionName() {
        return variables.optionName;
    }
    public string function getDescription() {
        return variables.description;
    }
    public string function getType() {
        return variables.type;
    }
    public array function getSelectOptions() {
        return variables.selectOptions;
    }
    public numeric function getSortOrder() {
        return variables.sortOrder;
    }
    
    
    public option function save() {
        var jsonSelectOptions = variables.selectOptions.len() > 0 ? serializeJSON(variables.selectOptions) : "";
        
        if(variables.moduleId == 0 || variables.moduleId == null) {
            throw(type = "nephthys.application.notAllowed", message = "It is not valid to add an option without a module");
        }
        
        if(variables.optionId != 0 && variables.optionId != null) {
            if(variables.sortOrder == 0) {
                variables.sortOrder = new Query().setSQL("SELECT MAX(sortOrder) + 1 sortOrder
                                                            FROM nephthys_module_option
                                                           WHERE moduleId = :moduleId")
                                                 .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                                                 .execute()
                                                 .getResult()
                                                 .sortOrder[1];
                
                if(variables.sortOrder == 0 || variables.sortOrder == null) {
                    variables.sortOrder = 1;
                }
            }
            
            variables.optionId = new Query().setSQL("INSERT INTO nephthys_module_option
                                                                 (
                                                                     moduleId,
                                                                     optionName,
                                                                     description,
                                                                     type,
                                                                     selectOptions,
                                                                     sortOrder
                                                                 )
                                                          VALUES (
                                                                     :moduleId,
                                                                     :optionName,
                                                                     :description,
                                                                     :type,
                                                                     :selectOptions,
                                                                     :sortOrder
                                                                 );
                                                    SELECT currval('seq_nephthys_module_option_id') newOptionId;")
                                            .addParam(name = "moduleId",      value = variables.moduleId,    cfsqltype = "cf_sql_numeric")
                                            .addParam(name = "optionName",    value = variables.optionName,  cfsqltype = "cf_sql_varchar")
                                            .addParam(name = "description",   value = variables.description, cfsqltype = "cf_sql_varchar")
                                            .addparam(name = "type",          value = variables.type,        cfsqltype = "cf_sql_varchar")
                                            .addParam(name = "selectOptions", value = jsonSelectOptions,     cfsqltype = "cf_sql_varchar", null = jsonSelectOptions == "")
                                            .addParam(name = "sortOrder",     value = variables.sortOrder,   cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult()
                                            .newOptionId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_module_option
                                   SET (
                                           optionName    = :optionName,
                                           description   = :description,
                                           type          = :type,
                                           selectOptions = :selectOptions,
                                           sortOrder     = :sortOrder
                                       )
                                 WHERE optionId = :optionId")
                       .addParam(name = "optionId",      value = variables.optionId,    cfsqltype = "cf_sql_numeric")
                       .addParam(name = "optionName",    value = variables.optionName,  cfsqltype = "cf_sql_varchar")
                       .addParam(name = "description",   value = variables.description, cfsqltype = "cf_sql_varchar")
                       .addparam(name = "type",          value = variables.type,        cfsqltype = "cf_sql_varchar")
                       .addParam(name = "selectOptions", value = jsonSelectOptions,     cfsqltype = "cf_sql_varchar", null = jsonSelectOptions == "")
                       .addParam(name = "sortOrder",     value = variables.sortOrder,   cfsqltype = "cf_sql_numeric")
                       .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_module_option
                                  WHERE optionId = :optionId")
                   .addParam(name = "optionId", value = variables.optionId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    private void function loadDetails() {
        if(variables.optionId != 0 && variables.optionId != null) {
            var qGetOption = new Query().setSQL("SELECT *
                                                   FROM nephthys_module_option
                                                  WHERE optionId = :optionId")
                                        .addParam(name = "optionId", value = variables.optionId, cfsqltype = "cf_sql_numeric")
                                        .execute()
                                        .getResult();
            
            if(qGetOption.getRecordCount() == 1) {
                variables.optionName    = qGetOption.optionName[1];
                variables.description   = qGetOption.description[1];
                variables.type          = qGetOption.type[1].getValue();
                if(variables.type == "query") {
                    variables.selectOptions = getSelectOptionsForQuery(deserializeJSON(qGetOption.selectOptions[1]));
                }
                else {
                    variables.selectOptions = qGetOption.selectOptions[1] != null ? deserializeJSON(qGetOption.selectOptions[1]) : [];
                }
                variables.sortOrder     = qGetOption.sortOrder[1];
            }
            else {
                throw(type = "nephthys.notFound.module", message = "Could not find the option with the ID " & variables.optionId);
            }
        }
        else {
            variables.optionName    = "";
            variables.description   = "";
            variables.type          = "text";
            variables.selectOptions = [];
            variables.sortOrder     = 0;
        }
    }
    
    private array function getSelectOptionsForQuery(required struct queryOptions) {
        var selectOptions = [];
        
        var qSelectOptions = new Query().setSQL("SELECT t." & arguments.queryOptions.idColumn    & " val,
                                                        t." & arguments.queryOptions.labelColumn & " description
                                                   FROM " & arguments.queryOptions.table & " AS t")
                                        .execute()
                                        .getResult();
        
        for(var option in qSelectOptions) {
            selectOptions.append({
                value       = option.val,
                description = option.description
            });
        }
        
        return selectOptions;
    }
}