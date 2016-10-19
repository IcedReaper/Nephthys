component {
    public boolean function onApplicationStart() {
        application.actualStep = 1;
        application.dbDriver = "";
        
        return true;
    }
    
    public boolean function onRequestStart() {
        // TODO: remove
        if(url.keyExists("step")) {
            application.actualStep = url.step;
        }
        
        if(url.keyExists("proceed") && (url.keyExists("step") && url.step == application.actualStep) && (application.actualStep == 1 || ! form.isEmpty())) {
            request.progressRenderer = new progress.progress();
            
            switch(application.actualStep) {
                case 2: {
                    request.progressRenderer.setTitle("Einrichtung der Datasourcen");
                    request.progressRenderer.setDescription("<h1>Einrichtung der Datasource im ColdFusion Admin</h1>");
                    
                    request.progressRenderer.start();
                    setupDatasources();
                    request.progressRenderer.finish();
                    
                    break;
                }
                case 3: {
                    // Setup tables, functions, etc.
                    
                    setupDatabase();
                    setupEncryptionMethods();
                    setupDefaultTheme();
                    setupDefaultModules();
                    
                    setupErrorTypes();
                    
                    setupServerSettings();
                    
                    break;
                }
                case 4: {
                    setupUserStatus();
                    setupBasicPermissions();
                    setupUserManagerSettings();
                    setupAdminUser();
                    
                    break;
                }
                case 5: {
                    setupPageStatus();
                    setupPageManagerSettings();
                    setupDefaultPages();
                    
                    // TODO: Evaluate: Download extra modules based on page type
                    
                    break;
                }
            }
            
            application.actualStep++;
        }
        
        return true;
    }
    
    // copied from: https://github.com/lucee/Lucee/blob/9eb38f0e565c94cc3c496f455eb94ba7535b5d94/core/src/main/cfml/context/admin/web_functions.cfm
    // copied to get the sql drivers
    private struct function ComponentListPackageAsStruct(string package, cfcNames = structNew("linked")) {
        try {
            var _cfcNames = ComponentListPackage(package);
            loop array="#_cfcNames#" index="i" item="el" {
                arguments.cfcNames[el]=package&"."&el;
            }
        }
        catch(e){}
        return arguments.cfcNames;
    }
    
    // S T E P   3
    private void function setupDatabase() {
        /*
        functions           ✓
        theme               ✓
        userManager         ✓
        module              ✓
        error               ✓
        encryptMethod       ✓
        search              ✓
        pageManager         ✓
        serverSettings      ✓
        */
        var sqlScripts = directoryList(expandPath("/sql/" & application.dbDriver), false, "path", "*.sql", "asc");
        
        for(var sqlScript in sqlScripts) {
            var sqlCommand = fileRead(sqlScript);
            
            new query().setDatasource("nephthys_admin")
                       .setSQL(sqlCommand)
                       .execute();
        }
    }
    
    private void function setupEncryptionMethods() {
        var encryptionMethods = deserializeJSON(fileRead(expandPath("/definitions/encryptionMethods.json")));
        
        for(var encryptionMethod in encryptionMethods) {
            new query().setDatasource("nephthys_admin")
                       .setSQL("INSERT INTO nephthys_encryptionMethod
                                            (
                                                encryptionMethodId,
                                                algorithm
                                            )
                                     VALUES (
                                                :encryptionMethodId,
                                                :algorithm
                                            )")
                       .addParam(name = "encryptionMethodId", value = encryptionMethod.id,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "algorithm",          value = encryptionMethod.algorithm, cfsqltype = "cf_sql_varchar")
                       .execute();
        }
        
        new query().setDatasource("nephthys_admin")
                   .setSQL("ALTER SEQUENCE seq_nephthys_encryptmethod_id RESTART WITH 10;
                            SELECT nextval('seq_nephthys_encryptmethod_id');")
                   .execute();
    }
    
    private void function setupDefaultTheme() {
        var themes = deserializeJSON(fileRead(expandPath("/definitions/themes.json")));
        
        for(var theme in themes) {
            new query().setDatasource("nephthys_admin")
                       .setSQL("INSERT INTO nephthys_theme
                                            (
                                                id,
                                                name,
                                                folderName,
                                                anonymousAvatarFilename,
                                                availableWww,
                                                availableAdmin
                                            )
                                     VALUES (
                                                :id,
                                                :name,
                                                :folderName,
                                                :anonymousAvatarFilename,
                                                :availableWww,
                                                :availableAdmin
                                            )")
                       .addParam(name = "id",                      value = theme.id,                      cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",                    value = theme.name,                    cfsqltype = "cf_sql_varchar")
                       .addParam(name = "folderName",              value = theme.folderName,              cfsqltype = "cf_sql_varchar")
                       .addParam(name = "anonymousAvatarFilename", value = theme.anonymousAvatarFilename, cfsqltype = "cf_sql_varchar")
                       .addParam(name = "availableWww",            value = theme.availableWww,            cfsqltype = "cf_sql_bit")
                       .addParam(name = "availableAdmin",          value = theme.availableAdmin,          cfsqltype = "cf_sql_bit")
                       .execute();
        }
        
        new query().setDatasource("nephthys_admin")
                   .setSQL("ALTER SEQUENCE seq_nephthys_theme_id RESTART WITH 10;
                            SELECT nextval('seq_nephthys_theme_id');")
                   .execute();
    }
    
    private void function setupDefaultModules() {
        var modules = deserializeJSON(fileRead(expandPath("/definitions/modules.json")));
        
        for(var module in modules) {
            new query().setDatasource("nephthys_admin")
                       .setSQL("INSERT INTO nephthys_theme
                                            (
                                                id,
                                                name,
                                                folderName,
                                                anonymousAvatarFilename,
                                                availableWww,
                                                availableAdmin
                                            )
                                     VALUES (
                                                :id,
                                                :name,
                                                :folderName,
                                                :anonymousAvatarFilename,
                                                :availableWww,
                                                :availableAdmin
                                            )")
                       .addParam(name = "id",                      value = theme.id,                      cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",                    value = theme.name,                    cfsqltype = "cf_sql_varchar")
                       .addParam(name = "folderName",              value = theme.folderName,              cfsqltype = "cf_sql_varchar")
                       .addParam(name = "anonymousAvatarFilename", value = theme.anonymousAvatarFilename, cfsqltype = "cf_sql_varchar")
                       .addParam(name = "availableWww",            value = theme.availableWww,            cfsqltype = "cf_sql_bit")
                       .addParam(name = "availableAdmin",          value = theme.availableAdmin,          cfsqltype = "cf_sql_bit")
                       .execute();
        }
        
        new query().setDatasource("nephthys_admin")
                   .setSQL("ALTER SEQUENCE seq_nephthys_module_id RESTART WITH 1000;
                            SELECT nextval('seq_nephthys_module_id');")
                   .execute();
    }
    
    private void function setupErrorTypes() {
        var errorSettings = deserializeJSON(fileRead(expandPath("/definitions/errorSettings.json")));
        
        for(var errorSetting in errorSettings) {
            new query().setDatasource("nephthys_admin")
                       .setSQL("INSERT INTO nephthys_errorSettings
                                            (
                                                errorcode,
                                                errortemplate,
                                                errortype,
                                                log,
                                                availableWww,
                                                availableAdmin
                                            )
                                     VALUES (
                                                :errorcode,
                                                :errortemplate,
                                                :errortype,
                                                :log,
                                                :availableWww,
                                                :availableAdmin
                                            )")
                       .addParam(name = "errorcode",     value = errorSetting.errorcode,     cfsqltype = "cf_sql_varchar")
                       .addParam(name = "errortemplate", value = errorSetting.errortemplate, cfsqltype = "cf_sql_varchar")
                       .addParam(name = "errortype",     value = errorSetting.errortype,     cfsqltype = "cf_sql_varchar")
                       .addParam(name = "log",           value = errorSetting.log,           cfsqltype = "cf_sql_bit")
                       .execute();
        }
        
        new query().setDatasource("nephthys_admin")
                   .setSQL("ALTER SEQUENCE seq_nephthys_errorsettings_id RESTART WITH 100;
                            SELECT nextval('seq_nephthys_errorsettings_id');")
                   .execute();
    }
    
    private void function setupServerSettings() {
        saveSettings(expandPath("/definitions/settings.json"));
    }
    
    // S T E P   4
    private void function setupUserStatus() {
        // read from json
        // update sequence to 10
    }
    
    private void function setupBasicPermissions() {
        // read from json
        // update sequences
    }
    
    private void function setupAdminUser() {
        // use form
    }
    
    private void function setupUserManagerSettings() {
        saveSettings(expandPath("/definitions/userManager/settings.json"));
    }
    
    // S T E P    5
    private void function setupPageStatus() {
        // read from json
        // update sequence to 10
    }
    private void function setupPageManagerSettings() {
        saveSettings(expandPath("/definitions/pageManager/settings.json"));
    }
    private void function setupDefaultPages() {
        // TBD
    }
    
    
    private void function saveSettings(required string filePath) {
        var settings = deserializeJSON(fileRead(arguments.filePath));
        
        for(var setting in settings) {
            var qInsSetting = new query().setDatasource("nephthys_admin")
                                         .setSQL("INSERT INTO nephthys_serverSettings
                                                              (
                                                                  key,
                                                                  value,
                                                                  type,
                                                                  description,
                                                                  systemkey,
                                                                  readonly,
                                                                  enumOptions,
                                                                  foreignTableOptions,
                                                                  hidden,
                                                                  alwaysRevalidate,
                                                                  sortOrder,
                                                                  moduleId,
                                                                  application
                                                              )
                                                       VALUES (
                                                                  :key,
                                                                  :value,
                                                                  :type,
                                                                  :description,
                                                                  :systemkey,
                                                                  :readonly,
                                                                  :enumOptions,
                                                                  :foreignTableOptions,
                                                                  :hidden,
                                                                  :alwaysRevalidate,
                                                                  :sortOrder,
                                                                  :moduleId,
                                                                  :application
                                                              )")
                                         .addParam(name = "key",                 value = setting.key,                 cfsqltype = "cf_sql_varchar")
                                         .addParam(name = "type",                value = setting.type,                cfsqltype = "cf_sql_varchar")
                                         .addParam(name = "description",         value = setting.description,         cfsqltype = "cf_sql_varchar")
                                         .addParam(name = "systemkey",           value = setting.systemkey,           cfsqltype = "cf_sql_bit")
                                         .addParam(name = "readonly",            value = setting.readonly,            cfsqltype = "cf_sql_bit")
                                         .addParam(name = "enumOptions",         value = setting.enumOptions,         cfsqltype = "cf_sql_varchar")
                                         .addParam(name = "foreignTableOptions", value = setting.foreignTableOptions, cfsqltype = "cf_sql_varchar")
                                         .addParam(name = "hidden",              value = setting.hidden,              cfsqltype = "cf_sql_bit")
                                         .addParam(name = "alwaysRevalidate",    value = setting.alwaysRevalidate,    cfsqltype = "cf_sql_bit")
                                         .addParam(name = "sortOrder",           value = setting.sortOrder,           cfsqltype = "cf_sql_varchar")
                                         .addParam(name = "moduleId",            value = setting.moduleId,            cfsqltype = "cf_sql_numeric", null = setting.moduleId == "")
                                         .addParam(name = "application",         value = setting.application,         cfsqltype = "cf_sql_varchar");
            
            switch(setting.value) {
                case "generateDESEDEKey": {
                    qInsSetting.addParam(name = "value", value = GenerateSecretKey("DESEDE"), cfsqltype = "cf_sql_varchar");
                    break;
                }
                case "form": {
                    qInsSetting.addParam(name = "value", value = form["_" & setting.key], cfsqltype = "cf_sql_varchar");
                    break;
                }
                case "now": {
                    var now = now();
                    qInsSetting.addParam(name = "value", value = dateFormat(now, "YYYY-MM-DD") & " " & timeFormat(now, "HH:MM:SS"), cfsqltype = "cf_sql_varchar");
                    break;
                }
                default: {
                    qInsSetting.addParam(name = "value", value = setting.value, cfsqltype = "cf_sql_varchar");
                }
            }
            
            qInsSetting.execute();
        }
    }
}