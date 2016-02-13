component {
    public module function init(required string moduleId) {
        variables.moduleId = arguments.moduleId;
        
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
    
    
    public module function save() {
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
}