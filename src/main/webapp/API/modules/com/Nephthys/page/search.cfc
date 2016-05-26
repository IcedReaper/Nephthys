component extends="API.abstractClasses.search" {
    public search function search() {
        var qSearchResults = new Query().setSQL("SELECT DISTINCT sq.link,
                                                                 sq.linkText,
                                                                 sq.description,
                                                                 sq.title
                                                   FROM (    SELECT pv.link,
                                                                    pv.linkText,
                                                                    pv.description,
                                                                    pv.title,
                                                                    NULL c
                                                               FROM nephthys_page p
                                                         INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                                                         INNER JOIN nephthys_pageStatus ps ON pv.pageStatusId = ps.pageStatusId
                                                              WHERE ps.offline = :false
                                                                AND (pv.linktext   LIKE :searchLikePhrase
                                                                 OR pv.link        LIKE :searchLikePhrase
                                                                 OR pv.title       LIKE :searchLikePhrase
                                                                 OR pv.description LIKE :searchLikePhrase)
                                                         UNION ALL
                                                             SELECT pv.link,
                                                                    pv.linkText,
                                                                    pv.description,
                                                                    pv.title,
                                                                    regExp_matches(pv.content, '^.*""type""\s*:\s*""com.Nephthys.text""\s*,\s*""options""\s*:\s*{\s*""content""\s*:\s*""(.*?' || :searchPhrase || '.*?)"".*$', 'i') c
                                                               FROM nephthys_page p
                                                         INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                                                         INNER JOIN nephthys_pageStatus ps ON pv.pageStatusId = ps.pageStatusId
                                                              WHERE ps.offline = :false) sq")
                                        .addParam(name = "false",            value = 0,                                  cfsqltype = "cf_sql_bit")
                                        .addParam(name = "searchLikePhrase", value = "%" & variables.searchPhrase & "%", cfsqltype = "cf_sql_varchar")
                                        .addParam(name = "searchPhrase",     value = variables.searchPhrase,             cfsqltype = "cf_sql_varchar")
                                        .execute()
                                        .getResult();
        
        variables.results = {
            data = []
        };
        
        for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
            variables.results.data.append({
                link     = qSearchResults.link[i],
                linkText = qSearchResults.linktext[i],
                excerpt  = qSearchResults.description[i] != "" ? qSearchResults.description[i] : qSearchResults.title[i]
            });
        }
        variables.resultCount = qSearchResults.getRecordCount();
        
        return this;
    }
}