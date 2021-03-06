component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public sitemap function init(required numeric sitemapId) {
        variables.sitemapId = arguments.sitemapId;
        
        
        variables.statusChanged = false;
        
        variables.sitemapPages = [];
        variables.pagesLoaded    = false;
        variables.pagesChanged   = false;
        variables.pagesAdded     = [];
        variables.pagesRemoved   = [];
        
        load();
        
        return this;
    }
    
    public sitemap function setStatus(required status status) {
        variables.status = arguments.status;
        variables.statusChanged = true;
        return this;
    }
    
    public sitemap function setVersion(required numeric version) {
        if(variables.sitemapId == null) {
            variables.version = arguments.version;
        }
        return this;
    }
    
    
    public numeric function getSitemapId() {
        return variables.sitemapId;
    }
    
    public status function getStatus() {
        return variables.status;
    }
    
    public numeric function getversion() {
        return variables.version;
    }
    
    public user function getCreator() {
        return variables.creator;
    }
    
    public date function getCreationDate() {
        return variables.creationDate;
    }
    
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    public sitemap function updatePagesByRegion(required array regions) {
         new query().setSQL("DELETE FROM nephthys_page_sitemapPage
                                  WHERE sitemapId = :sitemapId")
                   .addParam(name = "sitemapId", value = sitemapId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        for(var region in arguments.regions) {
            saveSitemapLevel(region.regionId, null, region.pages);
        }
        
        return this;
    }
    
    public sitemap function pushToStatus(required status newStatus, required user user) {
        transaction {
            var actualStatus = duplicate(variables.status);
            
            variables.status = arguments.newStatus;
            
            if(variables.status.isOnline()) {
                var offlineStatus = new status(application.system.settings.getValueOfKey("endStatus"));
               
               var actualOnlineCtrl = new filter().for("sitemap")
                                                  .setOnline(true)
                                                  .execute();
               
               if(actualOnlineCtrl.getResultCount() == 1) {
                   actualOnlineCtrl.getResult()[1].setStatus(offlineStatus)
                                                  .save(arguments.user);
                }
            }
            
            save(arguments.user);
            
            new approval(null).setSitemap(this)
                              .setPrevStatus(actualStatus)
                              .setNewStatus(newStatus)
                              .save(arguments.user);
            
            transactionCommit();
        }
        
        return this;
    }
    
    
    public sitemap function save(required user user) {
        var qSave = new Query().addParam(name = "statusId", value = variables.status.getStatusId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "version",  value = variables.version,              cfsqltype = "cf_sql_numeric")
                               .addParam(name = "userId",   value = arguments.user.getUserId(),     cfsqltype = "cf_sql_numeric");
        
        if(variables.sitemapId == null) {
            variables.sitemapId = qSave.setSQL("INSERT INTO nephthys_page_sitemap
                                                              (
                                                                  statusId,
                                                                  version,
                                                                  creatorUserId,
                                                                  lastEditorUserId
                                                              )
                                                       VALUES (
                                                                  :statusId,
                                                                  :version,
                                                                  :userId,
                                                                  :userId
                                                              );
                                                  SELECT currval('nephthys_page_sitemap_sitemapId_seq') newSitemapId;")
                                         .execute()
                                         .getResult()
                                         .newSitemapId[1];
            
            variables.creator = arguments.user;
            variables.creationDate = now();
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        else {
            qSave.setSQL("UPDATE nephthys_page_sitemap
                             SET statusId         = :statusId,
                                 lastEditorUserId = :userId
                           WHERE sitemapId = :sitemapId")
                 .addParam(name = "sitemapId", value = variables.sitemapId, cfsqltype = "cf_sql_numeric")
                 .execute();
            
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        if(variables.status.getDeleteable()) {
            new Query().setSQL("DELETE FROM nephthys_page_sitemap
                                      WHERE sitemapId = :sitemapId")
                       .addParam(name = "sitemapId", variables = variables.sitemapId, cfsqltype="cf_sql_numeric")
                       .execute();
        }
        else {
            throw(type = "nephthys.application.notAllowed", message="You cannot delete a sitemap which status doesn't allow deletion.");
        }
    }
    
    private void function load() {
        if(variables.sitemapId != null) {
            var qSitemap = new Query().setSQL("SELECT *
                                                 FROM nephthys_page_sitemap
                                                WHERE sitemapId = :sitemapId")
                                      .addParam(name = "sitemapId", value = variables.sitemapId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qSitemap.getRecordCount() == 1) {
                variables.version      = qSitemap.version[1];
                variables.status       = new status(qSitemap.statusId[1]);
                variables.creator      = new user(qSitemap.creatorUserId[1]);
                variables.creationDate = qSitemap.creationDate[1];
                variables.lastEditor   = new user(qSitemap.lastEditorUserId[1]);
                variables.lastEditDate = qSitemap.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "Could not find the required sitemap");
            }
        }
        else {
            variables.version      = getMaxVersion() + 1;
            variables.status       = new status(application.system.settings.getValueOfKey("startStatus"));
            variables.creator      = request.user;
            variables.creationDate = now();
            variables.lastEditor   = request.user;
            variables.lastEditDate = now();
        }
    }
    
    private numeric function getMaxVersion() {
        var qMaxVersion = new Query().setSQL("SELECT MAX(version) maxVersion
                                                FROM nephthys_page_sitemap")
                                     .execute()
                                     .getResult();
        
        if(qMaxVersion.getRecordCount() == 1) {
            return qMaxVersion.maxVersion[1];
        }
        else {
            return 1;
        }
    }
    
    private void function loadPages() {
        variables.sitemapPages = [];
    }
    
    private boolean function saveSitemapLevel(required numeric regionId, required numeric parentPageId, required array pages) {
        for(var i = 1; i <= arguments.pages.len(); i++) {
            new Query().setSQL("INSERT INTO nephthys_page_sitemapPage
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
                       .addParam(name = "sitemapId",  value = variables.sitemapId,     cfsqltype = "cf_sql_numeric")
                       .addParam(name = "regionId",     value = arguments.regionId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "pageId",       value = arguments.pages[i].pageId, cfsqltype = "cf_sql_numeric")
                       .addParam(name = "parentPageId", value = arguments.parentPageId,    cfsqltype = "cf_sql_numeric", null = arguments.parentPageId == null)
                       .addParam(name = "sortOrder",    value = i,                         cfsqltype = "cf_sql_numeric")
                       .execute();
            
            if(arguments.pages[i].pages.len() > 0) {
                saveSitemapLevel(arguments.regionId, arguments.pages[i].pageId, arguments.pages[i].pages);
            }
        }
        
        return true;
    }
}