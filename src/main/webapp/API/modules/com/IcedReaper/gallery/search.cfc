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
            
            variables.results.data.append({
                link         = "/Gallerie" & gallery.getLink(), /* TODO: Make page link e.g /Galleries dynamic */
                linkText     = gallery.getHeadline(),
                excerpt      = gallery.getIntroduction(),
                previewImage = gallery.getRelativePath() & "/" & gallery.getPictures()[1].getThumbnailFileName()
            });
        }
        variables.resultCount = qSearchResults.getRecordCount();
        
        return this;
    }
}