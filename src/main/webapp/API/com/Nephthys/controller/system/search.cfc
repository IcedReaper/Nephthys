component extends="API.com.Nephthys.abstractClasses.search" {
    public search function search() {
        var modules = getModules();
        
        for(var i = 1; i <= modules.len(); ++i) {
            var searchExec = createObject("component", "API." & modules[i] & ".search").init()
                                                                                       .setSearchPhrase(variables.searchPhrase)
                                                                                       .search();
            variables.results[ modules[i] ] = searchExec.getResult().data;
            variables.resultCount += searchExec.getCount();
        }
        
        return this;
    }
    
    private array function getModules() {
        // TODO: refactor when I have a pretty idea for it... :/It bugs me that the API folder structure isn't the same as the module folder structure in WWW or ADMIN nor does it represent the modules in the DB
        return [
            "com.Nephthys.controller.page",
            "com.Nephthys.controller.user"/*,
            "com.IcedReaper.blog",
            "com.IcedReaper.gallery"*/
        ];
    }
}