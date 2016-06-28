component implements="WWW.interfaces.connector" {
    import "API.modules.com.Nephthys.search.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.search";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getWwwTheme().getFolderName() & ".modules.com.Nephthys.search.cfc.prepareData").prepareOptions(arguments.options);
        var splitParameter  = listToArray(request.page.getParameter(), "/");
        
        if(splitParameter.len() == 0 && form.isEmpty()) {
            return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("searchForm.cfm")
                .addParam("options", preparedOptions)
                .addParam("childContent",  arguments.childContent)
                .render();
        }
        else if(splitParameter.len() == 0 && ! form.isEmpty() && form.keyExists("searchStatement")) {
            var searchComponent = new search();
            
            var results = searchComponent.setSearchPhrase(form.searchStatement)
                                         .search()
                                         .getResult();
            
            if(searchComponent.getCount() > 0) {
                request.page.setTitle("Suchergebnisse");
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("searchResults.cfm")
                    .addParam("options", preparedOptions)
                    .addParam("childContent",  arguments.childContent)
                    .addParam("searchStatement", form.searchStatement)
                    .addParam("results",         results)
                    .addParam("resultCount",     searchComponent.getCount())
                    .render();
            }
            else {
                request.page.setTitle("Suche - Keine Ergebnisse");
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("noResults.cfm")
                    .addParam("options", preparedOptions)
                    .addParam("childContent",  arguments.childContent)
                    .render();
            }
        }
        else {            
            throw(type = "nephthys.notFound.page", message = "The search module only takes 0 parameters");
        }
    }
}