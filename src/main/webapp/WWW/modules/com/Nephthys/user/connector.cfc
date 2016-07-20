component implements="WWW.interfaces.connector" {
    import "API.modules.com.Nephthys.user.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.user";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.user.cfc.prepareData").prepareOptions(arguments.options);
        var splitParameter  = listToArray(request.page.getParameter(), "/");
        var userListCtrl    = new filter().setFor("user");
        
        if(splitParameter.len() == 0 && form.isEmpty()) {
            return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("userSearch.cfm")
                .addParam("options",      preparedOptions)
                .addParam("childContent", arguments.childContent)
                .addParam("userPage",     getUserLink())
                .render();
        }
        else if(splitParameter.len() == 0 && ! form.isEmpty()) {
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
                .addParam("userPage",     getUserLink())
                .render();
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
                    password               = false
                };
                
                if(url.keyExists("register") && ! form.isEmpty() && form.keyExists("username") && form.keyExists("email") && form.keyExists("password")) {
                    var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
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
                    if(new filter().setUsername(form.username).execute().getResultCount() != 0) {
                        errors.usernameUsed = true;
                        errors.error = true;
                    }
                    if(new filter().setEmail(form.email).execute().getResultCount() != 0) {
                        errors.emailUsed = true;
                        errors.error = true;
                    }
                    
                    if(! errors.error) {
                        var user = new user().setUserName(form.username)
                                             .setEmail(form.email)
                                             .setPassword(encrypt(form.password,
                                                          application.system.settings.getValueOfKey("encryptionKey"),
                                                          encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId"))))
                                             .save();
                        
                        errors.registrationSuccessful = true;
                    }
                }
                
                request.page.setTitle("Registriere Dich noch heute!");
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("register.cfm")
                    .addParam("errors",   errors)
                    .addParam("userPage", getUserLink())
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
                        .addParam("userPage",     getUserLink())
                        .render();
                }
                else {
                    request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                    
                    return application.system.settings.getValueOfKey("templateRenderer")
                        .setModulePath(getModulePath())
                        .setTemplate("noResults.cfm")
                        .addParam("options",      preparedOptions)
                        .addParam("childContent", arguments.childContent)
                        .addParam("userPage",     getUserLink())
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
                            
                            if(! form.isEmpty() && form.keyExists("name") && form.name == "com.Nephthys.user.edit") {
                                try {
                                    createObject("component", "API.modules.com.Nephthys.theme.theme").init(form.themeId);
                                }
                                catch(themeNotFound tnf) {
                                    result.errors.theme = true;
                                    result.error = true;
                                }
                                
                                if(! result.error) {
                                    if(form.password.trim() != "") {
                                        var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
                                        
                                        request.user.setPassword(encrypt(form.password,
                                                                         application.system.settings.getValueOfKey("encryptionKey"),
                                                                         encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId"))));
                                    }
                                    
                                    request.user.setWwwThemeId(form.themeId);
                                    
                                    if(form.avatar != "") {
                                        request.user.uploadAvatar();
                                    }
                                    
                                    transaction {
                                        request.user.save();
                                        
                                        var lastExtPropertyKeyId = 0;
                                        for(var fieldName in listToArray(listSort(form.fieldNames, "text"), ",")) {
                                            if(left(fieldName, 13) == "extProperties") {
                                                var extPropertyKeyId = reReplace(fieldName, "extProperties_(\d+)_\d*_\w+", "\1");
                                                if(extPropertyKeyId != lastExtPropertyKeyId) {
                                                    lastExtPropertyKeyId = extPropertyKeyId;
                                                    var extPropertyId = reReplace(fieldName, "extProperties_\d+_(\d*)_\w+", "\1");
                                                    
                                                    var val    = form["extProperties_" & extPropertyKeyId & "_" & extPropertyId & "_value"];
                                                    var public = form["extProperties_" & extPropertyKeyId & "_" & extPropertyId & "_public"];
                                                    
                                                    if(val != "") {
                                                        var extProperty = new extProperty(extPropertyId).setValue(value)
                                                                                                        .setPublic(public);
                                                        
                                                        if(extPropertyId == "") {
                                                            extProperty.setExtPropertyKey(new extPropertyKey(extPropertyKeyId))
                                                                       .setUser(request.user);
                                                        }
                                                        
                                                        extProperty.save();
                                                    }
                                                    else {
                                                        new extProperty(extPropertyId).delete();
                                                    }
                                                }
                                            }
                                        }
                                        extProperties.save();
                                        
                                        result.success = true;
                                        
                                        transactionCommit();
                                    }
                                }
                            }
                            
                            var themeFilter = createObject("component", "API.modules.com.Nephthys.theme.filter").init()
                                                                                                                .setActive(true)
                                                                                                                .setAvailableWww(true)
                                                                                                                .execute();
                            
                            var extPropertyFilter = new filter().setFor("extProperty")
                                                                .setUserId(request.user.getUserId())
                                                                .execute();
                            
                            var extProperties = extPropertyFilter.getResult();
                            
                            var extPropertyKeyFilter = new filter().setFor("extPropertyKey")
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
                                    // TODO: Add not set properties
                                }
                            }
                            
                            return application.system.settings.getValueOfKey("templateRenderer")
                                .setModulePath(getModulePath())
                                .setTemplate("editProfile.cfm")
                                .addParam("options",       preparedOptions)
                                .addParam("childContent",  arguments.childContent)
                                .addParam("userPage",      getUserLink())
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
                                    .addParam("userPage",  getUserLink())
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
                                .addParam("userPage",     getUserLink())
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
                                    .addParam("userPage",  getUserLink())
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
                                .addParam("userPage",     getUserLink())
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
        if(privateMessagesModule != null && request.user.isActive()) {
            privateMessages = createObject("API.modules." & privateMessagesModule & ".filter")
                                  .init()
                                  .setFor("conversation")
                                  .setParticipantId(request.user.getUserId())
                                  .setUnreadOnly(true)
                                  .execute()
                                  .getResult();
        }
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("userMenu.cfm")
            .addParam("privateMessages", privateMessages)
            .addParam("userPage", getUserLink())
            .render();
    }
    
    private string function getUserLink() {
        var aPages = createObject("component", "API.modules.com.Nephthys.pages.filter").init()
                                                                                       .setFor("pageWithModule")
                                                                                       .setModuleName("com.Nephthys.user")
                                                                                       .execute()
                                                                                       .getResult(); 
        return aPages.len() >= 1 ? aPages[1].link : "";
    }
}