component extends="API.com.Nephthys.abstractClasses.search" {
    public search function search() {
        var qSearchResults = new Query().setSQL("  SELECT username 
                                                     FROM nephthys_user
                                                    WHERE lower(username) LIKE :userName
                                                 ORDER BY userId")
                                        .addParam(name = "username", value = "%" & variables.searchPhrase & "%", cfsqltype = "cf_sql_varchar")
                                        .execute()
                                        .getResult();
        variables.results = {
            data = []
        };
        
        for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
            variables.results.data.append({
                link    = "/user/" & qSearchResults.username[i],
                excerpt = qSearchResults.username[i]
            });
        }
        variables.resultCount = qSearchResults.getRecordCount();
        
        return this;
    }
}