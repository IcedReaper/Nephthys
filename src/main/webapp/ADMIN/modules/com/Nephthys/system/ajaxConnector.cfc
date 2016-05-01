component {
    remote struct function getSettings() {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        serverSettings.load();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var settings = duplicate(serverSettings.getAllSettings());
        
        for(var key in settings) {
            if(lcase(settings[key].type) == "datetime") {
                settings[key].value = settings[key].value != null ? formatCtrl.formatDate(settings[key].value, true, "DD.MM.YYYY") : "";
            }
            if(lcase(settings[key].type) == "date") {
                settings[key].value = settings[key].value != null ? formatCtrl.formatDate(settings[key].value, false, "DD.MM.YYYY") : "";
            }
            settings[key].delete("foreignTableOptions");
        }
        
        return settings;
    }
    
    remote boolean function saveSettings(required string settings) {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        var newSettings = deserializeJSON(arguments.settings);
        var resetAllPasswords = false;
        
        for(var key in newSettings) {
            if(key != "encryptionMethodId" || key != "encryptionKey") {
                if(newSettings[key].keyExists("value")) {
                    if(! serverSettings.isKeyReadonly(key)) {
                        serverSettings.setValueOfKey(key, newSettings[key].rawValue);
                    }
                }
            }
        }
        serverSettings.save();
        
        if(newSettings["encryptionMethodId"].value != serverSettings.getValueOfKey("encryptionMethodId")) {
            var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
            
            transaction {
                try {
                    var newAlgorithm = encryptionMethodLoader.getAlgorithm(newSettings["encryptionMethodId"].value);
                    var newSecretKey = generateSecretKey(newAlgorithm);
                    
                    resetPasswordOfAllUsers(newSecretKey,
                                            newAlgorithm,
                                            serverSettings.getValueOfKey("encryptionKey"),
                                            encryptionMethodLoader.getAlgorithm(serverSettings.getValueOfKey("encryptionMethodId")));
                    
                    serverSettings.setValueOfKey("encryptionMethodId", newSettings["encryptionMethodId"].value)
                                  .setValueOfKey("encryptionKey", newSecretKey)
                                  .save();
                    
                    transactionCommit();
                }
                catch(any e) {
                    transactionRollback();
                    throw(object=e);
                }
            }
        }
        
        reloadServerSettings();
        reloadWebsite();
        
        return true;
    }
    
    remote boolean function activate() {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        
        serverSettings.setValueOfKey("active", true)
                      .save();
        
        return true;
    }
    
    remote boolean function deactivate() {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        
        serverSettings.setValueOfKey("active", false)
                      .save();
        
        return true;
    }
    
    remote boolean function activateMaintenanceMode() {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        
        serverSettings.setValueOfKey("maintenanceMode", true)
                      .save();
        
        return true;
    }
    
    remote boolean function deactivateMaintenanceMode() {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        
        serverSettings.setValueOfKey("maintenanceMode", false)
                      .save();
        
        return true;
    }
    
    remote array function getEncryptionMethods() {
        var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.controller.encryptionMethodLoader").init();
        
        return encryptionMethodLoader.getEncryptionMethods();
    }
    
    
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
        };
    }
    
    private boolean function reloadWebsite() {
        var restart = new http().setUrl(application.system.settings.getValueOfKey("wwwDomain") & "?restart")
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
        application.system.settings.load();
    }
    
    private void function resetPasswordOfAllUsers(required string newSecretKey, required string newAlgorithm,
                                                  required string oldSecretKey, required string oldAlgorithm) {
        var userListCtrl = createObject("component", "API.modules.com.Nephthys.user.filter").init();
        
        for(var user in userListCtrl.execute().getResult()) {
            var rawPassword = decrypt(user.getPassword(), arguments.oldSecretKey, arguments.oldAlgorithm);
            user.setPassword(encrypt(rawPassword, arguments.newSecretKey, arguments.newAlgorithm))
                .save();
        }
    }
}