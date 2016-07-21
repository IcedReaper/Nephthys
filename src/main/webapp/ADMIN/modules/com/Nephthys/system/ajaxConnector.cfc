component {
    import "API.modules.com.Nephthys.system.*";
    
    remote array function getSettings() {
        var serverSettings = new settings("WWW,ADMIN,NULL");
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
        var serverSettings = new settings().load();
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
    
    
    remote struct function getModuleSettings(required string moduleName) {
        if(arguments.moduleName != "") {
            return application.system.settings.getAllSettingsForModuleName(arguments.moduleName);
        }
        else {
            throw(type = "nephthys.application.invalid", message = "Please specify a module");
        }
    }
    
    remote boolean function saveModuleSettings(required string moduleName, required string settings) {
        var newSettings = deserializeJSON(arguments.settings);
        
        for(var setting in newSettings) {
            if(newSettings[setting].keyExists("rawValue")) {
                application.system.settings.setValueOfKey(setting, newSettings[setting].rawValue);
            }
        }
        
        application.system.settings.save();
        
        return true;
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