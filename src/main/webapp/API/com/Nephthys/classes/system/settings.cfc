component {
    public settings function init() {
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    
    public settings function setDescription(required string description) {
        variables.description = arguments.description;
        
        return this;
    }
    public settings function setActiveStatus(required numeric active) {
        variables.active = arguments.active;
        
        return this;
    }
    public settings function setMaintenanceModeStatus(required numeric maintenanceMode) {
        variables.maintenanceMode = arguments.maintenanceMode;
        
        return this;
    }
    public settings function setLoginOnWebsite(required numeric loginOnWebsite) {
        variables.loginOnWebsite = arguments.loginOnWebsite;
        
        return this;
    }
    public settings function setImageHotlinking(required numeric imageHotlinking) {
        variables.imageHotlinking = arguments.imageHotlinking;
        
        return this;
    }
    public settings function setDefaultThemeId(required numeric defaultThemeId) {
        variables.defaultThemeId = arguments.defaultThemeId;
        
        return this;
    }
    public settings function setLocale(required string locale) {
        variables.locale = arguments.locale;
        
        return this;
    }
    public settings function setGoogleAnalyticsId(required string googleAnalyticsId) {
        variables.googleAnalyticsId = arguments.googleAnalyticsId;
        
        return this;
    }
    public settings function setLastEditorUserId(required numeric lastEditorUserId) {
        variables.lastEditorUserId = arguments.lastEditorUserId;
        
        return this;
    }
    public settings function setEncryptionKey(required string encryptionKey) {
        // todo: check if it's the installation
        variables.encryptionKey = arguments.encryptionKey;
        
        return this;
    }
    public settings function setEncryptionMethodId(required string encryptionMethodId) {
        // todo: check if it's the installation
        variables.encryptionMethodId = arguments.encryptionMethodId;
        
        return this;
    }
    public settings function setShowDumpOnError(required numeric showDumpOnError) {
        variables.showDumpOnError = arguments.showDumpOnError;
        
        return this;
    }
    
    // G E T T E R
    
    public string function getDescription() {
        return variables.description;
    }
    public numeric function getActiveStatus() {
        return variables.active;
    }
    public numeric function getMaintenanceModeStatus() {
        return variables.maintenanceMode;
    }
    public numeric function getLoginOnWebsite() {
        return variables.loginOnWebsite;
    }
    public numeric function getImageHotlinking() {
        return variables.imageHotlinking;
    }
    public numeric function getDefaultThemeId() {
        return variables.defaultThemeId;
    }
    public string function getLocale() {
        return variables.locale;
    }
    public string function getGoogleAnalyticsId() {
        return variables.googleAnalyticsId;
    }
    public date function getSetupDate() {
        return variables.setupDate;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    public numeric function getLastEditorUserId() {
        return variables.lastEditorUserId;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    public string function getEncryptionKey() {
        return variables.encryptionKey;
    }
    public string function getEncryptionAlgorithm() {
        return variables.encryptionAlgorithm;
    }
    public numeric function getEncryptionMethodId() {
        return variables.encryptionMethodId;
    }
    public string function getNephthysVersion() {
        return variables.nephthysVersion;
    }
    public numeric function getShowDumpOnError() {
        return variables.showDumpOnError;
    }
    
    public theme function getTheme() {
        return variables.theme;
    }
    
    // C R U D
    
    public settings function save() {
        new Query().setSQL("UPDATE nephthys_serverSettings
                               SET description        = :description,
                                   active             = :active,
                                   maintenanceMode    = :maintenanceMode,
                                   loginOnWebsite     = :loginOnWebsite,
                                   imageHotlinking    = :imageHotlinking,
                                   defaultThemeId     = :defaultThemeId,
                                   locale             = :locale,
                                   googleAnalyticsId  = :googleAnalyticsId,
                                   lastEditDate       = now(),
                                   lastEditorUserId   = :lastEditorUserId,
                                   encryptionMethodId = :encryptionMethodId,
                                   encryptionKey      = :encryptionKey,
                                   showDumpOnError    = :showDumpOnError")
                   .addParam(name = "description",        value = variables.description,        cfsqltype = "cf_sql_varchar")
                   .addParam(name = "active",             value = variables.active,             cfsqltype = "cf_sql_bit")
                   .addParam(name = "maintenanceMode",    value = variables.maintenanceMode,    cfsqltype = "cf_sql_bit")
                   .addParam(name = "loginOnWebsite",     value = variables.loginOnWebsite,     cfsqltype = "cf_sql_bit")
                   .addParam(name = "imageHotlinking",    value = variables.imageHotlinking,    cfsqltype = "cf_sql_bit")
                   .addParam(name = "defaultThemeId",     value = variables.defaultThemeId,     cfsqltype = "cf_sql_numeric")
                   .addParam(name = "locale",             value = variables.locale,             cfsqltype = "cf_sql_varchar")
                   .addParam(name = "googleAnalyticsId",  value = variables.googleAnalyticsId,  cfsqltype = "cf_sql_varchar", null = variables.googleAnalyticsId == "")
                   .addParam(name = "lastEditorUserId",   value = variables.lastEditorUserId,   cfsqltype = "cf_sql_numeric")
                   .addParam(name = "encryptionMethodId", value = variables.encryptionMethodId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "encryptionKey",      value = variables.encryptionKey,      cfsqltype = "cf_sql_varchar")
                   .addParam(name = "showDumpOnError",    value = variables.showDumpOnError,    cfsqltype = "cf_sql_bit")
                   .execute();
        
        return this;
    }
    
    // I N T E R N A L
    
    public void function loadDetails() {
        var qSettings = new Query().setSQL("SELECT ss.*,
                                                   em.algorithm
                                              FROM nephthys_serverSettings ss
                                            INNER JOIN nephthys_encryptionMethod em ON ss.encryptionMethodId = em.encryptionMethodId")
                                   .execute()
                                   .getResult();
        
        if(qSettings.getRecordCount() == 1) {
            variables.description         = qSettings.description[1];
            variables.active              = qSettings.active[1];
            variables.maintenanceMode     = qSettings.maintenanceMode[1];
            variables.loginOnWebsite      = qSettings.loginOnWebsite[1];
            variables.imageHotlinking     = qSettings.imageHotlinking[1];
            variables.defaultThemeId      = qSettings.defaultThemeId[1];
            variables.locale              = qSettings.locale[1];
            variables.googleAnalyticsId   = qSettings.googleAnalyticsId[1];
            variables.setupDate           = qSettings.setupDate[1];
            variables.lastEditDate        = qSettings.lastEditDate[1];
            variables.lastEditorUserId    = qSettings.lastEditorUserId[1];
            variables.nephthysVersion     = qSettings.nephthysVersion[1];
            variables.encryptionKey       = qSettings.encryptionKey[1];
            variables.encryptionAlgorithm = qSettings.algorithm[1];
            variables.encryptionMethodId  = qSettings.encryptionMethodId[1];
            variables.showDumpOnError     = qSettings.showDumpOnError[1];
            
            variables.lastEditor = createObject("component", "API.com.Nephthys.classes.user.user").init(variables.lastEditorUserId);
            variables.theme      = createObject("component", "API.com.Nephthys.classes.system.theme").init(variables.defaultThemeId);
        }
        else {
            throw(type = "nephthys.critical.installation", message = "Could not read server settings. Please validate the installation or use the repair mechanism");
        }
    }
}