component {
    public module function init(required string moduleId) {
        variables.moduleId = arguments.moduleId;
        
        variables.subModulesEdited = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public module function setModuleId(required numeric moduleId) {
        variables.moduleId = arguments.moduleId;
        
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
    public module function addSubModule(required module subModule) {
        var found = false;
        for(var i = 1; i <= variables.subModules.len(); ++i) {
            if(variables.subModules[i].getModuleName() == arguments.moduleName) {
                found = true;
                break;
            }
        }
        
        if(! found) {
            variables.getSubModules().append(duplicate(arguments.subModule));
            variables.subModulesEdited = true;
        }
        
        return this;
    }
    public module function removeSubModule(required string moduleName) {
        for(var i = 1; i <= variables.subModules.len(); ++i) {
            if(variables.subModules[i].getModuleName() == arguments.moduleName) {
                variables.subModules.deleteAt(i);
                variables.subModulesEdited = true;
                
                break;
            }
        }
        
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
        return variables.active;
    }
    public boolean function getSystemModule() {
        return variables.systemModule;
    }
    public numeric function getSortOrder() {
        return variables.sortOrder;
    }
    public boolean function getAvailableWWW() {
        return variables.availableWWW;
    }
    public boolean function getAvailableADMIN() {
        return variables.availableADMIN;
    }
    public array function getSubModules() {
        if(! variables.keyExists("subModules")) {
            loadSubModules();
        }
        
        return variables.subModules;
    }
    
    
    public module function save() {
        transaction {
            if(variables.moduleId == 0) {
                variables.moduleId = new Query().setSQL("INSERT INTO nephthys_module
                                                                     (
                                                                         moduleName,
                                                                         description,
                                                                         active,
                                                                         systemModule,
                                                                         sortOrder,
                                                                         availableWWW,
                                                                         availableADMIN
                                                                     )
                                                              VALUES (
                                                                         :moduleName,
                                                                         :description,
                                                                         :active,
                                                                         :systemModule,
                                                                         :sortOrder,
                                                                         :availableWWW,
                                                                         :availableADMIN
                                                                     );
                                                        SELECT currval('seq_nephthys_module_id' :: regclass) newModuleId;") // spaces around :: are required because of parameter handling
                                                .addParam(name = "moduleName",     value = variables.moduleName,     cfsqltype = "cf_sql_varchar")
                                                .addParam(name = "description",    value = variables.description,    cfsqltype = "cf_sql_varchar")
                                                .addParam(name = "active",         value = variables.active,         cfsqltype = "cf_sql_bit")
                                                .addParam(name = "systemModule",   value = variables.systemModule,   cfsqltype = "cf_sql_bit")
                                                .addparam(name = "sortOrder",      value = variables.sortOrder,      cfsqltype = "cf_sql_numeric")
                                                .addParam(name = "availableWWW",   value = variables.availableWWW,   cfsqltype = "cf_sql_bit")
                                                .addParam(name = "availableADMIN", value = variables.availableADMIN, cfsqltype = "cf_sql_bit")
                                                .execute()
                                                .getResult()
                                                .newModuleId[1];
            }
            else {
                new Query().setSQL("UPDATE nephthys_module
                                       SET moduleName     = :moduleName,
                                           description    = :description,
                                           active         = :active,
                                           systemModule   = :systemModule,
                                           sortOrder      = :sortOrder,
                                           availableWWW   = :availableWWW,
                                           availableADMIN = :availableADMIN
                                     WHERE moduleId    = :moduleId")
                           .addParam(name = "moduleId",       value = variables.moduleId,       cfsqltype = "cf_sql_numeric")
                           .addParam(name = "moduleName",     value = variables.moduleName,     cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",    value = variables.description,    cfsqltype = "cf_sql_varchar")
                           .addParam(name = "active",         value = variables.active,         cfsqltype = "cf_sql_bit")
                           .addParam(name = "systemModule",   value = variables.systemModule,   cfsqltype = "cf_sql_bit")
                           .addparam(name = "sortOrder",      value = variables.sortOrder,      cfsqltype = "cf_sql_numeric")
                           .addParam(name = "availableWWW",   value = variables.availableWWW,   cfsqltype = "cf_sql_bit")
                           .addParam(name = "availableADMIN", value = variables.availableADMIN, cfsqltype = "cf_sql_bit")
                           .execute();
            }
            
            if(variables.subModulesEdited) {
                for(var i = 1; i <= variables.subModules.len(); ++i) {
                    try {
                        new Query().setSQL("INSERT INTO nephthys_module_subModule
                                                        (
                                                            moduleId,
                                                            subModuleId
                                                        )
                                                 VALUES (
                                                            :moduleId,
                                                            :subModuleId
                                                        )")
                                   .addParam(name = "moduleId",    value = variables.moduleId,                    cfsqltype = "cf_sql_numeric")
                                   .addParam(name = "subModuleId", value = variables.subModules[i].getModuleId(), cfsqltype = "cf_sql_numeric")
                                   .execute();
                    }
                    catch(database db) {
                        // todo: check if error != duplicate key
                    }
                }
                
                variables.subModulesEdited = false;
            }
            
            transactionCommit();
        }
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE
                              FROM nephthys_module
                             WHERE moduleId = :moduleId")
                   .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    private void function loadDetails() {
        if(variables.moduleId != 0 && variables.moduleId != null) {
            var qModuleDetails = new Query().setSQL("SELECT * 
                                                       FROM nephthys_module
                                                      WHERE moduleId = :moduleId")
                                            .addParam(name = "moduleId", value = variables.moduleId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
        
            if(qModuleDetails.getRecordCount() == 1) {
                variables.moduleName     = qModuleDetails.moduleName[1];
                variables.description    = qModuleDetails.description[1];
                variables.active         = qModuleDetails.active[1];
                variables.systemModule   = qModuleDetails.systemModule[1];
                variables.sortOrder      = qModuleDetails.sortOrder[1];
                variables.availableWWW   = qModuleDetails.availableWWW[1];
                variables.availableADMIN = qModuleDetails.availableADMIN[1];
            }
            else {
                throw(type = "nephthys.notFound.module", message = "Could not find module by ID ", detail = variables.moduleId);
            }
        }
        else {
            variables.moduleName     = "Neues Modul";
            variables.description    = "";
            variables.active         = 0;
            variables.systemModule   = 0;
            variables.sortOrder      = 0;
            variables.availableWWW   = true;
            variables.availableADMIN = true;
        }
    }
    
    private void function loadSubModules() {
        if(variables.moduleId != 0 && variables.moduleId != null) {
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
}