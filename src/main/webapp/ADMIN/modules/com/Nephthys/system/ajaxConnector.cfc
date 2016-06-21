component {
    remote array function getSettings() {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        serverSettings.load();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var settings = duplicate(serverSettings.getAllSettings());
        
        var configurations = [];
        var index = 0;
        for(var key in settings) {
            configurations[++index] = settings[key];
            configurations[index].key = key;
            
            if(configurations[index].moduleId == null) {
                configurations[index].moduleId = 0;
            }
            if(configurations[index].moduleName == null) {
                configurations[index].moduleName = "";
            }
            
            configurations[index].hidden           = configurations[index].hidden           == 1;
            configurations[index].systemKey        = configurations[index].systemKey        == 1;
            configurations[index].alwaysRevalidate = configurations[index].alwaysRevalidate == 1;
            configurations[index].readonly         = configurations[index].readonly         == 1;
            
            if(lcase(settings[key].type) == "datetime") {
                configurations[index].value = settings[key].value != null ? formatCtrl.formatDate(settings[key].value, true, "DD.MM.YYYY") : "";
            }
            if(lcase(settings[key].type) == "date") {
                configurations[index].value = settings[key].value != null ? formatCtrl.formatDate(settings[key].value, false, "DD.MM.YYYY") : "";
            }
            configurations[index].delete("foreignTableOptions");
        }
        
        return configurations;
    }
    
    remote boolean function saveSettings(required array settings) {
        var serverSettings = createObject("component", "API.modules.com.Nephthys.system.settings").init().load();
        var resetAllPasswords = false;
        
        transaction {
            try {
                for(var setting in arguments.settings) {
                    if(setting.key != "encryptionMethodId" && setting.key != "encryptionKey") {
                        if(setting.keyExists("value")) {
                            if(! serverSettings.isKeyReadonly(setting.key)) {
                                serverSettings.setValueOfKey(setting.key, setting.rawValue);
                            }
                        }
                    }
                    else {
                        if(setting.key == "encryptionMethodId" && setting.value != serverSettings.getValueOfKey("encryptionMethodId")) {
                            var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
            
                            var newAlgorithm = encryptionMethodLoader.getAlgorithm(setting.value);
                            var newSecretKey = generateSecretKey(newAlgorithm);
                            
                            resetPasswordOfAllUsers(newSecretKey,
                                                    newAlgorithm,
                                                    serverSettings.getValueOfKey("encryptionKey"),
                                                    encryptionMethodLoader.getAlgorithm(serverSettings.getValueOfKey("encryptionMethodId")));
                            
                            serverSettings.setValueOfKey("encryptionMethodId", setting.value)
                                          .setValueOfKey("encryptionKey", newSecretKey);
                        }
                    }
                }
                serverSettings.save();
                
                transactionCommit();
            }
            catch(any e) {
                transactionRollback();
                throw(object=e);
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