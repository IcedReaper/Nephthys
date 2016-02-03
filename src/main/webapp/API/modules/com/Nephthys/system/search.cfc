component extends="API.abstractClasses.search" {
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
        // TODO: refactor when I have a pretty idea for it... :/
        return [
            "modules.com.Nephthys.page",
            "modules.com.Nephthys.user"/*,
            "com.IcedReaper.blog",
            "com.IcedReaper.gallery"*/
        ];
    }
}