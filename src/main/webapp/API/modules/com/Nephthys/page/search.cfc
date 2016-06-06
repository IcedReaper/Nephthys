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
                                                               FROM nephthys_page_page p
                                                         INNER JOIN nephthys_page_pageVersion   pv ON p.pageId = pv.pageId
                                                         INNER JOIN nephthys_page_status        ps ON pv.statusId = ps.statusId
                                                         INNER JOIN nephthys_page_hierarchyPage hp ON p.pageId = hp.pageId
                                                         INNER JOIN nephthys_page_hierarchy     h  ON hp.hierarchyId = hp.hierarchyId
                                                         INNER JOIN nephthys_page_status        hs ON h.statusId = hs.statusId
                                                              WHERE ps.online = :online
                                                                AND hs.online = :online
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
                                                               FROM nephthys_page_page p
                                                         INNER JOIN nephthys_page_pageVersion    pv ON p.pageId = pv.pageId
                                                         INNER JOIN nephthys_page_status         ps ON pv.statusId = ps.statusId
                                                         INNER JOIN nephthys_page_hierarchyPage hp ON p.pageId = hp.pageId
                                                         INNER JOIN nephthys_page_hierarchy     h  ON hp.hierarchyId = hp.hierarchyId
                                                         INNER JOIN nephthys_page_status        hs ON h.statusId = hs.statusId
                                                              WHERE ps.online = :online
                                                                AND hs.online = :online) sq")
                                        .addParam(name = "online",            value = 1,                                  cfsqltype = "cf_sql_bit")
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