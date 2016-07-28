component implements="WWW.interfaces.connector" {
    import "API.modules.com.Nephthys.userManager.*";
    import "API.tools.com.Nephthys.security.encryptionMethodLoader";
    import "API.modules.com.Nephthys.themeManager.theme";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.userManager";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.userManager.cfc.prepareData").prepareOptions(arguments.options);
        var splitParameter  = listToArray(request.page.getParameter(), "/");
        var userListCtrl    = new filter().for("user");
        
        if(splitParameter.len() == 0) {
            if(! form.isEmpty() && form.keyExists("username") && form.username != "" && form.keyExists("name") && form.name == "com.Nephthys.userManager") {
                request.page.setTitle("Benutzersuche - Suchergebnisse");
                var user = userListCtrl.setUserName(form.username)
                                       .setUserNameLike(true)
                                       .execute()
                                       .getResult();
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("userSearchResults.cfm")
                    .addParam("options",      preparedOptions)
                    .addParam("childContent", arguments.childContent)
                    .addParam("searchQuery",  form.username)
                    .addParam("results",      user)
                    .render();
            }
            else {
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("userSearch.cfm")
                    .addParam("options",      preparedOptions)
                    .addParam("childContent", arguments.childContent)
                    .render();
            }
        }
        else if(splitParameter.len() == 1) {
            if(splitParameter[1] == "registrieren") {
                var errors = {
                    error                  = false,
                    registrationSuccessful = false,
                    email                  = false,
                    emailUsed              = false,
                    username               = false,
                    usernameUsed           = false,
                    usernameBlocked        = false,
                    password               = false
                };
                
                if(url.keyExists("register") && ! form.isEmpty() && form.keyExists("username") && form.keyExists("email") && form.keyExists("password")) {
                    var encryptionMethodLoader = new encryptionMethodLoader();
                    var validator = application.system.settings.getValueOfKey("validator");
                    
                    if(! validator.validate(form.email, "Email")) {
                        errors.email = true;
                        errors.error = true;
                    }
                    if(form.password == "") {
                        errors.password = true;
                        errors.error = true;
                    }
                    if(form.username == "") {
                        errors.username = true;
                        errors.error = true;
                    }
                    if(new filter().for("user").setUsername(form.username).execute().getResultCount() != 0) {
                        errors.usernameUsed = true;
                        errors.error = true;
                    }
                    if(new filter().for("user").setEmail(form.email).execute().getResultCount() != 0) {
                        errors.emailUsed = true;
                        errors.error = true;
                    }
                    
                    if(! errors.error) {
                        var user = new user().setUserName(form.username)
                                             .setEmail(form.email)
                                             .setPassword(encrypt(form.password,
                                                          application.system.settings.getValueOfKey("encryptionKey"),
                                                          encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId"))))
                                             .setStatus(new status(application.system.settings.getValueOfKey("com.Nephthys.userManager.defaultStatus")));
                        try {
                            user.save(request.user);
                        }
                        catch(database dbe) {
                            if(dbe.sqlState == 23514) {
                                errors.username = true;
                                errors.usernameBlocked = true;
                                errors.error = true;
                            }
                            else {
                                rethrow(dbe);
                            }
                        }
                        
                        if(! errors.error) {
                            errors.registrationSuccessful = true;
                        }
                    }
                }
                
                request.page.setTitle("Registriere Dich noch heute!");
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("register.cfm")
                    .addParam("errors",   errors)
                    .render();
            }
            else {
                var user = userListCtrl.setUserName(splitParameter[1])
                                       .execute()
                                       .getResult();
                
                if(user.len() == 1) {
                    request.page.setTitle("Benutzersuche - " & user[1].getUsername());
                    
                    return application.system.settings.getValueOfKey("templateRenderer")
                        .setModulePath(getModulePath())
                        .setTemplate("userDetails.cfm")
                        .addParam("options",      preparedOptions)
                        .addParam("childContent", arguments.childContent)
                        .addParam("user",         user[1])
                        .render();
                }
                else {
                    request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                    
                    return application.system.settings.getValueOfKey("templateRenderer")
                        .setModulePath(getModulePath())
                        .setTemplate("noResults.cfm")
                        .addParam("options",      preparedOptions)
                        .addParam("childContent", arguments.childContent)
                        .render();
                }
            }
        }
        else if(splitParameter.len() >= 2) { // private message can have more parameter e.g. /conversation/id /message/id
            switch(splitParameter[2]) {
                case "edit": {
                    var user = userListCtrl.setUserName(splitParameter[1])
                                           .execute()
                                           .getResult();
                    if(user.len() == 1) {
                        if(user[1].getUserId() == request.user.getUserId()) {
                            var result = {
                                error = false,
                                success = false,
                                errors = {
                                    theme = false
                                }
                            };
                            
                            if(! form.isEmpty() && form.keyExists("name") && form.name == "com.Nephthys.userManager.edit") {
                                try {
                                    new theme(form.themeId);
                                }
                                catch(themeNotFound tnf) {
                                    result.errors.theme = true;
                                    result.error = true;
                                }
                                
                                if(! result.error) {
                                    if(form.password.trim() != "") {
                                        var encryptionMethodLoader = new encryptionMethodLoader();
                                        
                                        request.user.setPassword(encrypt(form.password,
                                                                         application.system.settings.getValueOfKey("encryptionKey"),
                                                                         encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId"))));
                                    }
                                    
                                    request.user.setWwwThemeId(form.themeId);
                                    
                                    if(form.avatar != "") {
                                        request.user.uploadAvatar();
                                    }
                                    
                                    transaction {
                                        request.user.save(request.user);
                                        
                                        var lastExtPropertyKeyId = 0;
                                        for(var fieldName in listToArray(listSort(form.fieldNames, "text"), ",")) {
                                            if(left(fieldName, 13) == "extProperties") {
                                                var extPropertyKeyId = reReplace(fieldName, "extProperties_(\d+)_\d*_\w+", "\1");
                                                if(extPropertyKeyId != lastExtPropertyKeyId) {
                                                    lastExtPropertyKeyId = extPropertyKeyId;
                                                    var extPropertyId = reReplace(fieldName, "extProperties_\d+_(\d*)_\w+", "\1");
                                                    var extPropertyKey = new extPropertyKey(extPropertyKeyId);
                                                    
                                                    var val    = form["extProperties_" & extPropertyKeyId & "_" & extPropertyId & "_value"];
                                                    var public = form["extProperties_" & extPropertyKeyId & "_" & extPropertyId & "_public"];
                                                    
                                                    if(extPropertyKey.getType() == "date") {
                                                        val = replace(val, '-', '/', 'ALL');
                                                    }
                                                    
                                                    if(extPropertyId == "") {
                                                        extPropertyId = null;
                                                    }
                                                    
                                                    if(val != "") {
                                                        var extProperty = new extProperty(extPropertyId).setValue(val)
                                                                                                        .setPublic(public);
                                                        
                                                        if(extPropertyId == "") {
                                                            extProperty.setExtPropertyKey(extPropertyKey)
                                                                       .setUser(request.user);
                                                        }
                                                        
                                                        extProperty.save(request.user);
                                                    }
                                                    else {
                                                        if(extPropertyId != null) {
                                                            new extProperty(extPropertyId).delete(request.user);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        result.success = true;
                                        
                                        transactionCommit();
                                    }
                                }
                            }
                            
                            var themeFilter = createObject("component", "API.modules.com.Nephthys.themeManager.filter").init().for("theme")
                                                                                                                              .setActive(true)
                                                                                                                              .setAvailableWww(true)
                                                                                                                              .execute();
                            
                            var extPropertyFilter = new filter().for("extProperty")
                                                                .setUserId(request.user.getUserId())
                                                                .execute();
                            
                            var extProperties = extPropertyFilter.getResult();
                            
                            var extPropertyKeyFilter = new filter().for("extPropertyKey")
                                                                   .execute();
                            for(var extPropertyKey in extPropertyKeyFilter.getResult()) {
                                var found = false;
                                for(var i = 1; i <= extProperties.len(); ++i) {
                                    if(extProperties[i].getExtPropertyKey().getExtPropertyKeyId() == extPropertyKey.getExtPropertyKeyId()) {
                                        found = true;
                                        break;
                                    }
                                }
                                
                                if(! found) {
                                    extProperties.append(new extProperty(null).setExtPropertyKey(extPropertyKey)
                                                                              .setUser(request.user));
                                }
                            }
                            
                            return application.system.settings.getValueOfKey("templateRenderer")
                                .setModulePath(getModulePath())
                                .setTemplate("editProfile.cfm")
                                .addParam("options",       preparedOptions)
                                .addParam("childContent",  arguments.childContent)
                                .addParam("themes",        themeFilter.getResult())
                                .addParam("extProperties", extProperties)
                                .addParam("result",        result)
                                .render();
                        }
                        else {
                            throw(type = "nephthys.application.notAllowed", message = "You're not allowed to update a user profile other than yours");
                        }
                    }
                    else {
                        throw(type = "nephthys.application.notAllowed", message = "Couldn't find the user you tried to edit");
                    }
                    
                    break;
                }
                case "privateMessages": {
                    var privateMessagesModule = application.system.settings.getValueOfKey("privateMessageModule");
                    
                    if(privateMessagesModule != null) {
                        var tmpUser = userListCtrl.setUserName(splitParameter[1])
                                                  .execute()
                                                  .getResult();
                        
                        if(tmpUser.len() == 1) {
                            var user = tmpUser[1];
                            
                            if(user.getUserId() == request.user.getUserId()) {
                                var otherParameter = duplicate(splitParameter);
                                otherParameter.deleteAt(1); // username
                                otherParameter.deleteAt(1); // privateMessages
                                
                                return createObject("WWW.modules." & privateMessagesModule & ".connector")
                                           .init()
                                           .render({
                                               userId         = user.getUserId(),
                                               otherParameter = otherParameter
                                           }, "");
                            }
                            else {
                                return application.system.settings.getValueOfKey("templateRenderer")
                                    .setModulePath(getModulePath())
                                    .setTemplate("noPermission.cfm")
                                    .addParam("options",   preparedOptions)
                                    .addParam("user",      user.getUsername())
                                    .addParam("subModule", "Private Nachrichten")
                                    .render();
                            }
                        }
                        else {
                            request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                            
                            return application.system.settings.getValueOfKey("templateRenderer")
                                .setModulePath(getModulePath())
                                .setTemplate("noResults.cfm")
                                .addParam("options",      preparedOptions)
                                .addParam("childContent", arguments.childContent)
                                .render();
                        }
                    }
                    else {
                        throw(type = "nephthys.notFound.user", message = "Module not found / inactive");
                    }
                    
                    break;
                }
                case "permissionRequest": {
                    var permissionRequestModule = application.system.settings.getValueOfKey("permissionRequestModule");
                    
                    if(permissionRequestModule != null) {
                        var tmpUser = userListCtrl.setUserName(splitParameter[1])
                                                  .execute()
                                                  .getResult();
                        
                        if(tmpUser.len() == 1) {
                            var user = tmpUser[1];
                            
                            if(user.getUserId() == request.user.getUserId()) {
                                var otherParameter = duplicate(splitParameter);
                                otherParameter.deleteAt(1); // username
                                otherParameter.deleteAt(1); // permissionRequest
                                
                                return createObject("WWW.modules." & permissionRequestModule & ".connector")
                                           .init()
                                           .render({
                                               userId         = user.getUserId(),
                                               otherParameter = otherParameter
                                           }, "");
                            }
                            else {
                                return application.system.settings.getValueOfKey("templateRenderer")
                                    .setModulePath(getModulePath())
                                    .setTemplate("noPermission.cfm")
                                    .addParam("options",   preparedOptions)
                                    .addParam("user",      user.getUsername())
                                    .addParam("subModule", "Private Nachrichten")
                                    .render();
                            }
                        }
                        else {
                            request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                            
                            return application.system.settings.getValueOfKey("templateRenderer")
                                .setModulePath(getModulePath())
                                .setTemplate("noResults.cfm")
                                .addParam("options",      preparedOptions)
                                .addParam("childContent", arguments.childContent)
                                .render();
                        }
                    }
                    else {
                        throw(type = "nephthys.notFound.user", message = "Module not found / inactive");
                    }
                    break;
                }
                default: {
                    throw(type = "nephthys.notFound.user", message = "Invalid permission to user module");
                }
            }
        }
        
        return "";
    }
    
    public string function renderUserMenu() {
        var renderedContent = "";
        
        var privateMessagesModule = application.system.settings.getValueOfKey("privateMessageModule");
        
        var privateMessages = [];
        if(privateMessagesModule != null && request.user.getStatus().getCanLogin()) {
            privateMessages = createObject("API.modules." & privateMessagesModule & ".filter")
                                  .init()
                                  .for("conversation")
                                  .setParticipantId(request.user.getUserId())
                                  .setUnreadOnly(true)
                                  .execute()
                                  .getResult();
        }
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("userMenu.cfm")
            .addParam("privateMessages", privateMessages)
            .render();
    }
}