component {
    public sitemapPage function init(required numeric sitemapPageId) {
        variables.sitemapPageId = arguments.sitemapPageId;
        
        variables.attributesChanged = false;
        
        load();
        
        return this;
    }
    
    public sitemapPage function setSitemap(required sitemap sitemap) {
        if(variables.sitemapPageId == null) {
            variables.sitemap = arguments.sitemap;
        }
        return this;
    }
    
    public sitemapPage function setRegion(required region region) {
        variables.region = arguments.region;
        return this;
    }
    
    public sitemapPage function setPage(required page page) {
        variables.page = arguments.page;
        return this;
    }
    
    public sitemapPage function setParentPage(required page parentPage) {
        variables.parentPage = arguments.parentPage;
        return this;
    }
    
    public sitemapPage function setSortOrder(required numeric sortOrder) {
        variables.sortOrder = arguments.sortOrder;
        return this;
    }
    
    
    public numeric function getSitemapPageId() {
        return variables.sitemapPageId;
    }
    
    public sitemap function getSitemap() {
        return variables.sitemap;
    }
    
    public page function getPage() {
        return variables.page;
    }
    
    public page function getParentPage() {
        return variables.parentPage;
    }
    
    public numeric function getSortOrder() {
        return variables.sortOrder;
    }
    
    
    public sitemapPage function save() {
        var qSave = new Query().addParam(name = "sitemapId",  value = variables.sitemap.getSitemapId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "regionId",     value = variables.region.getRegionId(),       cfsqltype = "cf_sql_numeric")
                               .addParam(name = "pageId",       value = variables.page.getPageId(),           cfsqltype = "cf_sql_numeric")
                               .addParam(name = "parentPageId", value = variables.parentPageId.getPageId(),   cfsqltype = "cf_sql_numeric")
                               .addParam(name = "sortOrder",    value = variables.sortOrder,                  cfsqltype = "cf_sql_numeric");
        
        if(variables.sitemapPageId == null) {
            variables.sitemapPageId = qSave.setSQL("INSERT INTO nephthys_page_sitemapPage
                                                                  (
                                                                      sitemapId,
                                                                      regionId,
                                                                      pageId,
                                                                      parentPageId,
                                                                      sortOrder
                                                                  )
                                                           VALUES (
                                                                      :sitemapId,
                                                                      :regionId,
                                                                      :pageId,
                                                                      :parentPageId,
                                                                      :sortOrder
                                                                  )")
                                             .execute()
                                             .getResult()
                                             .newSitemapPageId[1];
        }
        else {
            qSave.setSQL("UPDATE nephthys_page_sitemapPage
                             SET regionId     = :regionId
                                 pageId       = :pageId
                                 parentPageId = :parentPageId
                                 sortOrder    = :sortOrder
                           WHERE sitemapPageId = sitemapPageId")
                 .addParam(name = "sitemapPageId", value = variables.sitemapPageId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        return this;
    }
    
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_page_sitemapPage
                                  WHERE sitemapPageId = :sitemapPageId")
                   .addParam(name = "sitemapPageId", value = variables.sitemapPageId, cfsqltype = "cf_sql_numeric")
                   .execute()
    }
    
    
    private void function load() {
        if(variables.sitemapPageId != null) {
            var qSitemapPage = new Query().setSQL("SELECT *
                                                       FROM nephthys_page_sitemapPage
                                                      WHERE sitemapPageId = :sitemapPageId")
                                            .addParam(name = "sitemapPageId", value = variables.sitemapPageId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
            
            if(qSitemapPage.getRecordCount() == 1) {
                variables.sitemap    = new sitemap(qSitemapPage.sitemapId[1]);
                variables.region     = new region(qSitemapPage.regionId[1]);
                variables.page       = new page(qSitemapPage.pageId[1]);
                variables.parentPage = new page(qSitemapPage.parentPageId[1]);
                variables.sortOrder  = qSitemapPage.sortOrder[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The sitemap page could not be found.");
            }
        }
        else {
            variables.sitemap    = new sitemap(null);
            variables.region     = new region(null);
            variables.page       = new page(null);
            variables.parentPage = new page(null);
            variables.sortOrder  = 1;
        }
    }
}