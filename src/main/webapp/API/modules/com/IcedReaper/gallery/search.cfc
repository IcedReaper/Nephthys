component extends="API.abstractClasses.search" {
    public search function search() {
        var qSearchResults = new Query().setSQL("    SELECT g.galleryId
                                                       FROM IcedReaper_gallery_gallery g
                                                 INNER JOIN IcedReaper_gallery_Status s ON g.statusId = s.statusId
                                                      WHERE s.online = :online
                                                        AND (lower(g.headline) LIKE :searchLikePhrase
                                                         OR lower(g.description) LIKE :searchLikePhrase
                                                         OR lower(g.introduction) LIKE :searchLikePhrase
                                                         OR lower(g.story) LIKE '%candid%'
                                                         OR g.galleryId IN (    SELECT gc.galleryId
                                                                                  FROM IcedReaper_gallery_galleryCategory gc
                                                                            INNER JOIN IcedReaper_gallery_category c ON gc.categoryId = gc.categoryId
                                                                                 WHERE lower(c.name) LIKE :searchLikePhrase))")
                                        .addParam(name = "online",           value = 1,                                         cfsqltype = "cf_sql_bit")
                                        .addParam(name = "searchLikePhrase", value = "%" & lCase(variables.searchPhrase) & "%", cfsqltype = "cf_sql_varchar")
                                        .addParam(name = "searchPhrase",     value = lCase(variables.searchPhrase),             cfsqltype = "cf_sql_varchar")
                                        .execute()
                                        .getResult();
        
        variables.results = {
            data = []
        };
        
        for(var i = 1; i <= qSearchResults.getRecordCount(); ++i) {
            var gallery = new gallery(qSearchResults.galleryId[i]);
            
            var link = getLink(qSearchResults.galleryId[i]);
            if(link != "") {
                variables.results.data.append({
                    link         = link & gallery.getLink(),
                    linkText     = gallery.getHeadline(),
                    excerpt      = gallery.getIntroduction(),
                    previewImage = gallery.getRelativePath() & "/" & gallery.getPictures()[1].getThumbnailFileName()
                });
            }
        }
        variables.resultCount = qSearchResults.getRecordCount();
        
        return this;
    }
    
    private string function getLink(required numeric galleryId) {
        var qGetPages = new Query().setSQL("    SELECT pv.link, pv.content
                                                  FROM nephthys_page_pageVersion pv
                                            INNER JOIN nephthys_page_sitemapPage sp  ON sp.pageId    = pv.pageId
                                            INNER JOIN nephthys_page_sitemap     s   ON sp.sitemapId = s.sitemapId
                                            INNER JOIN nephthys_page_status      pvs ON pv.statusId  = pvs.statusId
                                            INNER JOIN nephthys_page_status      ss  ON s.statusId   = ss.statusId
                                                 WHERE pv.content LIKE :module
                                                   AND pvs.online = :online
                                                   AND ss.online  = :online")
                                   .addParam(name = "module", value = "%""type"":""com.IcedReaper.gallery""%", cfsqltype = "cf_sql_varchar")
                                   .addParam(name = "online", value = true,                                    cfsqltype = "cf_sql_bit")
                                   .execute()
                                   .getResult();
        
        if(qGetPages.getRecordCount() >= 1) {
            for(var i = 1; i <= qGetPages.getRecordCount(); ++i) {
                var content = deserializeJSON(qGetPages.content[i]);
                
                var galleryModules = getGalleryModules(content);
                for(var j = 1; j <= galleryModules.len(); j++) {
                    if(galleryModules[j].options.keyExists("galleryId") && isArray(galleryModules[j].options.galleryId) && ! galleryModules[j].options.galleryId.isEmpty()) {
                        if(galleryModules[j].options.galleryId.find(arguments.galleryId)) {
                            return qGetPages.link[i];
                        }
                    }
                    if(galleryModules[j].options.keyExists("categoryId") && isArray(galleryModules[j].options.categoryId) && ! galleryModules[j].options.categoryId.isEmpty()) {
                        if(new filter().setFor("gallery").setGalleryId(arguments.galleryId).setCategoryIdList(galleryModules[j].options.categoryId.toList(",")).execute().getResultCount() >= 1) {
                            return qGetPages.link[i];
                        }
                    }
                }
            }
            
            return qGetPages.link[1];
        }
    }
    
    private array function getGalleryModules(required array content) {
        var galleryModules = [];
        
        for(var i = 1; i <= arguments.content.len(); ++i) {
            if(arguments.content[i].type == "com.IcedReaper.gallery") {
                galleryModules.append(arguments.content[i]);
            }
            else {
                galleryModules = galleryModules.merge(getGalleryModules(arguments.content[i].children));
            }
        }
        
        return galleryModules;
    }
}