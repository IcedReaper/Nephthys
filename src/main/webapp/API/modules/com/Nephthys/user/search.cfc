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
        
        var link = getLink();
        if(link != "") {
            for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
                var user          = new user(qSearchResults.userId[i]);
                var extProperties = user.getExtProperties();
                
                variables.results.data.append({
                    link         = link & "/" & user.getUsername(),
                    linkText     = user.getUsername(),
                    excerpt      = extProperties.getValue("description"),
                    previewImage = user.getAvatarPath()
                });
            }
            variables.resultCount = qSearchResults.getRecordCount();
        }
        
        return this;
    }
    
    private string function getLink() {
        var qGetPages = new Query().setSQL("    SELECT pv.link
                                                  FROM nephthys_page_pageVersion pv
                                            INNER JOIN nephthys_page_sitemapPage sp  ON sp.pageId    = pv.pageId
                                            INNER JOIN nephthys_page_sitemap     s   ON sp.sitemapId = s.sitemapId
                                            INNER JOIN nephthys_page_status      pvs ON pv.statusId  = pvs.statusId
                                            INNER JOIN nephthys_page_status      ss  ON s.statusId   = ss.statusId
                                                 WHERE pv.content LIKE :module
                                                   AND pvs.online = :online
                                                   AND ss.online  = :online")
                                   .addParam(name = "module", value = "%""type"":""com.Nephthys.user""%", cfsqltype = "cf_sql_varchar")
                                   .addParam(name = "online", value = true,                               cfsqltype = "cf_sql_bit")
                                   .execute()
                                   .getResult();
        
        if(qGetPages.getRecordCount() == 1) {
            return qGetPages.link[1];
        }
        
        return "";
    }
}