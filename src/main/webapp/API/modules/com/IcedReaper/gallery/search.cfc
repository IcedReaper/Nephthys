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
        var aPages = createObject("component", "API.modules.com.Nephthys.pageManager.filter").init()
                                                                                       .setFor("pageWithModule")
                                                                                       .setModuleName("com.IcedReaper.gallery")
                                                                                       .execute()
                                                                                       .getResult();
        
        if(aPages.len() >= 1) {
            for(var i = 1; i <= aPages.len(); ++i) {
                var galleryModules = getGalleryModules(deserializeJSON(aPages[i].content));
                for(var j = 1; j <= galleryModules.len(); j++) {
                    if(galleryModules[j].options.keyExists("galleryId") && isArray(galleryModules[j].options.galleryId) && ! galleryModules[j].options.galleryId.isEmpty()) {
                        if(galleryModules[j].options.galleryId.find(arguments.galleryId)) {
                            return aPages[i].link;
                        }
                    }
                    if(galleryModules[j].options.keyExists("categoryId") && isArray(galleryModules[j].options.categoryId) && ! galleryModules[j].options.categoryId.isEmpty()) {
                        var galleryInCategory = new filter().setFor("gallery")
                                                            .setGalleryId(arguments.galleryId)
                                                            .setCategoryIdList(galleryModules[j].options.categoryId.toList(","))
                                                            .execute()
                                                            .getResultCount() >= 1;
                        if(galleryInCategory) {
                            return aPages[i].link;
                        }
                    }
                }
            }
            
            return aPages[1].link;
        }
        return "";
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