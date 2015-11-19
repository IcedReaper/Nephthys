component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "search";
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.search.cfc.prepareData").prepareOptions(arguments.options);
        var renderedContent = "";
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        
        if(splitParameter.len() == 0 && form.isEmpty()) {
            saveContent variable="renderedContent" {
                module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/search/templates/searchForm.cfm"
                       options      = preparedOptions
                       childContent = arguments.childContent;
            }
        }
        else if(splitParameter.len() == 0 && ! form.isEmpty()) {
            var results = [];
            
            if(results.len() > 0) {
                request.page.setTitle("Benutzersuche - Ergebnisliste");
                
                saveContent variable="renderedContent" {
                    module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/search/templates/searchResults.cfm"
                           options      = preparedOptions
                           searchQuery  = form.searchStatement
                           results      = []
                           childContent = arguments.childContent;
                }
            }
            else {
                request.page.setTitle("Benutzersuche - Keine Ergebnisse");
                
                saveContent variable="renderedContent" {
                    module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/search/templates/noResults.cfm"
                           options      = preparedOptions
                           childContent = arguments.childContent;
                }
            }
        }
        else {            
            throw(type = "nephthys.notFound.page", message = "The search module only takes 0 or 1 parameters");
        }
        
        return renderedContent;
    }
}