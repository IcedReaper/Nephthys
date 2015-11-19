component {
    remote struct function getDetails() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        return {
            'success' = true,
            'data' = {
                'description'        = serverSettings.getDescription(),
                'active'             = toString(serverSettings.getActiveStatus()),
                'maintenanceMode'    = toString(serverSettings.getMaintenanceModeStatus()),
                'loginOnWebsite'     = toString(serverSettings.getLoginOnWebsite()),
                'imageHotlinking'    = toString(serverSettings.getImageHotlinking()),
                'defaultThemeId'     = toString(serverSettings.getDefaultThemeId()),
                'locale'             = serverSettings.getLocale(),
                'googleAnalyticsId'  = serverSettings.getGoogleAnalyticsId(),
                'setupDate'          = application.tools.formatter.formatDate(serverSettings.getSetupDate()),
                'lastEditDate'       = application.tools.formatter.formatDate(serverSettings.getLastEditDate()),
                'lastEditor'         = getUserInformation(serverSettings.getLastEditor()),
                'encryptionMethodId' = toString(serverSettings.getEncryptionMethodId()),
                'showDumpOnError'    = toString(serverSettings.getShowDumpOnError())
            }
        };
    }
    
    remote struct function save(required string  description,
                                required numeric active,
                                required numeric maintenanceMode,
                                required numeric loginOnWebsite,
                                required numeric imageHotlinking,
                                required numeric defaultThemeId,
                                required string  locale,
                                required string  googleAnalyticsId,
                                required numeric encryptionMethodId,
                                required numeric showDumpOnError) {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setDescription(arguments.description)
                      .setActiveStatus(arguments.active)
                      .setMaintenanceModeStatus(arguments.maintenanceMode)
                      .setLoginOnWebsite(arguments.loginOnWebsite)
                      .setImageHotlinking(arguments.imageHotlinking)
                      .setDefaultThemeId(arguments.defaultThemeId)
                      .setLocale(arguments.locale)
                      .setGoogleAnalyticsId(arguments.googleAnalyticsId)
                      .setLastEditorUserId(request.user.getUserId())
                      .setShowDumpOnError(arguments.showDumpOnError)
                      .save();
        
        if(arguments.encryptionMethodId != serverSettings.getEncryptionMethodId()) {
            var encryptionMethodLoader = createObject("component", "API.com.Nephthys.controller.security.encryptionMethodLoader").init();
            
            transaction {
                try {
                    var newAlgorithm = encryptionMethodLoader.getAlgorithm(arguments.encryptionMethodId);
                    var newSecretKey = generateSecretKey(newAlgorithm);
                    
                    resetPasswordOfAllUsers(newSecretKey,
                                            newAlgorithm,
                                            serverSettings.getEncryptionKey(),
                                            serverSettings.getEncryptionAlgorithm());
                    
                    serverSettings.setEncryptionMethodId(arguments.encryptionMethodId)
                                  .setEncryptionKey(newSecretKey)
                                  .save();
                    
                    transactionCommit();
                }
                catch(any e) {
                    transactionRollback();
                    throw(object=e);
                }
            }
            
            // reload
            application.system.settings.loadDetails();
        }
        
        
        reloadServerSettings();
        
        return {
            'success' = reloadWebsite()
        };
    }
    
    remote struct function activate() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setActiveStatus(1)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setActiveStatus(0)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activateMaintenanceMode() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setMaintenanceModeStatus(1)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivateMaintenanceMode() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setMaintenanceModeStatus(0)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function getEncryptionMethods() {
        var encryptionMethodLoader = createObject("component", "API.com.Nephthys.controller.security.encryptionMethodLoader").init();
        
        return {
            'success' = true,
            'data'    = encryptionMethodLoader.getEncryptionMethods()
        };
    }
    
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
        };
    }
    
    private boolean function reloadWebsite() {
        var restart = new http().setUrl("http://dev.nephthys.com/?restart") // todo: move url to serverSettings
                                .setMethod("GET")
                                .setCharset("utf-8")
                                .addParam(type = "header", name = "x-restart", value = "systemSettings")
                                .send()
                                .getPrefix();
        
        if(restart.status_code != 200 || trim(restart.fileContent) != "restart successful") {
            throw(type = "nephthys.application.reloadFailed", message = trim(restart.fileContent));
        }
        
        return true;
    }
    
    private void function reloadServerSettings() {
        application.system.settings.loadDetails();
    }
    
    private void function resetPasswordOfAllUsers(required string newSecretKey, required string newAlgorithm,
                                                  required string oldSecretKey, required string oldAlgorithm) {
        var userListCtrl = createObject("component", "API.com.Nephthys.controller.user.userList").init();
        
        var userArray = userListCtrl.getList();
        
        for(var i = 1; i <= userArray.len(); i++) {
            var rawPassword = decrypt(userArray[i].getPassword(), arguments.oldSecretKey, arguments.oldAlgorithm);
            userArray[i].setPassword(encrypt(rawPassword, arguments.newSecretKey, arguments.newAlgorithm))
                        .save();
        }
    }
}