component {
    remote struct function getSettings() {
        var settings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        return {
            "success" = true,
            "data"    = settings.getAllSettings()
        };
    }
    
    remote struct function saveSettings(required string settings) {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        var newSettings = deserializeJSON(arguments.settings);
        var resetAllPasswords = false;
        
        for(var key in newSettings) {
            if(key != "encryptionMethodId" || key != "encryptionKey") {
                if(newSettings[key].keyExists("value")) {
                    if(! serverSettings.isKeyReadonly(key)) {
                        serverSettings.setValueOfKey(key, newSettings[key].value);
                    }
                }
            }
        }
        serverSettings.save();
        
        if(newSettings["encryptionMethodId"].value != serverSettings.getValueOfKey("encryptionMethodId")) {
            var encryptionMethodLoader = createObject("component", "API.com.Nephthys.controller.security.encryptionMethodLoader").init();
            
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
        
        return {
            "success" = true
        };
    }
    
    remote struct function activate() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setValueOfKey("active", true)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setValueOfKey("active", false)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activateMaintenanceMode() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setValueOfKey("maintenanceMode", true)
                      .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivateMaintenanceMode() {
        var serverSettings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        serverSettings.setValueOfKey("maintenanceMode", false)
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