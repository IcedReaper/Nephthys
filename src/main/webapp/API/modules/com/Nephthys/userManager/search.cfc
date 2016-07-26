component extends="API.abstractClasses.search" {
    public search function search() {
        var qSearchResults = new Query().setSQL("  SELECT userId 
                                                     FROM nephthys_user
                                                    WHERE lower(username) LIKE :userName
                                                 ORDER BY userId")
                                        .addParam(name = "username", value = "%" & lCase(variables.searchPhrase) & "%", cfsqltype = "cf_sql_varchar")
                                        .execute()
                                        .getResult();
        variables.results = {
            data = []
        };
        variables.resultCount = 0;
        
        var aPages = createObject("component", "API.modules.com.Nephthys.pageManager.filter").init().setFor("pageWithModule")
                                                                                                    .setModuleName("com.Nephthys.userManager")
                                                                                                    .execute()
                                                                                                    .getResult(); 
        
        if(aPages.len() >= 1) {
            for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
                var user        = new user(qSearchResults.userId[i]);
                var description = "";
                
                var extPropertyFilter = new filter().setFor("extProperty")
                                                    .setUserId(qSearchResults.userId[i])
                                                    .setExtPropertyKeyName("description")
                                                    .execute()
                                                    .getResult();
                
                if(extPropertyFilter.len() == 1) {
                    description = extPropertyFilter[1].getValue();
                }
                
                variables.results.data.append({
                    link         = aPages[1].getLink() & "/" & user.getUsername(),
                    linkText     = user.getUsername(),
                    excerpt      = description,
                    previewImage = user.getAvatarPath()
                });
            }
            variables.resultCount = qSearchResults.getRecordCount();
        }
        
        return this;
    }
    
}