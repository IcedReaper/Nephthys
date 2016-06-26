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
        
        for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
            var user          = new user(qSearchResults.userId[i]);
            var extProperties = user.getExtProperties();
            
            variables.results.data.append({
                link         = "/user/" & user.getUsername(), // TODO: make /user dynamic
                linkText     = user.getUsername(),
                excerpt      = extProperties.getValue("description"),
                previewImage = user.getAvatarPath()
            });
        }
        variables.resultCount = qSearchResults.getRecordCount();
        
        return this;
    }
}