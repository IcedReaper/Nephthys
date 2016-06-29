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
                .addParam("options", preparedOptions)
                .addParam("childContent",  arguments.childContent)
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
                    .addParam("errors", errors)
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
            .render();
    }
}