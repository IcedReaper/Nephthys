component extends="API.com.Nephthys.abstractClasses.search" {
    public search function search() {
        var modules = [
            "com.Nephthys.controller.page",
            "com.Nephthys.controller.user"/*,
            "com.IcedReaper.blog",
            "com.IcedReaper.gallery"*/
        ];
        
        for(var i = 1; i <= modules.len(); ++i) {
            var searchExec = createObject("component", "API." & modules[i] & ".search").init()
                                                                                       .setSearchPhrase(variables.searchPhrase)
                                                                                       .search();
            variables.results[ modules[i] ] = searchExec.getResult().data;
            variables.resultCount += searchExec.getCount();
        }
        
        return this;
    }
}