component {
    public module function init(required string moduleId) {
        variables.moduleId = arguments.moduleId;
        
        variables.subModulesEdited = false;
        variables.newSubModuleIds = [];
        variables.removedSubModuleIds = [];
        variables.optionsEdited = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public module function setModuleName(required string moduleName) {
        variables.moduleName = arguments.moduleName;
        
        return this;
    }
    public module function setDescription(required string description) {
        variables.description = arguments.description;
        
        return this;
    }
    public module function setActiveStatus(required boolean active) {
        variables.active = arguments.active;
        
        return this;
    }
    public module function setSystemModule(required boolean systemModule) {
        // todo: check if it's install time otherwise throw error. Not every module should be set as system module
        variables.systemModule = arguments.systemModule;
        
        return this;
    }
    public module function setSortOrder(required numeric sortOrder) {
        variables.sortOrder = arguments.sortOrder;
        
        return this;
    }
    public module function setAvailableWWW(required boolean available) {
        variables.availableWWW = arguments.available;
        
        return this;
    }
    public module function setAvailableADMIN(required boolean available) {
        variables.availableADMIN = arguments.available;
        
        return this;
    }
    public module function setCanBeRootElement(required boolean canBeRootElement) {
        variables.canBeRootElement = arguments.canBeRootElement;
        
        return this;
    }
    public module function setCanBeRootElementMultipleTimes(required boolean canBeRootElementMultipleTimes) {
        variables.canBeRootElementMultipleTimes = arguments.canBeRootElementMultipleTimes;
        
        return this;
    }
    public module function addSubModule(required module subModule) {
        if(! variables.keyExists("subModules")) {
            loadSubModules();
        }
        
        var found = false;
        for(var i = 1; i <= variables.subModules.len(); ++i) {
            if(variables.subModules[i].getModuleName() == arguments.subModule.getModuleName()) {
                found = true;
                break;
            }
        }
        
        if(! found) {
            variables.subModules.append(duplicate(arguments.subModule));
            variables.subModulesEdited = true;
            variables.newSubModuleIds.append(arguments.subModule.getModuleId());
        }
        
        return this;
    }
    public module function removeSubModule(required string moduleName) {
        if(! variables.keyExists("subModules")) {
            loadSubModules();
        }
        
        for(var i = 1; i <= variables.subModules.len(); ++i) {
            if(variables.subModules[i].getModuleName() == arguments.moduleName) {
                variables.removedSubModuleIds.append(variables.subModules[i].getModuleId());
                
                variables.subModules.deleteAt(i);
                variables.subModulesEdited = true;
                
                break;
            }
        }
        
        return this;
    }
    public module function addOption(required option newOption) {
        if(! variables.keyExists("options")) {
            loadOptions();
        }
        
        var found = false;
        for(var i = 1; i <= variables.options; ++i) {
            if(variables.options[i].getOptionName() == arguments.newOption.getOptionName()) {
                found = true;
                break;
            }
        }
        
        if(! found) {
            variables.options.append(duplicate(arguments.newOption));
            variables.optionsEdited = true;
        }
        
        return this;
    }
    public module function removeOption(required string optionName) {
        if(! variables.keyExists("options")) {
            loadOptions();
        }
        
        for(var i = 1; i <= variables.options; ++i) {
            if(variables.options[i].getOptionName() == arguments.optionName) {
                variables.options.deleteAt(i);
                variables.optionsEdited = true;
                break;
            }
        }
        
        return this;
    }
    public module function setUseDynamicUrlSuffix(required boolean useDynamicUrlSuffix) {
        variables.useDynamicUrlSuffix = arguments.useDynamicUrlSuffix;
        
        return this;
    }
    
    
    public numeric function getModuleId() {
        return variables.moduleId;
    }
    public string function getModuleName() {
        return variables.moduleName;
    }
    public string function getDescription() {
        return variables.description;
    }
    public boolean function getActiveStatus() {
        return variables.active == 1;
    }
    public boolean function getSystemModule() {
        return variables.systemModule == 1;
    }
    public numeric function getSortOrder() {
        return variables.sortOrder;
    }
    public boolean function getAvailableWWW() {
        return variables.availableWWW == 1;
    }
    public boolean function getAvailableADMIN() {
        return variables.availableADMIN == 1;
    }
    public boolean function getCanBeRootElement() {
        return variables.canBeRootElement == 1;
    }
    public boolean function getCanBeRootElementMultipleTimes() {
        return variables.canBeRootElementMultipleTimes == 1;
    }
    public array function getSubModules() {
        if(! variables.keyExists("subModules")) {
            loadSubModules();
        }
        
        return variables.subModules;
    }
    public array function getOptions() {
        if(! variables.keyExists("options")) {
            loadOptions();
        }
        
        return variables.options;
    }
    public boolean function getUseDynamicUrlSuffix() {
        return variables.useDynamicUrlSuffix == 1;
    }
    
    
    public module function save(required user user) {
        var qSave = new Query().addParam(name = "moduleName",                    value = variables.moduleName,                    cfsqltype = "cf_sql_varchar")
                               .addParam(name = "description",                   value = variables.description,                   cfsqltype = "cf_sql_varchar")
                               .addParam(name = "active",                        value = variables.active,                        cfsqltype = "cf_sql_bit")
                               .addParam(name = "systemModule",                  value = variables.systemModule,                  cfsqltype = "cf_sql_bit")
                               .addparam(name = "sortOrder",                     value = variables.sortOrder,                     cfsqltype = "cf_sql_numeric")
                               .addParam(name = "availableWWW",                  value = variables.availableWWW,                  cfsqltype = "cf_sql_bit")
                               .addParam(name = "availableADMIN",                value = variables.availableADMIN,                cfsqltype = "cf_sql_bit")
                               .addParam(name = "useDynamicUrlSuffix",           value = variables.useDynamicUrlSuffix,           cfsqltype = "cf_sql_bit")
                               .addParam(name = "canBeRootElement",              value = variables.canBeRootElement,              cfsqltype = "cf_sql_bit")
                               .addParam(name = "canBeRootElementMultipleTimes", value = variables.canBeRootElementMultipleTimes, cfsqltype = "cf_sql_bit");
        
        transaction {
            if(variables.moduleId == null) {
                variables.moduleId = new Query().setSQL("INSERT INTO nephthys_module
                                                                     (
                                                                         moduleName,
                                                                         description,
                                                                         active,
                                                                         systemModule,
                                                                         sortOrder,
                                                                         availableWWW,
                                                                         availableADMIN,
                                                                         useDynamicUrlSuffix,
                                                                         canBeRootElement,
                                                                         canBeRootElementMultipleTimes
                                                                     )
                                                              VALUES (
                                                                         :moduleName,
                                                                         :description,
                                                                         :active,
                                                                         :systemModule,
                                                                         :sortOrder,
                                                                         :availableWWW,
                                                                         :availableADMIN,
                                                                         :useDynamicUrlSuffix,
                                                                         :canBeRootElement,
                                                                         :canBeRootElementMultipleTimes
                                                                     );
                                                        SELECT currval('seq_nephthys_module_id') newModuleId;")
                                                .execute()
                                                .getResult()
                                                .newModuleId[1];
            }
            else {
                new Query().setSQL("UPDATE nephthys_module
                                       SET moduleName                    = :moduleName,
                                           description                   = :description,
                                           active                        = :active,
                                           systemModule                  = :systemModule,
                                           sortOrder                     = :sortOrder,
                                           availableWWW                  = :availableWWW,
                                           availableADMIN                = :availableADMIN,
                                           useDynamicUrlSuffix           = :useDynamicUrlSuffix,
                                           canBeRootElement              = :canBeRootElement,
                                           canBeRootElementMultipleTimes = :canBeRootElementMultipleTimes
                                     WHERE moduleId    = :moduleId")
                           .addParam(name = "moduleId",       value = variables.moduleId,       cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            
            if(variables.subModulesEdited) {
                for(var i = 1; i <= variables.newSubModuleIds.len(); ++i) {
                    new Query().setSQL("INSERT INTO nephthys_module_subModule
                                                    (
                                                        moduleId,
                                                        subModuleId
                                                    )
                                             VALUES (
                                                        :moduleId,
                                                        :subModuleId
                                                    )")
                               .addParam(name = "moduleId",    value = variables.moduleId,           cfsqltype = "cf_sql_numeric")
                               .addParam(name = "subModuleId", value = variables.newSubModuleIds[i], cfsqltype = "cf_sql_numeric")
                               .execute();
                }
                
                for(var i = 1; i <= variables.removedSubModuleIds.len(); ++i) {
                    new Query().setSQL("DELETE FROM nephthys_module_subModule
                                              WHERE moduleId    = :moduleId
                                                AND subModuleId = :subModuleId")
                               .addParam(name = "moduleId",    value = variables.moduleId,               cfsqltype = "cf_sql_numeric")
                               .addParam(name = "subModuleId", value = variables.removedSubModuleIds[i], cfsqltype = "cf_sql_numeric")
                               .execute();
                }
                
                variables.subModulesEdited = false;
            }
            
            transactionCommit();
        }
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE
                              FROM nephthys_module
                             WHERE moduleId = :moduleId")
                   .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.moduleId = null;
    }
    
    
    private void function loadDetails() {
        if(variables.moduleId != null) {
            var qModuleDetails = new Query().setSQL("SELECT * 
                                                       FROM nephthys_module
                                                      WHERE moduleId = :moduleId")
                                            .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
        
            if(qModuleDetails.getRecordCount() == 1) {
                variables.moduleName                    = qModuleDetails.moduleName[1];
                variables.description                   = qModuleDetails.description[1];
                variables.active                        = qModuleDetails.active[1];
                variables.systemModule                  = qModuleDetails.systemModule[1];
                variables.sortOrder                     = qModuleDetails.sortOrder[1];
                variables.availableWWW                  = qModuleDetails.availableWWW[1];
                variables.availableADMIN                = qModuleDetails.availableADMIN[1];
                variables.useDynamicUrlSuffix           = qModuleDetails.useDynamicUrlSuffix[1];
                variables.canBeRootElement              = qModuleDetails.canBeRootElement[1];
                variables.canBeRootElementMultipleTimes = qModuleDetails.canBeRootElementMultipleTimes[1];
            }
            else {
                throw(type = "nephthys.notFound.module", message = "Could not find module by ID ", detail = variables.moduleId);
            }
        }
        else {
            variables.moduleName                    = "Neues Modul";
            variables.description                   = "";
            variables.active                        = 0;
            variables.systemModule                  = 0;
            variables.sortOrder                     = 0;
            variables.availableWWW                  = true;
            variables.availableADMIN                = true;
            variables.useDynamicUrlSuffix           = false;
            variables.canBeRootElement              = false;
            variables.canBeRootElementMultipleTimes = false;
        }
    }
    
    private void function loadSubModules() {
        if(variables.moduleId != null) {
            variables.subModules = [];
            
            var qGetSubModules = new Query().setSQL("SELECT subModuleId
                                                       FROM nephthys_module_subModule
                                                      WHERE moduleId = :moduleId")
                                            .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
            
            for(var i = 1; i <= qGetSubModules.getRecordCount(); ++i) {
                variables.subModules.append(new module(qGetSubModules.subModuleId[i]));
            }
        }
        else {
            variables.subModules = [];
        }
    }
    
    private void function loadOptions() {
        if(variables.moduleId != null) {
            variables.options = [];
            
            var qGetOptions = new Query().setSQL("  SELECT optionId
                                                      FROM nephthys_module_option
                                                     WHERE moduleId = :moduleId
                                                  ORDER BY sortOrder ASC")
                                         .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                                         .execute()
                                         .getResult();
            
            for(var i = 1; i <= qGetOptions.getRecordCount(); ++i) {
                variables.options.append(new option(qGetOptions.optionId[i], this));
            }
        }
        else {
            variables.options = [];
        }
    }
}