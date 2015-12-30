component extends="API.com.Nephthys.abstractClasses.search" {
    public search function search() {
        var qSearchResults = new Query().setSQL("   SELECT p.*, NULL c
                                                      FROM nephthys_page p
                                                     WHERE p.linktext    LIKE :searchLikePhrase
                                                        OR p.link        LIKE :searchLikePhrase
                                                        OR p.title       LIKE :searchLikePhrase
                                                        OR p.description LIKE :searchLikePhrase
                                                 UNION ALL
                                                    SELECT p.*, regExp_matches(p.content, '^.*""type""\s*:\s*""com.Nephthys.text""\s*,\s*""options""\s*:\s*{\s*""content""\s*:\s*""(.*?' || :searchPhrase || '.*?)"".*$', 'i') c
                                                      FROM nephthys_page p")
                                        .addParam(name = "searchLikePhrase", value = "%" & variables.searchPhrase & "%", cfsqltype = "cf_sql_varchar")
                                        .addParam(name = "searchPhrase",     value = variables.searchPhrase,             cfsqltype = "cf_sql_varchar")
                                        .execute()
                                        .getResult();
        
        variables.results = {
            data = []
        };
        
        for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
            variables.results.data.append({
                link    = qSearchResults.link[i],
                excerpt = isArray(qSearchResults.c[i]) ? qSearchResults.c[i][1] : qSearchResults.linktext[i]
            });
        }
        variables.resultCount = qSearchResults.getRecordCount();
        
        return this;
    }
}