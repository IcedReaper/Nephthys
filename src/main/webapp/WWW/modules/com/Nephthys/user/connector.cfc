component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "user";
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.user.cfc.prepareData").prepareOptions(arguments.options);
        var renderedContent = "";
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        
        if(splitParameter.len() == 0 && form.isEmpty()) {
            saveContent variable="renderedContent" {
                module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/userSearch.cfm"
                       options      = preparedOptions
                       childContent = arguments.childContent;
            }
        }
        else if((splitParameter.len() == 0 && ! form.isEmpty()) || splitParameter.len() == 1) {
            var userListCtrl = createObject("component", "API.com.Nephthys.controller.user.userList").init();
            
            if(splitParameter.len() == 1) {
                var user = userListCtrl.search(splitParameter[1], false);
                
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
            else {
                request.page.setTitle("Benutzersuche - Suchergebnisse");
                
                saveContent variable="renderedContent" {
                    module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/user/templates/userSearchResults.cfm"
                           options      = preparedOptions
                           searchQuery  = form.username
                           results      = userListCtrl.search(form.username, true)
                           childContent = arguments.childContent;
                }
            }
        }
        else {            
            throw(type = "nephthys.notFound.page", message = "The user module only takes 0 or 1 parameters");
        }
        
        return renderedContent;
    }
}