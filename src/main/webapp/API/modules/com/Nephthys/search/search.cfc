component extends="API.abstractClasses.search" {
    import "API.modules.com.Nephthys.module.*";
    
    public search function search() {
        var modules = getModules();
        
        for(var i = 1; i <= modules.len(); ++i) {
            var searchExec = createObject("component", "API.modules." & modules[i] & ".search").init()
                                                                                               .setSearchPhrase(variables.searchPhrase)
                                                                                               .search();
            variables.results[ modules[i] ] = searchExec.getResult().data;
            variables.resultCount += searchExec.getCount();
        }
        
        return this;
    }
    
    private array function getModules() {
        var modules = [];
        
        var moduleFilter = new filter().setIntegratedSearch(true).execute();
        for(var module in moduleFilter.getResult()) {
            modules.append(module.getModuleName());
        }
        
        return modules;
    }
}