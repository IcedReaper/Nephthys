component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.user";
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.user.cfc.prepareData").prepareOptions(arguments.options);
        var renderedContent = "";
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        
        var userListCtrl = createObject("component", "API.modules.com.Nephthys.user.filter").init();
        
        if(splitParameter.len() == 0 && form.isEmpty()) {
            saveContent variable="renderedContent" {
                module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/userSearch.cfm"
                       options      = preparedOptions
                       childContent = arguments.childContent;
            }
        }
        else if(splitParameter.len() == 0 && ! form.isEmpty()) {
            request.page.setTitle("Benutzersuche - Suchergebnisse");
            var user = userListCtrl.setUserName(form.username)
                                   .setUserNameLike(true)
                                   .execute()
                                   .getResult();
            
            saveContent variable="renderedContent" {
                module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/userSearchResults.cfm"
                       options      = preparedOptions
                       searchQuery  = form.username
                       results      = user
                       childContent = arguments.childContent;
            }
        }
        else if(splitParameter.len() == 1) {
            var user = userListCtrl.setUserName(splitParameter[1])
                                   .execute()
                                   .getResult();
            
            if(user.len() == 1) {
                request.page.setTitle("Benutzersuche - " & user[1].getUsername());
                
                saveContent variable="renderedContent" {
                    module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/userDetails.cfm"
                           options      = preparedOptions
                           user         = user[1]
                           childContent = arguments.childContent;
                }
            }
            else {
                request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                saveContent variable="renderedContent" {
                    module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/noResults.cfm"
                           options      = preparedOptions
                           childContent = arguments.childContent;
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
                                
                                renderedContent = createObject("WWW.modules." & privateMessagesModule & ".connector")
                                                      .init()
                                                      .render({
                                                          userId         = user.getUserId(),
                                                          otherParameter = otherParameter
                                                      }, "");
                            }
                            else {
                                saveContent variable="renderedContent" {
                                    module template  = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/noPermission.cfm"
                                           user      = user.getUsername()
                                           subModule = "Private Nachrichten";
                                }
                            }
                        }
                        else {
                            request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                            saveContent variable="renderedContent" {
                                module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/noResults.cfm"
                                       options      = preparedOptions
                                       childContent = arguments.childContent;
                            }
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
        
        return renderedContent;
    }
    
    public string function renderUserMenu() {
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/userMenu.cfm";
        }
        
        return renderedContent;
    }
}