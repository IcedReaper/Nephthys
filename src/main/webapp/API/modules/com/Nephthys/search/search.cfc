component extends="API.abstractClasses.search" {
    import "API.modules.com.Nephthys.moduleManager.*";
    
    public search function search() {
        var modules = getModules();
        
        for(var i = 1; i <= modules.len(); ++i) {
            var searchExec = createObject("component", "API.modules." & modules[i] & ".search").init()
                                                                                               .setSearchPhrase(variables.searchPhrase)
                                                                                               .search();
            variables.results[ modules[i] ] = searchExec.getResult().data;
            variables.resultCount += searchExec.getCount();
        }
        
        saveToStatistics(variables.searchPhrase, variables.resultCount);
        
        return this;
    }
    
    private array function getModules() {
        var modules = [];
        
        var moduleFilter = new filter().setFor("module")
                                       .setIntegratedSearch(true)
                                       .execute();
        for(var module in moduleFilter.getResult()) {
            modules.append(module.getModuleName());
        }
        
        return modules;
    }
    
    private void function saveToStatistics(required string searchPhrase, required numeric resultCount) {
        new Query().setSQL("INSERT INTO nephthys_search_statistics
                                        (
                                            searchString,
                                            referer,
                                            userId,
                                            resultCount
                                        )
                                 VALUES (
                                            :searchString,
                                            :referer,
                                            :userId,
                                            :resultCount
                                        )")
                   .addParam(name = "searchString", value = arguments.searchPhrase,   cfsqltype = "cf_sql_varchar")
                   .addParam(name = "referer",      value = cgi.HTTP_REFERER,         cfsqltype = "cf_sql_varchar")
                   .addParam(name = "userId",       value = request.user.getUserId(), cfsqltype = "cf_sql_integer", null = ! request.user.isActive())
                   .addParam(name = "resultCount",  value = arguments.resultCount,    cfsqltype = "cf_sql_integer")
                   .execute();
    }
}